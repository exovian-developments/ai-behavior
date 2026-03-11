# Command: `/ai-behavior:roadmap-update [roadmap-file]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Update an existing product roadmap with progress, decisions, or structural changes.

**Schema:** `ai_files/schemas/logbook_roadmap_schema.json`

**Output:** Updates existing roadmap file in place

**Parameters:** `[roadmap-file]` (optional - path to roadmap JSON or product name)

**Key Features:** Progress tracking, decision logging, phase transitions, roadmap restructuring, context entry management

---

## Flow Derivations

| Flow | Update Type | Description |
|------|------------|-------------|
| **Flow 1** | Progress Report | Track completed/blocked milestones, update phase status |
| **Flow 2** | Decision Log | Record product decisions with rationale |
| **Flow 3** | Question Resolution | Add or resolve open questions |
| **Flow 4** | Phase Transition | Move to next phase, mark current as complete |
| **Flow 5** | Restructure | Modify phases/milestones, adjust timeline, add/remove phases |

---

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

0. MAIN AGENT: Check if `ai_files/user_pref.json` exists

1. IF NOT EXISTS → MAIN AGENT (in user's language or English):
   ```
   ⚠️ Missing configuration!

   The file ai_files/user_pref.json was not found.

   Please run first:
   /ai-behavior:project-init

   This command will configure your preferences, which are required
   before updating a roadmap.
   ```
   → **EXIT COMMAND**

2. MAIN AGENT: Check if at least one roadmap file exists in `ai_files/`
   - Search both patterns: `roadmap_w*.json` (wave convention) and `*_roadmap.json` (legacy)

3. IF NO roadmap files exist:
   ```
   ⚠️ No roadmap found!

   No roadmap files exist in ai_files/ yet.

   Create one first:
   /ai-behavior:roadmap-create my-product

   Then you can update it with this command.
   ```
   → **EXIT COMMAND**

4. IF exists → Continue to STEP 0

---

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Select Roadmap**
**═══════════════════════════════════════════════════════════════════**

5. MAIN AGENT: Check if `[roadmap-file]` parameter was provided

6. IF parameter provided:
   - Try to resolve to actual file path in order:
     1. Exact match: `ai_files/[parameter]` (if ends with `.json`)
     2. Wave match: `ai_files/roadmap_w[parameter].json` (if parameter is a number)
     3. Legacy match: `ai_files/[parameter]_roadmap.json`
   - Check if resolved file exists
   - IF exists → Store as `selected_roadmap_path`
   - IF not exists → MAIN AGENT (example in Spanish):
     ```
     ⚠️ Roadmap not found: ai_files/[roadmap-file]

     Available roadmaps:
     • ai_files/roadmap_w0.json (Foundation)
     • ai_files/roadmap_w1.json (Business Wave 1)
     [...]

     Try again with correct name or wave number:
     /ai-behavior:roadmap-update 0        (by wave number)
     /ai-behavior:roadmap-update roadmap_w0.json  (by filename)
     ```
     → **EXIT COMMAND**

7. IF parameter NOT provided:
   - MAIN AGENT: List all roadmaps in `ai_files/` (both `roadmap_w*.json` and `*_roadmap.json`):
     ```
     🗂️ Available roadmaps:

     1. roadmap_w0.json (Foundation)
     2. roadmap_w1.json (Business Wave 1)
     3. roadmap_w2.json (Business Wave 2)

     Which roadmap do you want to update? (Enter number, wave number, or filename):
     ```
   - USER: Selects option
   - Store as `selected_roadmap_path`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Present Dashboard**
**═══════════════════════════════════════════════════════════════════**

8. MAIN AGENT: Read selected roadmap file

9. MAIN AGENT: Extract and display current status:
   ```
   📊 ROADMAP DASHBOARD: [product-name]

   🎯 Product Status: [planning | in_progress | launched | paused]
   📅 Created: [date] | Last Updated: [date]

   PHASE PROGRESS:
   ═════════════════════════════════════════

   ✅ PHASE 1: MVP - Core Features
   ├─ Status: Completed
   ├─ Duration: 6 weeks (Feb - Mar)
   └─ Milestones: 3/3 completed

   🔵 PHASE 2: Polish & Scaling (ACTIVE)
   ├─ Status: In Progress (Week 2/4)
   ├─ Duration: 4 weeks (Apr - May)
   └─ Milestones:
      ✅ Week 1: Performance optimization
      🔵 Week 2: Production deployment (in progress)
      ⬜ Week 3: Monitoring & alerts setup
      ⬜ Week 4: Load testing

   ⬜ PHASE 3: Enterprise Features
   ├─ Status: Not Started
   ├─ Duration: 4 weeks (Jun - Jul)
   └─ Milestones: 0/4 completed

   🔴 PHASE 4: Global Expansion
   ├─ Status: Blocked (depends on Phase 3)
   ├─ Duration: 6 weeks (Aug - Sep)
   └─ Milestones: 0/5 completed

   OPEN QUESTIONS:
   ═════════════════════════════════════════
   ❓ [3 open questions]
   - Question 1
   - Question 2
   - Question 3

   RECENT DECISIONS:
   ═════════════════════════════════════════
   📋 [Last 3 decisions]
   - Decision 1 (made 5 days ago)
   - Decision 2 (made 2 weeks ago)
   - Decision 3 (made 1 month ago)

   What do you want to do?
   ```

---

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Ask Update Type**
**═══════════════════════════════════════════════════════════════════**

10. MAIN AGENT (example in Spanish):
    ```
    🎯 ¿Qué quieres actualizar?

    1. Reportar progreso en hitos
       → Marcar hitos como completados, bloqueados, etc.

    2. Registrar una decisión
       → Documentar decisión importante con rationale

    3. Agregar/Resolver pregunta
       → Agregar nueva pregunta abierta o resolverla

    4. Transicionar a siguiente fase
       → Marcar fase actual como completada, iniciar siguiente

    5. Reestructurar fases/hitos
       → Agregar/remover fases, ajustar timeline, cambiar hitos

    0. Auto-detectar (basado en contexto)

    Elige 0-5:
    ```

11. USER: Selects option (1-5) or "0"

12. IF "0" (auto-detect):
    - SUBAGENT analyzes roadmap status and suggests next logical update type
    - Propose to user: "Based on your timeline, I suggest: [Flow X]"
    - Continue with user-selected flow

13. IF "1" → Go to **FLOW 1: Progress Report**

14. IF "2" → Go to **FLOW 2: Decision Log**

15. IF "3" → Go to **FLOW 3: Question Resolution**

16. IF "4" → Go to **FLOW 4: Phase Transition**

17. IF "5" → Go to **FLOW 5: Restructure**

---

**═══════════════════════════════════════════════════════════════════**
**FLOW 1: Progress Report**
**═══════════════════════════════════════════════════════════════════**

18. MAIN AGENT (example in Spanish):
    ```
    📈 Progress Report

    Selecciona el hito que deseas actualizar:

    FASE 2: Polish & Scaling (IN PROGRESS)
    ├─ 1. ✅ Week 1: Performance optimization (Completed)
    ├─ 2. 🔵 Week 2: Production deployment (In progress)
    ├─ 3. ⬜ Week 3: Monitoring & alerts setup (Not started)
    └─ 4. ⬜ Week 4: Load testing (Not started)

    Elige número del hito (1-4) o número de fase.multiple (1,2,3):
    ```

19. USER: Selects milestone(s) to update

20. For each selected milestone:
    - MAIN AGENT: Show current status
    - Ask: "Nuevo status?"
      - Options: ✅ Completed | 🔵 In Progress | ⬜ Not Started | 🔴 Blocked
    - USER: Selects new status
    - IF status is "Blocked" or "In Progress":
      - Ask: "Notas o blockers?" (optional)
      - USER: Provides notes
      - Store in milestone: `notes: "user notes"`
    - Update milestone.status in memory

21. After all milestones updated:
    - MAIN AGENT (example in Spanish):
      ```
      ✅ Cambios registrados:
      • Milestone 2: Now In Progress
      • Milestone 3: Now Not Started

      ¿Deseas cambiar el status de la fase?
      1. Confirmar y actualizar fase
      2. No cambiar fase (solo milestones)

      Elige 1 o 2:
      ```

22. IF "1":
    - Recalculate phase status:
      - If all milestones completed → phase_status = "completed"
      - If any milestone in progress → phase_status = "in_progress"
      - If any milestone blocked → phase_status = "blocked"
    - Update phase.status in memory

23. Continue to **STEP 4: Apply Changes**

---

**═══════════════════════════════════════════════════════════════════**
**FLOW 2: Decision Log**
**═══════════════════════════════════════════════════════════════════**

24. MAIN AGENT (example in Spanish):
    ```
    📋 Registrar Decisión

    ¿Qué decisión quieres documentar?

    Describe la decisión de forma clara.
    Ejemplo: "Cambiar tech stack de Vue a React por mejor comunidad"
    ```

25. USER: Provides decision description

26. MAIN AGENT:
    ```
    📋 Decisión registrada:
    "Cambiar tech stack de Vue a React por mejor comunidad"

    ¿Cuál es la rationale detrás de esta decisión?

    Detalla:
    - Alternativas consideradas
    - Por qué elegiste esta opción
    - Impacto en el roadmap
    ```

27. USER: Provides rationale

28. MAIN AGENT:
    ```
    📋 ¿Qué impacto tiene en el roadmap?

    1. Bajo - No afecta fases/hitos
    2. Medio - Afecta duración de 1 fase
    3. Alto - Requiere restructurar roadmap

    Elige 1-3:
    ```

29. USER: Selects impact level

30. Store in memory:
    ```json
    {
      "decision_id": "dec_[timestamp]",
      "decision": "user_decision",
      "rationale": "user_rationale",
      "impact": "low|medium|high",
      "date_decided": "today",
      "requires_restructure": "high" ? true : false
    }
    ```

31. IF impact = "high" (requires_restructure = true):
    - MAIN AGENT (example in Spanish):
      ```
      ⚠️ Esta decisión requiere reestructurar el roadmap.

      Opciones:
      1. Actualizar roadmap ahora
         → Te guiaré a través de cambios en fases/hitos
      2. Solo registrar decisión
         → Actualizar roadmap después manualmente

      Elige 1 o 2:
      ```
    - IF "1" → Go to **FLOW 5: Restructure** after registering decision
    - IF "2" → Continue to STEP 4

32. IF impact = "low" or "medium" → Continue to **STEP 4: Apply Changes**

---

**═══════════════════════════════════════════════════════════════════**
**FLOW 3: Question Resolution**
**═══════════════════════════════════════════════════════════════════**

33. MAIN AGENT (example in Spanish):
    ```
    ❓ Preguntas Abiertas

    Opciones:
    1. Agregar nueva pregunta
    2. Resolver pregunta existente
    3. Cambiar prioridad de pregunta

    Elige 1-3:
    ```

34. USER: Selects option

35. **IF "1" (Add new question):**

    - MAIN AGENT:
      ```
      📝 ¿Cuál es la nueva pregunta?

      Ejemplo: "¿Necesitamos multitenancy desde el MVP?"
      ```
    - USER: Provides question
    - MAIN AGENT:
      ```
      📊 Prioridad:
      1. Alta - Afecta decisiones críticas
      2. Media - Importante pero puede esperar
      3. Baja - Aspiracional

      Elige 1-3:
      ```
    - USER: Selects priority
    - Store in memory:
      ```json
      {
        "question_id": "q_[timestamp]",
        "question": "user_question",
        "priority": "high|medium|low",
        "status": "open",
        "added_date": "today"
      }
      ```

36. **IF "2" (Resolve question):**

    - MAIN AGENT: List open questions:
      ```
      ❓ Preguntas abiertas:
      1. ¿Necesitamos multitenancy desde el MVP?
      2. ¿Cuál es presupuesto de recursos?
      3. ¿Cuándo necesitas estar en producción?

      ¿Cuál pregunta deseas resolver? (1-3):
      ```
    - USER: Selects question number
    - MAIN AGENT:
      ```
      ✅ Resolver: "¿Necesitamos multitenancy desde el MVP?"

      ¿Cuál fue la respuesta/resolución?
      ```
    - USER: Provides resolution
    - Store in memory: Mark question as "resolved" with answer

37. **IF "3" (Change priority):**

    - MAIN AGENT: List open questions with priorities
    - USER: Selects question and new priority
    - Update in memory

38. Continue to **STEP 4: Apply Changes**

---

**═══════════════════════════════════════════════════════════════════**
**FLOW 4: Phase Transition**
**═══════════════════════════════════════════════════════════════════**

39. MAIN AGENT: Check current phase status
    - Identify active phase
    - Check if all milestones are completed

40. IF active phase has incomplete milestones:
    ```
    ⚠️ Fase actual tiene milestones no completados:
    • Milestone 3: Blocked
    • Milestone 4: Not Started

    ¿Deseas transicionar de todas formas?
    1. Sí, marcar fase como completada de todas formas
    2. No, actualizar milestones primero

    Elige 1 o 2:
    ```
    - IF "2" → Go to **FLOW 1: Progress Report**

41. MAIN AGENT (example in Spanish):
    ```
    🚀 Transición de Fase

    Fase actual: PHASE 2 - Polish & Scaling (Completada)
    Siguiente fase: PHASE 3 - Enterprise Features

    ✅ PHASE 2 será marcada como "completed"
    🔵 PHASE 3 será marcada como "in_progress"

    ¿Deseas continuar?
    1. Sí, transicionar
    2. No, cancelar

    Elige 1 o 2:
    ```

42. IF "1":
    - Update in memory:
      - Current phase: status = "completed"
      - Next phase: status = "in_progress"
    - If next phase has milestones:
      - Mark first milestone as "in_progress"
      - Others as "not_started"

43. MAIN AGENT (example in Spanish):
    ```
    ✅ Fase transitional completada:

    ANTES:
    🔵 PHASE 2 - In Progress
    ⬜ PHASE 3 - Not Started

    AHORA:
    ✅ PHASE 2 - Completed
    🔵 PHASE 3 - In Progress
       └─ 🔵 Milestone 1: In Progress
       └─ ⬜ Milestone 2: Not Started
       └─ ⬜ Milestone 3: Not Started
       └─ ⬜ Milestone 4: Not Started

    ¿Deseas crear un logbook para la nueva fase?
    1. Sí, crear logbook
    2. No, actualizar roadmap solo

    Elige 1 o 2:
    ```

44. IF "1" → Suggest command: `/ai-behavior:logbook-create [product-name]-phase-3`

45. Continue to **STEP 4: Apply Changes**

---

**═══════════════════════════════════════════════════════════════════**
**FLOW 5: Restructure Roadmap**
**═══════════════════════════════════════════════════════════════════**

46. MAIN AGENT (example in Spanish):
    ```
    🏗️ Reestructurar Roadmap

    ¿Qué quieres cambiar?

    1. Agregar nueva fase
    2. Remover fase existente
    3. Cambiar duración/timeline de fase
    4. Agregar/remover hito de fase
    5. Reordenar fases

    Elige 1-5:
    ```

47. USER: Selects option

48. **IF "1" (Add phase):**

    - MAIN AGENT:
      ```
      📝 Nueva Fase

      Nombre: (ej: "Phase 5: Mobile App")
      Descripción: (ej: "iOS y Android native apps")
      Duración (semanas): 8
      Orden en roadmap (número): 5

      Hitos principales: (uno por línea)
      - iOS development
      - Android development
      - Testing y QA
      - App store submission

      Escribe la información:
      ```
    - USER: Provides phase details
    - Store phase in memory with new phase_id and order

49. **IF "2" (Remove phase):**

    - MAIN AGENT: List phases with numbers
    - USER: Selects phase to remove
    - Check dependencies: "¿Otras fases dependen de esta?"
    - If yes: Warn user, ask confirmation
    - Mark phase as "removed" in memory (don't delete, mark deprecated)

50. **IF "3" (Change duration/timeline):**

    - MAIN AGENT: List phases
    - USER: Selects phase
    - MAIN AGENT:
      ```
      Fase: PHASE 2 - Polish & Scaling
      Duración actual: 4 semanas
      Semanas planeadas: 2-5

      Nueva duración (semanas): 6
      ```
    - USER: Provides new duration
    - SUBAGENT: Recalculate timeline for all subsequent phases
    - Show impact: "Total roadmap duration changed from 20 to 22 weeks"

51. **IF "4" (Add/Remove milestone):**

    - MAIN AGENT: List phases
    - USER: Selects phase
    - MAIN AGENT:
      ```
      Opciones:
      1. Agregar nuevo hito
      2. Remover hito existente
      3. Editar hito existente

      Elige 1-3:
      ```
    - USER: Selects option and provides details

52. **IF "5" (Reorder phases):**

    - MAIN AGENT: Show phases with order numbers
    - USER: Specifies new order (e.g., "3, 1, 2, 4")
    - Validate: Check dependencies before allowing reorder
    - Update phase_number and phase_id in memory

53. After restructuring:
    - MAIN AGENT: Show "BEFORE" vs "AFTER" comparison
    - Ask for final confirmation
    - Continue to **STEP 4: Apply Changes**

---

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Dispatch roadmap-updater Subagent**
**═══════════════════════════════════════════════════════════════════**

54. MAIN AGENT: Prepare update package for subagent:
    ```json
    {
      "selected_roadmap_path": "...",
      "update_type": "progress|decision|question|phase_transition|restructure",
      "user_input": {
        "updated_milestones": [...],
        "new_decision": {...},
        "new_question": {...},
        "phase_transition": {...},
        "restructure_changes": [...]
      },
      "timestamp": "now"
    }
    ```

55. MAIN AGENT: Invoke **roadmap-updater** subagent with update package

56. SUBAGENT: Validate update against current roadmap state
    - Check for conflicts
    - Validate timeline consistency
    - Ensure dependencies are respected

57. SUBAGENT: Return to MAIN AGENT with validation result + proposed changes

---

**═══════════════════════════════════════════════════════════════════**
**STEP 4: Apply Changes (User Confirmation)**
**═══════════════════════════════════════════════════════════════════**

58. MAIN AGENT: Display proposed changes summary:
    ```
    📋 CAMBIOS PROPUESTOS:

    ACTUALIZACIONES DE HITOS:
    • Milestone "Performance optimization" → ✅ Completed
    • Milestone "Production deployment" → 🔵 In Progress
    • Fase 2 status → "in_progress" (recalculated)

    NUEVA DECISIÓN REGISTRADA:
    • "Agregar caché en endpoints críticos"
    • Rationale: "Mejorar latencia a <100ms"
    • Impacto: Medio (afecta duración de Phase 2)

    CONTEXTO A AGREGAR:
    • entry_type: "progress_report"
    • timestamp: "2025-02-26T10:30:00Z"
    • content: "Updated milestones, added decision about caching"

    ¿Deseas aplicar estos cambios?
    1. Sí, actualizar roadmap
    2. No, descartar cambios

    Elige 1 o 2:
    ```

59. IF "1":
    - Continue to STEP 5: Generate Updated File

60. IF "2":
    - MAIN AGENT: "Comando cancelado. No se efectuaron cambios."
    - → **EXIT COMMAND**

---

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Generate Updated File**
**═══════════════════════════════════════════════════════════════════**

61. SUBAGENT: Load current roadmap from file

62. SUBAGENT: Apply all changes from update package:
    - Update milestone statuses
    - Add new decision to `decisions` array
    - Add/resolve questions in `open_questions` array
    - Update phase statuses
    - Apply restructuring changes
    - Update `product.last_updated = today`

63. SUBAGENT: Manage `recent_context` array (prepend new entry at index 0):
    ```json
    {
      "entry_type": "progress_report|decision|question_resolved|phase_transition|restructure",
      "timestamp": "ISO 8601",
      "content": "Human-readable summary of changes",
      "details": {
        "milestones_updated": [...],
        "decisions_added": [...],
        "questions_resolved": [...]
      }
    }
    ```

64. SUBAGENT: Manage context compaction:
    - IF `recent_context.length > 20`:
      - Archive oldest 10 entries to separate file: `ai_files/roadmap_w[N]_archive.json`
      - Keep most recent 10 in main roadmap
      - Add pointer to archive in main file

65. SUBAGENT: Validate entire roadmap against `logbook_roadmap_schema.json`

66. SUBAGENT: Write updated roadmap to `ai_files/roadmap_w[N].json`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Post-Update Summary**
**═══════════════════════════════════════════════════════════════════**

67. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Roadmap actualizado exitosamente!

    📁 Archivo actualizado:
      • ai_files/roadmap_w[N].json

    📊 Cambios aplicados:
      • Hitos actualizados: 2
      • Nueva decisión registrada
      • Status de Fase 2: in_progress

    📈 Estado actual del roadmap:

    🔵 PHASE 2: Polish & Scaling (IN PROGRESS - Week 2/4)
    ✅ PHASE 1: MVP - Core Features (Completed)
    ⬜ PHASE 3: Enterprise Features (Not Started)

    🎯 Próximo paso:
    ```

68. IF milestone just completed → Suggest:
    ```
    🎯 Hito completado: "Production deployment"

    Considera crear un logbook entry para documentar:
    /ai-behavior:logbook-create [product-name]-phase-2-deployment
    ```

69. IF phase just completed → Suggest:
    ```
    🎉 ¡Fase completada! PHASE 2 está lista.

    Próxima fase: PHASE 3 - Enterprise Features

    Crea un logbook para la nueva fase:
    /ai-behavior:logbook-create [product-name]-phase-3

    O transiciona en el roadmap:
    /ai-behavior:roadmap-update roadmap_w[N].json
    (selecciona opción 4: "Transicionar a siguiente fase")
    ```

70. Standard tip:
    ```
    💡 Tip: Mantén el roadmap sincronizado conforme avanzas:
      /ai-behavior:roadmap-update roadmap_w[N].json
    ```

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Orchestrator Subagent:**

1. **roadmap-updater**
   - Tools: Read, Write
   - Responsibilities:
     - Validate proposed changes against current roadmap
     - Apply updates to roadmap structure
     - Manage recent_context array (prepend, archive if needed)
     - Update last_updated timestamp
     - Validate final roadmap against schema
   - Workflows: `workflows/roadmap/validate-update.md`, `workflows/roadmap/apply-changes.md`, `workflows/roadmap/manage-context.md`

---

**═══════════════════════════════════════════════════════════════════**
**WORKFLOWS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

1. `workflows/roadmap/select-roadmap.md`
   - Find and select roadmap from parameter or list

2. `workflows/roadmap/present-dashboard.md`
   - Extract and display current roadmap status
   - Show phase progress, open questions, recent decisions

3. `workflows/roadmap/progress-report-flow.md`
   - Select milestones
   - Update statuses
   - Recalculate phase status

4. `workflows/roadmap/decision-log-flow.md`
   - Collect decision, rationale, impact
   - Check if restructure needed

5. `workflows/roadmap/question-resolution-flow.md`
   - Add new questions
   - Resolve existing questions
   - Change priorities

6. `workflows/roadmap/phase-transition-flow.md`
   - Verify phase completion
   - Transition to next phase
   - Update milestone statuses

7. `workflows/roadmap/restructure-flow.md`
   - Add/remove/reorder phases
   - Manage milestones
   - Recalculate timelines
   - Show before/after comparison

8. `workflows/roadmap/validate-update.md`
   - Check for conflicts
   - Validate dependencies
   - Ensure timeline consistency

9. `workflows/roadmap/apply-changes.md`
   - Load current roadmap
   - Apply all updates
   - Validate against schema
   - Write to file

10. `workflows/roadmap/manage-context.md`
    - Prepend new context entry
    - Handle archive when context > 20 entries
    - Update last_updated timestamp

---

**Status:** ✅ DESIGNED

