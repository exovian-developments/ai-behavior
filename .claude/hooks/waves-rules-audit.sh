#!/bin/bash
# waves-rules-audit.sh — PostToolUse hook for Waves rules-vs-code audit (Layer C)
#
# Triggers when a primary objective transitions to completed/achieved.
# Instructs the main agent to spawn a background subagent that audits the diff
# against the rules in scope and writes findings to ai_files/waves/wN/audits/.
#
# NON-BLOCKING: emits additionalContext only. The gate exit code is always 0.
# Auto-edits are not interrupted. Findings are surfaced via the injector hook
# at the agent's next Edit/Write.
#
# Iteration cap: 3. After 3 failed audits on the same primary, escalates to user.
#
# Marker lifecycle:
#   /tmp/waves-rules-audit/<hash>            counter of completed primaries (per logbook path)
#   /tmp/waves-rules-audit-cooldown          60s post-clear cooldown to prevent re-trigger loops
#   ai_files/waves/wN/audits/primary-N.json  status file (source of truth, never deleted)
#
# Input: stdin JSON {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON {additionalContext} or {} when no action needed

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exits
[[ "$FILE" == *"/logbooks/"*.json ]] || { echo '{}'; exit 0; }
[ -f "$FILE" ] || { echo '{}'; exit 0; }
command -v jq &>/dev/null || { echo '{}'; exit 0; }

