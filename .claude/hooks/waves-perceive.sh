#!/bin/bash
# waves-perceive.sh — SessionStart hook for Waves 2.0
# Reads the Waves artifact graph and injects product state as additionalContext
# so the agent starts every session informed.
#
# Input: stdin JSON with {source, model} from SessionStart event
# Output: Plain text to stdout (Claude Code injects non-JSON stdout as context on exit 0)

set -euo pipefail

# Diagnostic breadcrumb — verify hook execution
touch /tmp/waves-perceive-ran 2>/dev/null || true

# Resolve project root (where ai_files/ lives)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"

# If no ai_files directory, nothing to perceive — silent exit
if [ ! -d "$AI_FILES" ]; then
  exit 0
fi

# Check for jq — silent exit without it
if ! command -v jq &> /dev/null; then
  exit 0
fi

# --- Read Blueprint ---
PRODUCT_NAME=""
PRODUCT_CODENAME=""
BLUEPRINT_EXISTS=false
BLUEPRINT_PATH=""

# Check both naming conventions
if [ -f "$AI_FILES/blueprint.json" ]; then
  BLUEPRINT_EXISTS=true
  BLUEPRINT_PATH="$AI_FILES/blueprint.json"
elif [ -f "$AI_FILES/product_blueprint.json" ]; then
  BLUEPRINT_EXISTS=true
  BLUEPRINT_PATH="$AI_FILES/product_blueprint.json"
fi

if [ "$BLUEPRINT_EXISTS" = true ]; then
  PRODUCT_NAME=$(jq -r '.meta.product_name // empty' "$BLUEPRINT_PATH" 2>/dev/null)
  PRODUCT_CODENAME=$(jq -r '.meta.product_codename // empty' "$BLUEPRINT_PATH" 2>/dev/null)
fi

# If no blueprint, return minimal context or nothing
if [ "$BLUEPRINT_EXISTS" = false ]; then
  if [ -f "$AI_FILES/feasibility.json" ] || [ -f "$AI_FILES/foundation.json" ]; then
    printf "ESTADO WAVES:\n- Proyecto en fase de validación (sin blueprint aún)\n- Artefactos detectados: feasibility/foundation\n- El framework permite libertad total en esta fase\n"
  fi
  exit 0
fi

# --- Find ALL Active Roadmaps ---
ACTIVE_ROADMAPS=""
ACTIVE_WAVE=""
ACTIVE_PHASE_NAME=""
ACTIVE_PHASE_STATUS=""
ACTIVE_PHASE_ID=""
TOTAL_MILESTONES=0
ACHIEVED_MILESTONES=0
OPEN_QUESTIONS=0
RECENT_DECISIONS=""
PRIMARY_ROADMAP_PATH=""

for roadmap in "$AI_FILES"/waves/*/roadmap.json; do
  [ -f "$roadmap" ] || continue

  STATUS=$(jq -r '.product.status // "unknown"' "$roadmap" 2>/dev/null)

  if [ "$STATUS" = "active" ] || [ "$STATUS" = "in_progress" ] || [ "$STATUS" = "planning" ]; then
    WAVE_NAME=$(echo "$roadmap" | sed 's|.*/waves/\([^/]*\)/roadmap.json|\1|')

    # Collect all active roadmap paths
    if [ -n "$ACTIVE_ROADMAPS" ]; then
      ACTIVE_ROADMAPS="$ACTIVE_ROADMAPS|$roadmap"
    else
      ACTIVE_ROADMAPS="$roadmap"
    fi

    # Use the highest wave number as primary (w2 > w1 > w0)
    if [ -z "$ACTIVE_WAVE" ] || [[ "$WAVE_NAME" > "$ACTIVE_WAVE" ]]; then
      ACTIVE_WAVE="$WAVE_NAME"
      PRIMARY_ROADMAP_PATH="$roadmap"

      ACTIVE_PHASE_ID=$(jq -r '[.phases[] | select(.status != "completed" and .status != "achieved")] | .[0].id // empty' "$roadmap" 2>/dev/null)
      ACTIVE_PHASE_NAME=$(jq -r --argjson id "${ACTIVE_PHASE_ID:-0}" '[.phases[] | select(.id == $id)] | .[0].name // empty' "$roadmap" 2>/dev/null)
      ACTIVE_PHASE_STATUS=$(jq -r --argjson id "${ACTIVE_PHASE_ID:-0}" '[.phases[] | select(.id == $id)] | .[0].status // empty' "$roadmap" 2>/dev/null)

      TOTAL_MILESTONES=$(jq '[.phases[].milestones[]] | length' "$roadmap" 2>/dev/null || echo 0)
      ACHIEVED_MILESTONES=$(jq '[.phases[].milestones[] | select(.status == "achieved" or .status == "completed")] | length' "$roadmap" 2>/dev/null || echo 0)

      OPEN_QUESTIONS=$(jq '[.open_questions[] | select(.status == "open")] | length' "$roadmap" 2>/dev/null || echo 0)
      RECENT_DECISIONS=$(jq -r '[.decisions[-3:][].decision] | join("; ")' "$roadmap" 2>/dev/null || echo "")
    fi
  fi
