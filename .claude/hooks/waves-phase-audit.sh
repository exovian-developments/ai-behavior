#!/bin/bash
# waves-phase-audit.sh — PostToolUse hook for Waves 2.0
# Triggers strategic audit when a roadmap phase is completed.
#
# Detects: edit to */roadmap.json where a phase status changed to "completed"/"achieved"
# Action: injects additionalContext prompting comprehensive strategic analysis
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for strategic audit prompt

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a roadmap file
if [[ "$FILE" != */roadmap.json ]]; then
  echo '{}'
  exit 0
fi

# Quick exit: file doesn't exist
if [ ! -f "$FILE" ]; then
  echo '{}'
  exit 0
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo '{}'
  exit 0
fi

# Count completed phases
PHASES_COMPLETED=$(jq '[.phases[] | select(.status == "completed" or .status == "achieved")] | length' "$FILE" 2>/dev/null || echo 0)

# Read marker to detect change
MARKER_DIR="/tmp/waves-phase-audit"
mkdir -p "$MARKER_DIR" 2>/dev/null
MARKER_FILE="$MARKER_DIR/$(echo "$FILE" | md5 2>/dev/null || echo "$FILE" | md5sum 2>/dev/null | cut -d' ' -f1)"
LAST_COUNT=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)

# Update marker
echo "$PHASES_COMPLETED" > "$MARKER_FILE"

# If count increased, a phase was just completed
if [ "$PHASES_COMPLETED" -gt "$LAST_COUNT" ]; then
  # Get the wave name from path
  WAVE=$(echo "$FILE" | sed 's|.*/waves/\([^/]*\)/roadmap.json|\1|')

  # Resolve project root
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
  AI_FILES="$PROJECT_DIR/ai_files"

  # Write pending marker — gate blocks until delegation
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "/tmp/waves-metacognition-pending"

  # Read metacognition model from user_pref.json (default: opus)
  META_MODEL="opus"
  for pref in "$AI_FILES/user_pref.json" "user_pref.json"; do
    if [ -f "$pref" ]; then
      CONFIGURED_MODEL=$(jq -r '.agent_config.metacognition_model // empty' "$pref" 2>/dev/null)
      [ -n "$CONFIGURED_MODEL" ] && META_MODEL="$CONFIGURED_MODEL"
      break
    fi
  done

  # Find blueprint
  BP=""
  for bp in "$AI_FILES/blueprint.json" "$AI_FILES/product_blueprint.json"; do
    [ -f "$bp" ] && BP="$bp" && break
  done

  # ALL roadmaps (not just this wave — other waves may be affected)
  ALL_ROADMAPS=""
  for rm in "$AI_FILES"/waves/*/roadmap.json; do
    [ -f "$rm" ] || continue
    ALL_ROADMAPS="$ALL_ROADMAPS\n- $rm"
  done
  ROADMAPS_PATHS=$(echo -e "$ALL_ROADMAPS" | grep -v '^$')

  # ALL logbooks (not just this wave)
  ALL_LOGBOOKS=""
  for lb in "$AI_FILES"/waves/*/logbooks/*.json; do
    [ -f "$lb" ] || continue
    ALL_LOGBOOKS="$ALL_LOGBOOKS\n- $lb"
  done
  LOGBOOKS_PATHS=$(echo -e "$ALL_LOGBOOKS" | grep -v '^$')

  MSG="METACOGNITION TRIGGERED — Roadmap phase completed ($WAVE).\n\nYou may still update Waves artifacts (logbooks, resolutions) — those are not blocked. Finish any pending artifact updates FIRST.\n\nOnce all artifact updates are done, you are BLOCKED from code changes until you:\n1. Spawn a background Agent (run_in_background=true, model=$META_MODEL) with the prompt below\n2. Write to any ai_files/ artifact (logbook, roadmap decision, or any artifact note) — this clears the gate\n\nThe gate unblocks on the first ai_files/ write after delegation. Continue working — the subagent analyzes in parallel.\n\nWhen the subagent returns:\n- If CRITICAL findings → classify as Level 4+, STOP, present to user immediately\n- If no critical findings → note in logbook and continue\n\n--- SUBAGENT PROMPT (use exactly as the prompt parameter) ---\nYou are a strategic advisor performing a phase completion audit for a product that uses the Waves framework.\n\nCONTEXT: Phase in wave '$WAVE' was just completed. This is a natural checkpoint — the team is about to start the next phase. Your job is to ensure the next phase starts on solid ground.\n\nREAD THESE FILES (all of them, completely):\n\nBlueprint:\n- ${BP:-not found}\n\nRoadmaps (the completed phase is in $FILE, but read ALL for cross-wave impact):\n$ROADMAPS_PATHS\n\nLogbooks (read each one):\n$LOGBOOKS_PATHS\n\nAfter reading, perform a strategic audit:\n\n1. READINESS CHECK FOR NEXT PHASE — Look at the next phase's milestones and objectives:\n   - Does the project have all prerequisites to start? (Infrastructure, accounts, credentials, APIs, design assets, legal requirements)\n   - Are there decisions from the completed phase that MUST be resolved before proceeding?\n   - Are there logbook objectives that were abandoned or left incomplete that the next phase depends on?\n   - Are there ambiguities in the next phase's milestones that will cause confusion during implementation?\n\n2. BLUEPRINT ALIGNMENT — Compare what was accomplished with what the blueprint promises:\n   - Which blueprint capabilities advanced during this phase?\n   - Are any capabilities falling behind or being implemented differently than designed?\n   - Do the design principles still hold, or has the implementation revealed they need revision?\n   - Is the product hypothesis still supported by the direction of implementation?\n\n3. STRATEGIC OPPORTUNITIES — Think about the big picture:\n   - Can upcoming phases be reordered to reduce dependencies or enable parallel work?\n   - Did this phase produce something reusable (a pattern, library, or tool) that saves effort later?\n   - Is there a faster path to validating the product hypothesis than what the roadmap currently plans?\n   - Should any planned capabilities be descoped based on what was learned?\n\nRESPONSE FORMAT:\n- If you find ANY critical findings: start with CRITICAL: then list each with phase numbers, capability IDs, and objective IDs. State what's at risk and what action is needed.\n- If no critical findings: respond with exactly 'No critical findings. Phase $WAVE audit complete.' and nothing else.\n\nBe specific and actionable. Under 400 words.\n--- END SUBAGENT PROMPT ---"

  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
