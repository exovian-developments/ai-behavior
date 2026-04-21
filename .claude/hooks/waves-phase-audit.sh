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

  MSG="METACOGNITION — Phase completed in $WAVE. BLOCKED until you delegate.\n\n1. Spawn background Agent (run_in_background=true, model=$META_MODEL) — COPY THE PROMPT BELOW EXACTLY.\n2. Write to any ai_files/ artifact — this clears the gate.\n\nWhen subagent returns with observations → share with the user. If nothing relevant → note and continue.\n\nPROMPT (copy as-is into the Agent prompt parameter):\nYou are an expert advisor. A roadmap phase was just completed in $WAVE. The team is about to start the next phase — your job is to ensure it starts on solid ground.\n\nRead ALL these files:\n${BP:-blueprint not found}\n$ROADMAPS_PATHS\n$LOGBOOKS_PATHS\n\nNow step back and assess readiness. Share your honest observations:\n\n- Is the next phase ready to start? Does the project have everything it needs — infrastructure, accounts, APIs, design assets, legal requirements? Are there decisions from the completed phase that must be resolved first? Were logbook objectives abandoned that the next phase depends on?\n- How aligned is the progress with the blueprint? Which capabilities advanced? Are any falling behind or diverging from the original design? Is the product hypothesis still supported by the direction of implementation?\n- Are there opportunities? Can upcoming phases be reordered to enable parallel work? Did this phase produce something reusable — a pattern, tool, or approach that saves effort later? Is there a faster path to validating the hypothesis?\n- SERENDIPITY: did this phase reveal something unexpected? A capability that's more valuable than planned, a simplification nobody anticipated, a market insight that emerged from implementation? Does what was built in this phase directly solve an operational problem in another area or business vertical that the team hasn't considered — not speculatively, but with concrete and relevant impact?\n\nBe specific — reference capability IDs, phase numbers, objective IDs. Share observations conversationally. If you genuinely see nothing noteworthy, just say so briefly. Under 400 words."

  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