done

# --- Find Active Logbook (highest wave first, most recent activity) ---
ACTIVE_LOGBOOK=""
ACTIVE_LOGBOOK_PATH=""
LOGBOOK_OBJECTIVES_TOTAL=0
LOGBOOK_OBJECTIVES_DONE=0
NEXT_OBJECTIVE=""

# Search from highest wave downward
for wave_dir in $(ls -rd "$AI_FILES"/waves/*/  2>/dev/null); do
  [ -d "${wave_dir}logbooks" ] || continue

  for logbook in "${wave_dir}logbooks/"*.json; do
    [ -f "$logbook" ] || continue

    PENDING=$(jq '[.objectives.secondary[] | select(.status == "not_started" or .status == "active")] | length' "$logbook" 2>/dev/null || echo 0)

    if [ "$PENDING" -gt 0 ]; then
      ACTIVE_LOGBOOK=$(basename "$logbook")
      ACTIVE_LOGBOOK_PATH="$logbook"
      WAVE_OF_LOGBOOK=$(echo "$logbook" | sed 's|.*/waves/\([^/]*\)/logbooks/.*|\1|')
      LOGBOOK_OBJECTIVES_TOTAL=$(jq '[.objectives.secondary[]] | length' "$logbook" 2>/dev/null || echo 0)
      LOGBOOK_OBJECTIVES_DONE=$(jq '[.objectives.secondary[] | select(.status == "achieved")] | length' "$logbook" 2>/dev/null || echo 0)
      NEXT_OBJECTIVE=$(jq -r '[.objectives.secondary[] | select(.status == "not_started" or .status == "active")] | .[0].content // "N/A"' "$logbook" 2>/dev/null)
      break 2
    fi
  done
done

# --- Build & Output Plain Text ---
# Claude Code injects non-JSON stdout as context when hook exits 0
printf "ESTADO WAVES:\n"
printf -- "- Producto: %s (%s)\n" "${PRODUCT_NAME:-desconocido}" "${PRODUCT_CODENAME:-sin codename}"

if [ -n "$ACTIVE_WAVE" ]; then
  printf -- "- Wave activa: %s\n" "$ACTIVE_WAVE"
  printf -- "- Fase actual: %s — %s (%s)\n" "${ACTIVE_PHASE_ID:-?}" "${ACTIVE_PHASE_NAME:-sin nombre}" "${ACTIVE_PHASE_STATUS:-?}"
  printf -- "- Progreso: %s/%s milestones\n" "$ACHIEVED_MILESTONES" "$TOTAL_MILESTONES"

  if [ -n "$ACTIVE_LOGBOOK" ]; then
    printf -- "- Bitácora activa: %s (%s/%s objetivos)\n" "$ACTIVE_LOGBOOK" "$LOGBOOK_OBJECTIVES_DONE" "$LOGBOOK_OBJECTIVES_TOTAL"
    printf -- "- Siguiente objetivo: %s\n" "$NEXT_OBJECTIVE"
  else
    printf -- "- Sin bitácora activa en %s\n" "$ACTIVE_WAVE"
  fi

  if [ "$OPEN_QUESTIONS" -gt 0 ]; then
    printf -- "- Preguntas abiertas: %s\n" "$OPEN_QUESTIONS"
  fi

  if [ -n "$RECENT_DECISIONS" ]; then
    printf -- "- Decisiones recientes: %s\n" "$RECENT_DECISIONS"
  fi
else
  printf -- "- Sin wave activa detectada\n"
fi

# --- CARGAR: paths for the prompt hook to read ---
LOAD_FILES=""

# All active roadmaps
if [ -n "$ACTIVE_ROADMAPS" ]; then
  IFS='|' read -ra ROADMAP_PATHS <<< "$ACTIVE_ROADMAPS"
  for rpath in "${ROADMAP_PATHS[@]}"; do
    LOAD_FILES="${LOAD_FILES}\n- ${rpath}"
  done
fi

# Active logbook
if [ -n "$ACTIVE_LOGBOOK_PATH" ]; then
  LOAD_FILES="${LOAD_FILES}\n- ${ACTIVE_LOGBOOK_PATH}"
fi

if [ -n "$LOAD_FILES" ]; then
  printf "\nCARGAR:%b\n" "$LOAD_FILES"
fi
