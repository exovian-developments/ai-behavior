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

MSG="METACOGNITION — Blueprint changed. BLOCKED until you delegate.\n\n1. Spawn background Agent (run_in_background=true, model=$META_MODEL) — COPY THE PROMPT BELOW EXACTLY.\n2. Write to any ai_files/ artifact — this clears the gate.\n\nWhen subagent returns with observations → share with the user. If nothing relevant → note and continue.\n\nPROMPT (copy as-is into the Agent prompt parameter):\nYou are an expert advisor. The product BLUEPRINT was just modified — this is the most important artifact in the project. Everything downstream derives from it.\n\nRead ALL these files:\n$FILE\n$ROADMAPS_PATHS\n$LOGBOOKS_PATHS\n\nNow step back and assess the cascading impact. Share your honest observations:\n\n- Has any work already done or planned become invalid because of this change? Roadmap phases targeting changed capabilities, logbook objectives that no longer match, decisions that are now contradicted?\n- Does this change create gaps? New capabilities without a plan to build them, new flows without logbook objectives, new dependencies that the phase ordering doesn't reflect?\n- Does this change open opportunities? Can phases be simplified or eliminated? Is planned work now unnecessary? Is there a faster path to what the product promises?\n- SERENDIPITY: does this change reveal something unexpected about the product direction? A pivot opportunity, a market insight, a simplification that nobody saw coming? Does this change make the product directly applicable to an operational problem in another area or business vertical — not speculatively, but with concrete and relevant impact?\n\nBe specific — reference capability IDs, phase numbers, objective IDs. Share observations conversationally. If you genuinely see no impact, just say so briefly. Under 400 words."

jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