# Cooldown: prevents the loop where editing the audit file re-triggers a new audit
COOLDOWN_FILE="/tmp/waves-rules-audit-cooldown"
if [ -f "$COOLDOWN_FILE" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    AGE=$(( $(date +%s) - $(stat -f %m "$COOLDOWN_FILE") ))
  else
    AGE=$(( $(date +%s) - $(stat -c %Y "$COOLDOWN_FILE") ))
  fi
  if [ "$AGE" -lt 60 ]; then
    echo '{}'
    exit 0
  fi
  rm -f "$COOLDOWN_FILE"
fi

# Path normalization (avoids hash mismatch between absolute/relative paths)
NORM_FILE=$(cd "$(dirname "$FILE")" 2>/dev/null && echo "$(pwd)/$(basename "$FILE")" || echo "$FILE")

# Counter dir
MARKER_DIR="/tmp/waves-rules-audit"
mkdir -p "$MARKER_DIR" 2>/dev/null
HASH=$(echo "$NORM_FILE" | md5 2>/dev/null || echo "$NORM_FILE" | md5sum | cut -d' ' -f1)
COUNTER_FILE="$MARKER_DIR/$HASH"

# Count primaries currently completed
MAIN_COMPLETED=$(jq '[.objectives.main[] | select(.status == "achieved" or .status == "completed")] | length' "$FILE" 2>/dev/null || echo 0)
LAST_COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
echo "$MAIN_COMPLETED" > "$COUNTER_FILE"

# No new primary completion → nothing to do
[ "$MAIN_COMPLETED" -gt "$LAST_COUNT" ] || { echo '{}'; exit 0; }

# A primary just completed — set up the audit
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"
WAVE_DIR=$(echo "$FILE" | sed 's|/logbooks/.*||')
AUDITS_DIR="$WAVE_DIR/audits"
mkdir -p "$AUDITS_DIR" 2>/dev/null

# Identify the primary that just transitioned (the (LAST_COUNT)th in the completed list, 0-indexed)
PRIMARY_ID=$(jq -r --argjson idx "$LAST_COUNT" '[.objectives.main[] | select(.status == "achieved" or .status == "completed")][$idx].id // empty' "$FILE" 2>/dev/null)
[ -z "$PRIMARY_ID" ] && { echo '{}'; exit 0; }

PRIMARY_CONTENT=$(jq -r --argjson idx "$LAST_COUNT" '[.objectives.main[] | select(.status == "achieved" or .status == "completed")][$idx].content // ""' "$FILE" 2>/dev/null)
PRIMARY_FILES=$(jq --argjson idx "$LAST_COUNT" '[.objectives.main[] | select(.status == "achieved" or .status == "completed")][$idx].scope.files // []' "$FILE" 2>/dev/null)
PRIMARY_RULES=$(jq --argjson idx "$LAST_COUNT" '[.objectives.main[] | select(.status == "achieved" or .status == "completed")][$idx].scope.rules // []' "$FILE" 2>/dev/null)

AUDIT_FILE="$AUDITS_DIR/primary-${PRIMARY_ID}.json"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Determine iteration
if [ -f "$AUDIT_FILE" ]; then
  PREV_ITER=$(jq '.iterations // 0' "$AUDIT_FILE" 2>/dev/null || echo 0)
  ITERATION=$((PREV_ITER + 1))
else
  ITERATION=1
fi

# Cap: escalate after 3 iterations
if [ "$ITERATION" -gt 3 ]; then
  jq -n --arg ts "$TIMESTAMP" \
        --arg pcontent "$PRIMARY_CONTENT" \
        --argjson pid "$PRIMARY_ID" \
        --argjson rules "$PRIMARY_RULES" \
        --argjson files "$PRIMARY_FILES" \
        '{status: "escalated", primary_id: $pid, primary_content: $pcontent, scope_files: $files, scope_rules: $rules, iterations: 4, escalate_to_user: true, escalated_at: $ts, message: "Cap of 3 audit iterations reached. Violations persist after auto-correction attempts. Manual review required."}' \
        > "${AUDIT_FILE}.tmp" && mv "${AUDIT_FILE}.tmp" "$AUDIT_FILE"

  ESC_MSG="RULES AUDIT ESCALATED — Primary $PRIMARY_ID ($PRIMARY_CONTENT) has been audited 3 times and rule violations remain. Stop auto-correction. Read $AUDIT_FILE, summarize the persistent violations to the user, and ask for guidance before continuing."
  jq -n --arg ctx "$ESC_MSG" '{additionalContext: $ctx}'
  exit 0
fi

# Initialize / update audit file as 'running'
jq -n --arg ts "$TIMESTAMP" \
      --arg pcontent "$PRIMARY_CONTENT" \
      --argjson pid "$PRIMARY_ID" \
      --argjson rules "$PRIMARY_RULES" \
      --argjson files "$PRIMARY_FILES" \
      --argjson iter "$ITERATION" \
      '{status: "running", primary_id: $pid, primary_content: $pcontent, scope_files: $files, scope_rules: $rules, iterations: $iter, started_at: $ts}' \
      > "${AUDIT_FILE}.tmp" && mv "${AUDIT_FILE}.tmp" "$AUDIT_FILE"

# Locate rules file
RULES=""
for r in "$AI_FILES/project_rules.json" "$AI_FILES/project_standards.json" "project_rules.json" "project_standards.json"; do
  [ -f "$r" ] && RULES="$r" && break
done

# Read audit model from user_pref.json (reuses metacognition_model setting)
AUDIT_MODEL="opus"
for pref in "$AI_FILES/user_pref.json" "user_pref.json"; do
  if [ -f "$pref" ]; then
    CONFIGURED=$(jq -r '.agent_config.metacognition_model // empty' "$pref" 2>/dev/null)
    [ -n "$CONFIGURED" ] && AUDIT_MODEL="$CONFIGURED"
    break
  fi
done

# Build the subagent prompt
PROMPT=$(cat <<EOF
You are a code rules auditor. A primary objective just completed and you must verify the code complies with all applicable project rules.

Primary objective: "$PRIMARY_CONTENT" (id: $PRIMARY_ID)
Logbook: $NORM_FILE
Project rules: ${RULES:-(no rules file found)}
Audit output target: $AUDIT_FILE
Iteration: $ITERATION of 3

Your job:

1. Read the logbook to extract this primary's scope.files and scope.rules.
2. Read project_rules.json and load the FULL TEXT of every rule whose id is in scope.rules.
3. Use 'git diff HEAD~5' (or wider if recent commits are tiny) restricted to the scope.files to see what was just changed.
4. Read the current state of each scope.file in the working tree.
5. For each rule, evaluate whether the current code complies. Flag a violation only if you can cite (a) the exact rule text and (b) the exact file:line where it is broken. No speculation.
6. Classify each violation by impact level using the Waves trust contract:
   - Level 1 (mechanical): rename, format, swap a token, replace import. Agent can auto-fix silently.
   - Level 2 (technical): pattern change, small refactor with documented reason. Agent can auto-fix and document.
   - Level 3 (scope): goes outside the primary's intended boundary. Must surface to user.
   - Level 4 (business): affects a blueprint capability or product behavior. Must surface to user.
   - Level 5 (discovery): independent strategic value. Document and surface to user.
   When in doubt, classify UP (more conservative).

Write the result to $AUDIT_FILE as JSON of this exact shape (overwriting the current 'running' status):

{
  "status": "completed_pending_injection",
  "primary_id": $PRIMARY_ID,
  "primary_content": "$PRIMARY_CONTENT",
  "iterations": $ITERATION,
  "completed_at": "<UTC ISO 8601>",
  "scope_files": [...],
  "scope_rules": [...],
  "violations": [
    {
      "rule_id": <int>,
      "rule_text": "<full rule description from project_rules.json>",
      "file": "<relative path>",
      "line": <int or 0 if range>,
      "evidence": "<exact code excerpt, max 200 chars>",
      "level": <1 to 5>,
      "suggested_fix": "<concrete change to apply>",
      "reasoning": "<why this is a violation, citing the rule text>"
    }
  ]
}

If you find zero violations, set "status" to "closed_resolved" and "violations" to []. The injector will not surface anything to the agent in that case.

Constraints:
- Write ONLY the JSON file. No commentary. No code outside the JSON.
- Do not invent rules. Only check rules that exist in project_rules.json and are in scope.
- High confidence only. False positives erode trust in the audit.
- Use the Edit/Write tool to write to $AUDIT_FILE atomically (read first, then overwrite).
EOF
)

# Build the additionalContext message
MSG=$(cat <<EOF
RULES AUDIT — Primary objective $PRIMARY_ID just completed. Spawn a background subagent (model=$AUDIT_MODEL, run_in_background=true) to audit code against the rules in scope.

This does NOT block your work. Continue with the next objective if any. When the audit completes, the injector hook will surface violations at your next Edit/Write so you can correct them.

Spawn the subagent with this prompt EXACTLY (do not paraphrase):

---
$PROMPT
---

After spawning, continue normally.
EOF
)

jq -n --arg ctx "$MSG" '{additionalContext: $ctx}'
exit 0
