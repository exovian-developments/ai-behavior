#!/bin/bash
# waves-blueprint-impact.sh — PostToolUse hook for Waves 2.0
# Triggers impact projection when the product blueprint is modified.
#
# This is the MOST IMPORTANT metacognition trigger.
# When the blueprint changes, everything downstream is potentially affected.
#
# Detects: edit to ai_files/blueprint.json or ai_files/product_blueprint.json
# Action: injects additionalContext prompting the agent to project cascading impacts
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for impact projection prompt

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a blueprint file
case "$FILE" in
  */blueprint.json|*/product_blueprint.json)
    # Proceed — this is a blueprint
    ;;
  *)
    echo '{}'
    exit 0
    ;;
esac

# Resolve project root
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"

# Build context about what roadmaps and logbooks exist
ROADMAP_LIST=""
LOGBOOK_LIST=""

for roadmap in "$AI_FILES"/waves/*/roadmap.json; do
  [ -f "$roadmap" ] || continue
  WAVE=$(echo "$roadmap" | sed 's|.*/waves/\([^/]*\)/roadmap.json|\1|')
  ROADMAP_LIST="$ROADMAP_LIST\n- $WAVE: $roadmap"
done

for logbook in "$AI_FILES"/waves/*/logbooks/*.json; do
  [ -f "$logbook" ] || continue
  LOGBOOK_LIST="$LOGBOOK_LIST\n- $logbook"
done

# Read metacognition model from user_pref.json (default: opus)
META_MODEL="opus"
for pref in "$AI_FILES/user_pref.json" "user_pref.json"; do
  if [ -f "$pref" ]; then
    CONFIGURED_MODEL=$(jq -r '.agent_config.metacognition_model // empty' "$pref" 2>/dev/null)
    [ -n "$CONFIGURED_MODEL" ] && META_MODEL="$CONFIGURED_MODEL"
    break
  fi
done

# Write pending marker — gate blocks until delegation
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "/tmp/waves-metacognition-pending"

# Build clean path lists for the subagent (one per line with - prefix)
ROADMAPS_PATHS=$(echo -e "$ROADMAP_LIST" | grep -v '^$')
LOGBOOKS_PATHS=$(echo -e "$LOGBOOK_LIST" | grep -v '^$')

MSG="METACOGNITION TRIGGERED — Blueprint changed.\n\nYou may still update Waves artifacts (roadmaps, logbooks) — those are not blocked. Finish any pending artifact updates FIRST (e.g., update roadmaps to reflect blueprint changes).\n\nOnce all artifact updates are done, you are BLOCKED from code changes until you:\n1. Spawn a background Agent (run_in_background=true, model=$META_MODEL) with the prompt below\n2. Write to any ai_files/ artifact (logbook, roadmap decision, or any artifact note) — this clears the gate\n\nThe gate unblocks on the first ai_files/ write after delegation. Continue working — the subagent analyzes in parallel.\n\nWhen the subagent returns:\n- If CRITICAL findings → classify as Level 4+, STOP, present to user immediately\n- If no critical findings → note in logbook and continue\n\n--- SUBAGENT PROMPT (use exactly as the prompt parameter) ---\nYou are a strategic advisor performing a cascading impact analysis for a product that uses the Waves framework.\n\nCONTEXT: The product BLUEPRINT was just modified. This is the most important artifact in the project — everything downstream (roadmaps, logbooks, implementation) derives from it. A change here can invalidate work already done or planned.\n\nREAD THESE FILES (all of them, completely):\n\nBlueprint (just modified):\n- $FILE\n\nRoadmaps (read each one):\n$ROADMAPS_PATHS\n\nLogbooks (read each one):\n$LOGBOOKS_PATHS\n\nAfter reading, perform a cascading impact analysis:\n\n1. INVALIDATED WORK — Compare the blueprint change with active roadmaps and logbooks:\n   - Are there roadmap phases planning work on capabilities that were REMOVED or CHANGED?\n   - Are there logbook objectives implementing something that no longer matches the blueprint?\n   - Are there decisions recorded in logbooks or roadmaps that are now CONTRADICTED by the blueprint change?\n   - Are there completed objectives whose output may need revision?\n\n2. COVERAGE GAPS — Check if the blueprint change creates new requirements:\n   - New capabilities that have NO roadmap phase covering them\n   - New flows or views that have NO logbook objectives planning their implementation\n   - New design principles that existing code may violate\n   - Dependencies between new and existing capabilities that aren't reflected in roadmap phase ordering\n\n3. OPPORTUNITIES — Does the blueprint change simplify anything?\n   - Can existing roadmap phases be consolidated or eliminated?\n   - Does the change make some planned work unnecessary?\n   - Does it open a faster path to the product hypothesis?\n\nRESPONSE FORMAT:\n- If you find ANY impact: start with CRITICAL: then list each finding with the specific capability ID, phase number, or objective ID it affects. State what was invalidated and what action is needed.\n- If no impact: respond with exactly 'No critical findings.' and nothing else.\n\nBe specific and actionable. Under 400 words.\n--- END SUBAGENT PROMPT ---"

jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
