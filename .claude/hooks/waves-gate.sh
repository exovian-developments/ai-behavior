#!/bin/bash
# waves-gate.sh — PreToolUse hook for Waves 2.0
# Implements graduated enforcement before every Edit/Write/Bash action.
#
# Logic:
#   No blueprint → allow everything (project in shaping phase)
#   Blueprint exists → Waves enforcement activates:
#     No roadmap → BLOCK (except ai_files/ writes and read-only Bash)
#     No logbook → BLOCK (except ai_files/ writes and read-only Bash)
#     All artifacts present → ALLOW + inject decision classification reminder
#
# Whitelisted always:
#   - Edit/Write targeting ai_files/ (framework artifacts, not code)
#   - Read-only Bash commands (git status, ls, grep, etc.)
#
# Input: stdin JSON with {tool_name, tool_input} from PreToolUse event
# Output: JSON with {additionalContext} or exit 2 to block

set -euo pipefail

# Read stdin (PreToolUse event data)
INPUT=$(cat)

# Resolve project root
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"

# If no ai_files directory, allow everything
if [ ! -d "$AI_FILES" ]; then
  echo '{}'
  exit 0
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo '{}'
  exit 0
fi

# --- Extract tool info ---
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# --- Whitelist: writes to ai_files/ are always allowed ---
# Framework artifacts (blueprints, roadmaps, logbooks, schemas, manifests) are not code.
# The agent must be able to create logbooks, update roadmaps, etc. without a logbook existing.
if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ]; then
  if [[ "$FILE_PATH" == */ai_files/* ]] || [[ "$FILE_PATH" == ai_files/* ]]; then
    echo '{}'
    exit 0
  fi
fi

# --- Whitelist: read-only Bash commands are always allowed ---
if [ "$TOOL_NAME" = "Bash" ] && [ -n "$COMMAND" ]; then
  # Extract the first word/command from the Bash command
  FIRST_CMD=$(echo "$COMMAND" | sed 's/^[[:space:]]*//' | cut -d' ' -f1 | cut -d'/' -f1)

  # Read-only commands that never modify state
  case "$FIRST_CMD" in
    git)
      # Allow read-only git subcommands
      GIT_SUB=$(echo "$COMMAND" | sed 's/^[[:space:]]*git[[:space:]]*//' | cut -d' ' -f1)
      case "$GIT_SUB" in
        status|log|diff|show|branch|remote|tag|ls-files|blame|shortlog|describe|rev-parse|config)
          echo '{}'
          exit 0
          ;;
      esac
      ;;
    ls|tree|cat|head|tail|grep|rg|find|wc|file|which|echo|printf|type|pwd|date|whoami|env|printenv)
      echo '{}'
      exit 0
      ;;
    dart|flutter)
      # dart analyze, flutter analyze — read-only analysis
      if echo "$COMMAND" | grep -qE 'analyze|--version|pub\s+deps'; then
        echo '{}'
        exit 0
      fi
      ;;
    brew|node|python|python3|ruby|java|go|rustc|cargo)
      # Version checks and package info
      if echo "$COMMAND" | grep -qE '\-\-version|\-v$|--help|list|info|which'; then
        echo '{}'
        exit 0
      fi
      ;;
    curl)
      # curl for downloading (used by Homebrew SHA checks etc.)
      echo '{}'
      exit 0
      ;;
    shasum|md5|sha256sum)
      # Hash verification
      echo '{}'
      exit 0
      ;;
  esac
fi

# --- Check Blueprint (the inflection point) ---
BLUEPRINT_EXISTS=false

if [ -f "$AI_FILES/blueprint.json" ] || [ -f "$AI_FILES/product_blueprint.json" ]; then
  BLUEPRINT_EXISTS=true
fi

# No blueprint = project in shaping phase → allow everything silently
if [ "$BLUEPRINT_EXISTS" = false ]; then
  echo '{}'
  exit 0
fi

# --- Blueprint exists: Waves enforcement activates ---

# Check for at least one roadmap
ROADMAP_EXISTS=false
for roadmap in "$AI_FILES"/waves/*/roadmap.json; do
  if [ -f "$roadmap" ]; then
    ROADMAP_EXISTS=true
    break
  fi
done

if [ "$ROADMAP_EXISTS" = false ]; then
  echo "Waves: This project has a blueprint but no roadmap. Create one before implementing: /waves:roadmap-create" >&2
  exit 2
fi

# Check for at least one logbook
LOGBOOK_EXISTS=false
for logbook in "$AI_FILES"/waves/*/logbooks/*.json; do
  if [ -f "$logbook" ]; then
    LOGBOOK_EXISTS=true
    break
  fi
done

if [ "$LOGBOOK_EXISTS" = false ]; then
  echo "Waves: This project has a blueprint and roadmap but no logbook. Create one for your task: /waves:logbook-create" >&2
  exit 2
fi

# --- All artifacts present: allow + inject classification reminder ---
REMINDER="CLASSIFY your decision before acting:\n- Level 1-2 (technical implementation) → Proceed. Document in logbook.\n- Level 3 (outside objective scope) → STOP. Inform user.\n- Level 4 (affects blueprint capability) → STOP. Project scenarios.\n- Level 5 (discovery with independent value) → STOP. Document. Advise."

jq -n --arg ctx "$REMINDER" '{"additionalContext": $ctx}'
