# Command: `/ai-behavior:logbook-update [filename]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Update an existing logbook with progress, findings, objective status changes, and context entries.

**Schema:** `ai_files/schemas/logbook_schema.json`

**Input/Output:** `ai_files/logbooks/[filename].json`

**Parameters:** `[filename]` (optional) - Name of the logbook to update

**Key Features:**
- Progress tracking with context entries
- Objective status management (not_started → active → achieved/blocked/abandoned)
- Automatic history compaction when recent_context exceeds 20 items
- Support for adding new objectives discovered during work
- Reminder management

---

## Operations Supported

| Operation | Description |
|-----------|-------------|
| **Add progress** | New entry in recent_context documenting work done |
| **Update objective status** | Change status of main/secondary objectives |
| **Add new objective** | Discovered during work, add to main or secondary |
| **Add reminder** | Schedule future reminder |
| **Compact history** | Automatic when recent_context > 20 |

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO PRINCIPAL - ENTRY POINT**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

1. MAIN AGENT: Check if `ai_files/user_pref.json` exists

2. IF NOT EXISTS → MAIN AGENT (in English as fallback):
   ```
   ⚠️ Missing configuration!

   Please run first:
   /ai-behavior:project-init
   ```
   → **EXIT COMMAND**

3. IF EXISTS → Read `preferred_language`

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Parameter Check and Logbook Selection**
**═══════════════════════════════════════════════════════════════════**

4. MAIN AGENT: Check if filename parameter provided

5. IF parameter provided:
   - Validate file exists: `ai_files/logbooks/[filename].json`
   - IF NOT EXISTS → Error: "Bitácora no encontrada: [filename]"
   - IF EXISTS → Load logbook, continue

6. IF NO parameter:
   - Show tip:
     ```
     💡 TIP: Puedes ejecutar más rápido con:
        /ai-behavior:logbook-update MT-572.json
     ```
   - List available logbooks:
     ```
     📚 Bitácoras disponibles:

     1. MT-572.json (actualizado hace 2 horas)
     2. feature-auth.json (actualizado hace 1 día)
     3. bug-fix-login.json (actualizado hace 3 días)

     Elige 1-3 o escribe el nombre:
     ```
   - USER selects → Load logbook

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Check Due Reminders**
**═══════════════════════════════════════════════════════════════════**

7. MAIN AGENT: Check `future_reminders` array

8. FOR EACH reminder WHERE `when <= now`:
   ```
   ⏰ Recordatorio pendiente:
   "[reminder.content]"
   (Creado: [reminder.created_at])

   ¿Marcar como visto? (Si/No)
   ```
   - IF "Si" → Remove from array

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Show Current Status**
**═══════════════════════════════════════════════════════════════════**

9. MAIN AGENT: Display logbook summary
   ```
   📋 Bitácora: [ticket.title]

   🎯 Objetivos Principales:
   ┌────┬─────────────────────────────────────────────┬─────────────┐
   │ ID │ Contenido                                   │ Estado      │
   ├────┼─────────────────────────────────────────────┼─────────────┤
   │ 1  │ Endpoint GET /products/:id retorna...      │ 🟡 active   │
   │ 2  │ AddPieceService contiene lógica...         │ ⚪ not_started│
   └────┴─────────────────────────────────────────────┴─────────────┘

   📝 Objetivos Secundarios (activos/pendientes):
   ┌────┬─────────────────────────────────────────────┬─────────────┐
   │ 1  │ ApiRequestType enum contiene piecePicture  │ 🟢 achieved │
   │ 2  │ PiecePictureRequest model existe...        │ 🟡 active   │
   │ 3  │ CommodityOption UI model existe...         │ ⚪ not_started│
   └────┴─────────────────────────────────────────────┴─────────────┘

   📊 Contexto reciente: [count]/20 entradas
   📜 Historial compactado: [count]/10 entradas
   ```

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Select Operation**
**═══════════════════════════════════════════════════════════════════**

