#!/bin/bash
# waves-metacognition.sh — PostToolUse hook for Waves 2.0
# Triggers metacognition checkpoint when a primary objective is completed.
#
# Detects: edit to */logbooks/*.json where a main objective status changed to "achieved"/"completed"
# Action: injects additionalContext forcing the agent to reflect holistically before continuing
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for metacognition prompt, empty otherwise

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a logbook file
if [[ "$FILE" != *"/logbooks/"*.json ]]; then
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

# Check if any main objective was JUST completed
# (has status achieved/completed but no completed_at timestamp older than 60 seconds)
# Simple heuristic: count main objectives with "achieved" status
MAIN_COMPLETED=$(jq '[.objectives.main[] | select(.status == "achieved" or .status == "completed")] | length' "$FILE" 2>/dev/null || echo 0)

# Read a marker file to track last known count
MARKER_DIR="/tmp/waves-metacognition"
mkdir -p "$MARKER_DIR" 2>/dev/null
MARKER_FILE="$MARKER_DIR/$(echo "$FILE" | md5 2>/dev/null || echo "$FILE" | md5sum 2>/dev/null | cut -d' ' -f1)"
LAST_COUNT=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)

# Update marker
echo "$MAIN_COMPLETED" > "$MARKER_FILE"

# If count increased, a main objective was just completed
if [ "$MAIN_COMPLETED" -gt "$LAST_COUNT" ]; then
  # --- MECHANICAL ROADMAP UPDATE (resilient to incomplete logbooks) ---
  # Write progress note directly to the roadmap so it always reflects reality,
  # even when logbooks are abandoned or sessions end abruptly.
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
  AI_FILES="$PROJECT_DIR/ai_files"

  # Find the roadmap for this logbook's wave
  WAVE_DIR=$(echo "$FILE" | sed 's|/logbooks/.*||')
  ROADMAP="$WAVE_DIR/roadmap.json"
  LOGBOOK_NAME=$(basename "$FILE")
  TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

  # Get the completed objective's content
  OBJ_CONTENT=$(jq -r --argjson last "$LAST_COUNT" '[.objectives.main[] | select(.status == "achieved" or .status == "completed")][$last].content // "objective completed"' "$FILE" 2>/dev/null)

  if [ -f "$ROADMAP" ]; then
    # Build objective status snapshot from the logbook
    MAIN_TOTAL=$(jq '[.objectives.main[]] | length' "$FILE" 2>/dev/null || echo 0)
    MAIN_ACHIEVED=$(jq '[.objectives.main[] | select(.status == "achieved" or .status == "completed")] | length' "$FILE" 2>/dev/null || echo 0)
    SEC_TOTAL=$(jq '[.objectives.secondary[]] | length' "$FILE" 2>/dev/null || echo 0)
    SEC_ACHIEVED=$(jq '[.objectives.secondary[] | select(.status == "achieved" or .status == "completed")] | length' "$FILE" 2>/dev/null || echo 0)

    PROGRESS_NOTE="[AUTO] Logbook $LOGBOOK_NAME: primary objective completed — $OBJ_CONTENT. State: main $MAIN_ACHIEVED/$MAIN_TOTAL, secondary $SEC_ACHIEVED/$SEC_TOTAL"
    jq --arg note "$PROGRESS_NOTE" --arg ts "$TIMESTAMP" \
      '.decisions += [{"id": (.decisions | length + 1), "created_at": $ts, "decision": $note}]' \
      "$ROADMAP" > "${ROADMAP}.tmp" 2>/dev/null && mv "${ROADMAP}.tmp" "$ROADMAP"
  fi

  # --- Write pending marker for gate blocking ---
  PENDING_FILE="/tmp/waves-metacognition-pending"
  echo "$TIMESTAMP" > "$PENDING_FILE"

  # Find blueprint
  BP=""
  for bp in "$AI_FILES/blueprint.json" "$AI_FILES/product_blueprint.json" "blueprint.json" "product_blueprint.json"; do
    [ -f "$bp" ] && BP="$bp" && break
  done

  # Find active roadmaps
  ROADMAPS=""
  for rm in "$AI_FILES"/waves/*/roadmap.json; do
    [ -f "$rm" ] || continue
    STATUS=$(jq -r '.product.status // "unknown"' "$rm" 2>/dev/null)
    if [ "$STATUS" = "active" ] || [ "$STATUS" = "in_progress" ]; then
      ROADMAPS="${ROADMAPS}${ROADMAPS:+, }$rm"
    fi
  done

  # Find active logbooks (all with pending objectives)
  LOGBOOKS=""
  for lb in "$AI_FILES"/waves/*/logbooks/*.json; do
    [ -f "$lb" ] || continue
    LOGBOOKS="${LOGBOOKS}${LOGBOOKS:+, }$lb"
  done

  MSG="METACOGNITION TRIGGERED — Primary objective completed in $LOGBOOK_NAME.\n\nA mechanical progress note was written to the roadmap. Before continuing:\n\n1. Read this logbook's objectives (main + secondary) and their current statuses\n2. Update the roadmap decisions with a progress entry based on OBJECTIVE COMPLETION STATE: which objectives are achieved, in-progress, not started, blocked. This is the real state of the logbook projected to the roadmap.\n3. Update the logbook recent_context documenting what was done\n\nYou may still update Waves artifacts (roadmaps, logbooks, resolutions) — those are not blocked.\n\nOnce artifact updates are done, you are BLOCKED from code changes until you:\n4. Spawn a background Agent (run_in_background=true, model=opus) with the prompt below\n5. Update the logbook recent_context with 'metacognition: delegated to background analysis'\n\nThe gate will unblock after step 5. Continue with your next objective — the subagent analyzes in parallel.\n\nWhen the subagent returns:\n- If it reports CRITICAL findings → classify as Level 4+, STOP, and present to the user immediately\n- If it reports no critical findings → note in logbook and continue\n\n--- SUBAGENT PROMPT (use exactly as the prompt parameter) ---\nYou are a strategic advisor performing a metacognition analysis for a product development project that uses the Waves framework.\n\nCONTEXT: A primary objective was just completed in logbook '$LOGBOOK_NAME'. The objective was: '$OBJ_CONTENT'. The logbook state is: $MAIN_COMPLETED/$MAIN_TOTAL main objectives achieved.\n\nYour job is NOT to review code. Your job is to think like a business advisor who just received a snapshot of the project and must identify things the development team cannot see because they are focused on the immediate task.\n\nREAD THESE FILES (all of them, completely):\n- Blueprint: ${BP:-not found}\n- Roadmaps: ${ROADMAPS:-none found}\n- Logbooks: ${LOGBOOKS:-none found}\n\nAfter reading, analyze for THREE things:\n\n1. BLOCKERS — Look at the upcoming objectives, phases, and capabilities that are NOT yet implemented. For each, ask: does the project have everything it needs to achieve this? Look for:\n   - Missing prerequisites (e.g., blueprint promises AppStore deployment but no Apple Developer account is planned anywhere)\n   - Information gaps (e.g., a capability requires an API integration but no API credentials or documentation is referenced)\n   - Ambiguities that will cause rework (e.g., a flow references a 'user dashboard' but no view or design for it exists in the blueprint)\n   - Infrastructure assumptions (e.g., blueprint wants real-time features but no WebSocket or push notification infrastructure is planned)\n\n2. DESIGN IMPROVEMENTS — Compare what the blueprint PROMISES with what the implementation REVEALS. Look for:\n   - Flows that are missing steps (the implementation shows a step is needed that the blueprint doesn't have)\n   - Capabilities that should be split (too much scope in one capability based on what implementation revealed)\n   - Dependencies that weren't visible during planning but are now obvious\n   - Design principles that are being violated by the current implementation approach\n\n3. EFFORT SAVINGS — Think about the blueprint's mission, vision, and hypothesis. Is there:\n   - An external service, API, or library that would eliminate planned work?\n   - An architectural change that would make multiple upcoming phases simpler?\n   - A reordering of phases that would reduce dependencies and unblock parallel work?\n   - A capability that could be descoped without affecting the hypothesis?\n\nRESPONSE FORMAT:\n- If you find ANY of the three: start with CRITICAL: then list each finding with the specific capability ID, phase number, or objective ID it affects. Explain WHY it matters and WHAT the team should do about it.\n- If you find NOTHING critical: respond with exactly 'No critical findings.' and nothing else.\n\nBe specific and actionable. Under 400 words.\n--- END SUBAGENT PROMPT ---"

  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

# If no new trigger and pending marker exists, clear it (delegation completed)
PENDING_FILE="/tmp/waves-metacognition-pending"
if [ -f "$PENDING_FILE" ]; then
  rm -f "$PENDING_FILE" 2>/dev/null
fi

echo '{}'
exit 0
