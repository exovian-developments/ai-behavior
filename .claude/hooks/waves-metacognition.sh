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

# Normalize file path to prevent hash mismatches (absolute vs relative)
NORM_FILE=$(cd "$(dirname "$FILE")" 2>/dev/null && echo "$(pwd)/$(basename "$FILE")" || echo "$FILE")

# Read a marker file to track last known count
MARKER_DIR="/tmp/waves-metacognition"
mkdir -p "$MARKER_DIR" 2>/dev/null
MARKER_FILE="$MARKER_DIR/$(echo "$NORM_FILE" | md5 2>/dev/null || echo "$NORM_FILE" | md5sum 2>/dev/null | cut -d' ' -f1)"
LAST_COUNT=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)

# Update marker
echo "$MAIN_COMPLETED" > "$MARKER_FILE"

# Cooldown: skip if metacognition was recently delegated (prevents circular re-trigger)
COOLDOWN_FILE="/tmp/waves-metacognition-cooldown"
if [ -f "$COOLDOWN_FILE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    COOLDOWN_AGE=$(( $(date +%s) - $(stat -f %m "$COOLDOWN_FILE") ))
  else
    COOLDOWN_AGE=$(( $(date +%s) - $(stat -c %Y "$COOLDOWN_FILE") ))
  fi
  if [ "$COOLDOWN_AGE" -lt 60 ]; then
    echo '{}'
    exit 0
  fi
  rm -f "$COOLDOWN_FILE"
fi

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

  MSG="METACOGNITION — Objective completed in $LOGBOOK_NAME. BLOCKED until you delegate.\n\nFirst: update roadmap decisions with OBJECTIVE COMPLETION STATE from this logbook (achieved/in-progress/not-started/blocked counts).\n\nThen:\n1. Spawn background Agent (run_in_background=true, model=$META_MODEL) — COPY THE PROMPT BELOW EXACTLY. Do NOT rewrite, shorten, or paraphrase it.\n2. Write to any ai_files/ artifact — this clears the gate.\n\nWhen subagent returns: CRITICAL → stop and present. No findings → note and continue.\n\nPROMPT (copy as-is into the Agent prompt parameter):\nObjective completed: '$OBJ_CONTENT' in $LOGBOOK_NAME ($MAIN_COMPLETED/$MAIN_TOTAL main done). Read ALL these files completely:\n${BP:-blueprint not found}\n${ROADMAPS:-no roadmaps}\n${LOGBOOKS:-no logbooks}\n\nThink like a business advisor seeing a project snapshot. The team is focused on the immediate task — your job is to see what they cannot.\n1. BLOCKERS: upcoming objectives/capabilities that lack prerequisites. Missing accounts, APIs, infrastructure, legal, design assets? Information gaps that will cause rework? Ambiguities in flows/views?\n2. DESIGN IMPROVEMENTS: does the blueprint promise things the implementation reveals are incomplete? Missing flow steps? Capabilities that need splitting? Dependencies not visible during planning?\n3. EFFORT SAVINGS: external services that eliminate planned work? Architectural changes that simplify multiple phases? Phase reordering that unblocks parallel work? Capabilities to descope without affecting the hypothesis?\n\nReference capability IDs, phase numbers, objective IDs. Start with CRITICAL: if findings, or 'No critical findings.' if none. Under 400 words."

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