10. MAIN AGENT:
    ```
    ¿Qué deseas hacer?

    1. 📝 Agregar progreso (nueva entrada de contexto)
    2. ✅ Actualizar estado de objetivo
    3. ➕ Agregar nuevo objetivo
    4. ⏰ Agregar recordatorio
    5. 💾 Guardar y salir

    Elige 1-5:
    ```

11. USER selects → Go to corresponding STEP

---

**═══════════════════════════════════════════════════════════════════**
**OPERATION 1: Add Progress Entry**
**═══════════════════════════════════════════════════════════════════**

12. MAIN AGENT:
    ```
    📝 Describe el progreso, hallazgo o decisión:

    (Ejemplos: "Completado endpoint con validación",
     "Descubierto bug en middleware",
     "Decisión: usar patrón X por razón Y")
    ```

13. USER: Provides progress description

14. MAIN AGENT: Optionally detect mood
    ```
    ¿Cómo describes tu estado actual? (opcional, Enter para omitir)
    (focused, frustrated, excited, uncertain, blocked)
    ```

15. USER: Provides mood or skips

16. MAIN AGENT: Create new context entry
    ```json
    {
      "id": [next_id],
      "created_at": "[now_utc]",
      "content": "[user_input]",
      "mood": "[mood_if_provided]"
    }
    ```

17. MAIN AGENT: Prepend to `recent_context` array (index 0)

18. **CHECK: History Compaction Needed?**
    - IF `recent_context.length > 20`:
      - Go to **STEP COMPACT**
    - ELSE:
      - Continue

19. MAIN AGENT:
    ```
    ✅ Progreso agregado!

    ¿Deseas hacer otra operación? (Si/No)
    ```
    - IF "Si" → Go to STEP 3
    - IF "No" → Go to STEP SAVE

---

**═══════════════════════════════════════════════════════════════════**
**OPERATION 2: Update Objective Status**
**═══════════════════════════════════════════════════════════════════**

20. MAIN AGENT:
    ```
    ¿Qué tipo de objetivo deseas actualizar?

    1. Objetivo principal (main)
    2. Objetivo secundario (secondary)

    Elige 1 o 2:
    ```

21. USER selects type

22. MAIN AGENT: Show objectives of selected type with current status
    ```
    Objetivos [principales/secundarios]:

    1. [ID: 1] ⚪ not_started - ApiRequestType enum contiene...
    2. [ID: 2] 🟡 active - PiecePictureRequest model existe...
    3. [ID: 3] 🟢 achieved - CommodityOption UI model...

    ¿Cuál deseas actualizar? (número o ID):
    ```

23. USER selects objective

24. MAIN AGENT:
    ```
    Estado actual: [current_status]

    Nuevo estado:
    1. ⚪ not_started (pendiente)
    2. 🟡 active (en progreso)
    3. 🔴 blocked (bloqueado)
    4. 🟢 achieved (completado)
    5. ⚫ abandoned (abandonado)

    Elige 1-5:
    ```

25. USER selects new status

26. MAIN AGENT: Update objective status

27. MAIN AGENT: Auto-create context entry documenting the change
    ```json
    {
      "id": [next_id],
      "created_at": "[now_utc]",
      "content": "Objective [ID] status changed: [old] → [new]. [objective.content]"
    }
    ```

28. **IF status changed to "achieved" on secondary:**
    - Check if ALL secondary objectives for related main are achieved
    - IF yes:
      ```
      🎉 Todos los objetivos secundarios completados!

      ¿Marcar objetivo principal #[id] como achieved?
      "[main_objective.content]"

      (Si/No)
      ```
      - IF "Si" → Update main objective status

29. MAIN AGENT:
    ```
    ✅ Estado actualizado!

    ¿Deseas hacer otra operación? (Si/No)
    ```
    - IF "Si" → Go to STEP 3
    - IF "No" → Go to STEP SAVE

---

**═══════════════════════════════════════════════════════════════════**
**OPERATION 3: Add New Objective**
**═══════════════════════════════════════════════════════════════════**

30. MAIN AGENT:
    ```
    ¿Qué tipo de objetivo deseas agregar?

    1. Objetivo principal (main) - Alto nivel, requiere scope
    2. Objetivo secundario (secondary) - Granular, requiere completion_guide

    Elige 1 o 2:
    ```

31. USER selects type

**═══════════════════════════════════════════════════════════════════**
**OPERATION 3A: Add Main Objective**
**═══════════════════════════════════════════════════════════════════**

32. MAIN AGENT:
    ```
    📌 Nuevo objetivo principal

    ¿Cuál es el resultado verificable? (max 180 chars)
    (Ejemplo: "Endpoint POST /products crea producto con validación")
    ```

33. USER: Provides content

34. MAIN AGENT:
    ```
    ¿Cuál es el contexto de negocio/técnico? (max 300 chars)
    (¿Por qué se necesita? ¿Quién lo requiere?)
    ```

35. USER: Provides context

36. MAIN AGENT:
    ```
    ¿Cuáles son los archivos de referencia? (uno por línea, Enter vacío para terminar)
    (Ejemplo: src/controllers/ProductController.ts)
    ```

37. USER: Provides files

38. MAIN AGENT:
    ```
    ¿Qué reglas del proyecto aplican? (IDs separados por coma, o Enter para ninguna)
    (Ejemplo: 3, 7, 12)
    ```

39. USER: Provides rule IDs or skips

40. MAIN AGENT: Create main objective
    ```json
    {
      "id": [next_main_id],
      "created_at": "[now_utc]",
      "content": "[user_content]",
      "context": "[user_context]",
      "scope": {
        "files": ["[files_array]"],
        "rules": [[rules_array]]
      },
      "status": "not_started"
    }
    ```

41. Go to step 45

**═══════════════════════════════════════════════════════════════════**
**OPERATION 3B: Add Secondary Objective**
**═══════════════════════════════════════════════════════════════════**

42. MAIN AGENT:
    ```
    📝 Nuevo objetivo secundario

    ¿Cuál es el resultado específico? (max 180 chars)
    (Debe ser completable en una sesión de trabajo)
    ```

43. USER: Provides content

44. MAIN AGENT:
    ```
    Proporciona la guía de completación (uno por línea, Enter vacío para terminar):
    (Referencia archivos específicos, patrones, reglas)
    ```

45. USER: Provides completion_guide items

46. MAIN AGENT: Create secondary objective
    ```json
    {
      "id": [next_secondary_id],
      "created_at": "[now_utc]",
      "content": "[user_content]",
      "completion_guide": ["[guide_array]"],
      "status": "not_started"
    }
    ```

47. MAIN AGENT: Add to respective array, create context entry

48. MAIN AGENT:
    ```
    ✅ Objetivo agregado!

    ¿Deseas hacer otra operación? (Si/No)
    ```
    - IF "Si" → Go to STEP 3
    - IF "No" → Go to STEP SAVE

---

**═══════════════════════════════════════════════════════════════════**
**OPERATION 4: Add Reminder**
**═══════════════════════════════════════════════════════════════════**

49. MAIN AGENT:
    ```
    ⏰ Nuevo recordatorio

    ¿Qué deseas recordar?
    ```

50. USER: Provides reminder content

51. MAIN AGENT:
    ```
    ¿Cuándo debe aparecer el recordatorio?

    1. Próxima sesión
    2. En X horas (especificar)
    3. Fecha específica (YYYY-MM-DD HH:MM)

    Elige 1-3:
    ```

52. USER selects and provides timing

53. MAIN AGENT: Create reminder
    ```json
    {
      "id": [next_reminder_id],
      "created_at": "[now_utc]",
      "content": "[user_content]",
      "when": "[calculated_datetime]"
    }
    ```

54. MAIN AGENT:
    ```
    ✅ Recordatorio creado!

    ¿Deseas hacer otra operación? (Si/No)
    ```
    - IF "Si" → Go to STEP 3
    - IF "No" → Go to STEP SAVE

---

**═══════════════════════════════════════════════════════════════════**
**STEP COMPACT: History Compaction**
**═══════════════════════════════════════════════════════════════════**

55. MAIN AGENT: When `recent_context.length > 20`:
    ```
    📦 Compactando historial...

    El contexto reciente excede 20 entradas.
    Compactando las entradas más antiguas.
    ```

56. MAIN AGENT: Take oldest entry (last in array)

57. MAIN AGENT: Summarize to max 140 chars
    - Original: "Completed endpoint implementation with full validation including email format, password strength, and duplicate user checks. Also added rate limiting middleware."
    - Summary: "Endpoint done: validation (email, password, duplicates) + rate limiting middleware added"

58. MAIN AGENT: Create history_summary entry
    ```json
    {
      "id": [next_summary_id],
      "created_at": "[now_utc]",
      "content": "[summary]",
      "mood": "[preserved_if_exists]"
    }
    ```

59. MAIN AGENT: Prepend to `history_summary` array

60. MAIN AGENT: Remove oldest from `recent_context`

61. **CHECK: history_summary > 10?**
    - IF yes: Remove oldest (last) from history_summary

62. MAIN AGENT:
    ```
    ✅ Historial compactado:
    • Entrada movida: "[original_content_truncated]..."
    • Resumen: "[summary]"
    ```

63. Return to calling step

---

**═══════════════════════════════════════════════════════════════════**
**STEP SAVE: Save and Exit**
**═══════════════════════════════════════════════════════════════════**

64. MAIN AGENT: Validate JSON against schema

65. MAIN AGENT: Save to `ai_files/logbooks/[filename].json`

66. MAIN AGENT: Show summary
    ```
    ✅ Bitácora actualizada!

    📁 Archivo: ai_files/logbooks/[filename].json

    📊 Cambios realizados:
    • Entradas de contexto agregadas: [count]
    • Objetivos actualizados: [count]
    • Objetivos nuevos: [count]
    • Recordatorios: [count]

    🎯 Próximo objetivo a trabajar:
    [First not_started or active secondary objective]

    Guía:
    [completion_guide items]
    ```

---

## Quick Update Mode

When the agent has been working with the user and has context from the session, it can offer a quick update:

```
💡 He detectado que hemos estado trabajando en:
• Completado: [detected achievements]
• Hallazgos: [detected findings]

¿Deseas agregar esto a la bitácora automáticamente? (Si/No/Ajustar)
```

This allows the agent to:
1. Detect completed objectives from conversation
2. Extract findings and decisions
3. Propose context entries
4. User confirms or adjusts

---

## Automatic Context Entry Triggers

The agent should automatically offer to add context entries when:

| Trigger | Suggested Entry |
|---------|-----------------|
| Error resolved | "Resolved [error]: [solution]" |
| Decision made | "Decision: [choice] because [reason]" |
| Blocker encountered | "Blocked: [issue]. Waiting for [dependency]" |
| Objective completed | "Completed: [objective.content]" |
| New discovery | "Found: [discovery] in [location]" |

---

## Subagents

| Subagent | Purpose | Tools |
|----------|---------|-------|
| **context-summarizer** | Compress context entries for history_summary | None (text processing) |

---

## Workflows

| Workflow | Purpose |
|----------|---------|
| `workflows/logbook/select-logbook.md` | List and select logbook |
| `workflows/logbook/add-context-entry.md` | Create and prepend context entry |
| `workflows/logbook/update-objective-status.md` | Change objective status with validation |
| `workflows/logbook/compact-history.md` | Summarize and move old entries |
| `workflows/logbook/detect-session-progress.md` | Auto-detect work done in session |

---

## Status Icons Reference

| Icon | Status | Meaning |
|------|--------|---------|
| ⚪ | not_started | Pending, not yet begun |
| 🟡 | active | Currently in progress |
| 🔴 | blocked | Waiting on external input/dependency |
| 🟢 | achieved | Completed successfully |
| ⚫ | abandoned | Cancelled, no longer needed |

---

**Status:** ✅ DESIGNED
