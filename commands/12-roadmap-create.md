# Command: `/waves:roadmap-create [product-name]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Create a product-level roadmap with phases, milestones, and vision.

**Schema:** `ai_files/schemas/logbook_roadmap_schema.json`

**Output:** `ai_files/roadmap_w[N].json` (wave convention: w0 = foundation, w1+ = business waves)

**Parameters:** `[product-name]` (optional)

**Wave Naming Convention:**
- `roadmap_w0.json` — Foundation wave: agnostic capabilities not in any base project (e.g., phone auth with SMS/WhatsApp, new payment processor integration). Not specific to any business vertical.
- `roadmap_w1.json`, `roadmap_w2.json`, etc. — Business waves: each delivers a cohesive set of vertical-specific capabilities.
- The command auto-detects the next wave number by scanning existing `roadmap_w*.json` files.

**Key Features:** Vision gathering, phase planning, milestone definition, checkpoint validation, context entry creation

---

## Flow Derivations

| Flow | Condition | Description |
|------|-----------|-------------|
| **Flow A** | Existing manifest, rules, blueprint detected | Read project context, analyze current state, propose phases aligned with architecture |
| **Flow B** | From scratch (no context files) | Guide user through vision questions, then propose phases based on answers |

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
   /waves:project-init

   This command will configure your preferences and project context,
   which are required before creating a roadmap.
   ```
   → **EXIT COMMAND**

2. IF EXISTS → Continue to STEP 0

---

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Parameter Check**
**═══════════════════════════════════════════════════════════════════**

3. MAIN AGENT: Check if `[product-name]` parameter was provided

4. IF parameter provided:
   - Store as `requested_product_name`

5. IF parameter NOT provided:
   - MAIN AGENT (example in Spanish):
     ```
     💡 Tip: You can specify the product name directly:
     /waves:roadmap-create my-product

     Or leave it empty and I'll guide you through the vision questions.
     ```

6. **Wave number detection:**
   - Scan `ai_files/` for existing `roadmap_w*.json` files
   - If none exist → default to `w0` (foundation wave)
   - If some exist → suggest next sequential wave number
   - Ask user to confirm or override wave number
   - Store as `wave_number`
   - Check if `ai_files/roadmap_w[wave_number].json` already exists
   - If exists → Warn: "Wave [N] roadmap already exists. Use /waves:roadmap-update instead"

7. Continue to STEP 1

---

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Detect Context**
**═══════════════════════════════════════════════════════════════════**

6. MAIN AGENT: Check for existing project context files (in priority order):
   - Check if `ai_files/product_blueprint.json` exists (richest context: capabilities, flows, rules, metrics)
   - Check if `ai_files/product_foundation.json` exists (validated facts, financial benchmarks, SWOT)
   - Check if `ai_files/*_feasibility.json` exists (raw research, Monte Carlo, Bayesian)
   - Check if `ai_files/project_manifest.json` exists (software) or other manifest
   - Check if `ai_files/*_rules.json` exists (coding/project rules)

7. IF any context files found → Set `flow = A` (existing context flow)
   - Log what context was detected (blueprint > foundation > feasibility > manifest > rules)
   - Use highest-priority artifact as primary context source
   - Continue to STEP 2A

8. IF NO context files found → Set `flow = B` (from scratch flow)
   - Continue to STEP 2B

---

**═══════════════════════════════════════════════════════════════════**
**STEP 2A: Gather Vision (Flow B Only)**
**═══════════════════════════════════════════════════════════════════**

> **Flow B Condition:** No existing context detected (manifest, rules, blueprint)

9. MAIN AGENT (example in Spanish):
   ```
   📘 Comando: /waves:roadmap-create

   Voy a ayudarte a crear un roadmap para tu producto. Primero necesito
   entender tu visión con 4 preguntas. Puedes responder en detalle o
   elegir "No sé" para que lo detecte automáticamente.

   ¿Deseas continuar? (Si/No)
   ```

10. IF NO → Exit command

11. IF SI → Continue to QUESTION 1

---

**QUESTION 1: Problem Statement**

12. MAIN AGENT (example in Spanish):
    ```
    🎯 1/4 - ¿Qué problema resuelve tu producto?

    Describe el problema que tus usuarios enfrentan.

    Ejemplos:
    - "Los freelancers gastan 10 horas/semana en tareas administrativas"
    - "No existe una forma centralizada de organizar documentos de investigación"
    - "Las empresas pequeñas no pueden contratar devs a tiempo completo"

    Tu respuesta:
    0. No sé (auto-detectar)
    ```

13. USER: Provides answer or selects "0"

14. IF "0" (auto-detect):
    - SUBAGENT (roadmap-creator) will try to infer from user_pref.json or ask follow-up
    - Store as `vision.problem = "To be auto-detected"`
15. ELSE:
    - Store as `vision.problem = user_answer`

---

**QUESTION 2: Mission (Day-to-Day Value)**

16. MAIN AGENT (example in Spanish):
    ```
    🌍 2/4 - ¿Qué hace tu producto día a día para los usuarios?

    Describe la experiencia principal y el valor que entrega.

    Ejemplos:
    - "Automatiza facturación, impuestos y reportes en una interfaz simple"
    - "Organiza y busca documentos, genera citas automáticamente"
    - "Conecta empresas con desarrolladores freelance vetados"

    Tu respuesta:
    0. No sé (auto-detectar)
    ```

17. USER: Provides answer or selects "0"

18. IF "0":
    - Store as `vision.mission = "To be auto-detected"`
19. ELSE:
    - Store as `vision.mission = user_answer`

---

**QUESTION 3: Target Users**

20. MAIN AGENT (example in Spanish):
    ```
    👥 3/4 - ¿Quiénes usan tu producto?

    Describe roles y lo que cada uno necesita.

    Ejemplos:
    - "Freelancers — Necesitan automatizar tareas administrativas"
    - "Researchers — Necesitan organizar notas y colaborar"
    - "CTOs — Necesitan equipos de desarrollo escalables sin overhead"

    Tu respuesta (formato: Role — what they need):
    0. No sé (auto-detectar)
    ```

21. USER: Provides answer or selects "0"

22. IF "0":
    - Store as `vision.target_users = []` (to be auto-detected)
23. ELSE:
    - Parse answer into array of objects: `[{role: "...", need: "..."}, ...]`
    - Store as `vision.target_users`

---

**QUESTION 4: Success Criteria (Optional)**

24. MAIN AGENT (example in Spanish):
    ```
    📊 4/4 - ¿Cómo sabrás que tu producto está funcionando?

    Describe métricas de éxito (usuarios activos, retención, revenue, etc.)

    Ejemplos:
    - "1000 usuarios activos mensuales"
    - "Net Retention Rate > 110%"
    - "5 empresas pagando suscripciones"

    Tu respuesta (opcional):
    0. No sé / Dejar para después
    ```

25. USER: Provides answer or selects "0"

26. IF "0" or empty:
    - Store as `vision.success_criteria = []` (optional)
27. ELSE:
    - Parse into array: `["Metric 1", "Metric 2", ...]`
    - Store as `vision.success_criteria`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 2B: Read Context (Flow A Only)**
**═══════════════════════════════════════════════════════════════════**

> **Flow A Condition:** Existing context detected (manifest, rules, blueprint)

28. MAIN AGENT (example in Spanish):
    ```
    📘 Comando: /waves:roadmap-create

    Detecté que ya tienes contexto de tu proyecto:
    • Manifiesto encontrado: ai_files/project_manifest.json
    • Reglas detectadas: ai_files/frontend_rules.json
    • Blueprint detectado: ai_files/architecture_blueprint.json

    Voy a usar esta información para crear un roadmap alineado
    con tu arquitectura y convenciones.

    ¿Deseas continuar? (Si/No)
    ```

29. IF NO → Exit command

30. IF SI:
    - SUBAGENT reads project_manifest.json, rules, blueprint
    - Extracts: project name, technical stack, architecture, current features
    - Analyzes: what's implemented vs. planned
    - Store extracted context
    - Continue to STEP 3

---

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Dispatch roadmap-creator Subagent**
**═══════════════════════════════════════════════════════════════════**

31. MAIN AGENT: Prepare context package for subagent:
    ```
    {
      "flow": "A" or "B",
      "requested_product_name": "...",
      "vision": {
        "problem": "...",
        "mission": "...",
        "target_users": [...],
        "success_criteria": [...]
      },
      "context": {
        "manifest": {...},
        "rules": {...},
        "blueprint": {...}
      },
      "user_pref": {...}
    }
    ```

32. MAIN AGENT: Invoke **roadmap-creator** subagent with context package

33. SUBAGENT: Analyze vision + context (if Flow A)
    - Generate proposed phases aligned with vision and architecture
    - For each phase: title, description, duration estimate, key milestones
    - Identify dependencies between phases
    - Generate open_questions for user validation

34. SUBAGENT: Return to MAIN AGENT with:
    ```
    {
      "proposed_phases": [
        {
          "phase_number": 1,
          "title": "...",
          "description": "...",
          "duration_weeks": X,
          "milestones": [
            {"title": "...", "week": N}
          ],
          "dependencies": ["previous phase"],
          "success_criteria": [...]
        }
      ],
      "proposed_decisions": [
        {"decision": "...", "rationale": "..."}
      ],
      "open_questions": [
        {"question": "...", "impact": "high|medium|low"}
      ]
    }
    ```

---

**═══════════════════════════════════════════════════════════════════**
**STEP 4: User Validation (Checkpoint)**
**═══════════════════════════════════════════════════════════════════**

35. MAIN AGENT (example in Spanish):
    ```
    📋 Roadmap propuesto para: [product-name]

    Te presento las fases, hitos y decisiones. Revísalas y confirma,
    modifica o agrega lo que necesites.

    FASES PROPUESTAS:
    ═════════════════

    📌 FASE 1: MVP - Core Features
    ┌─ Descripción: Lanzar features esenciales para early users
    ├─ Duración: 6 semanas
    ├─ Hitos:
    │  • Semana 2: Authentication y onboarding
    │  • Semana 4: Core feature 1 completada
    │  • Semana 6: Beta launch
    └─ Éxito: 100 beta users, 80% retention

    📌 FASE 2: Polish & Scaling
    ┌─ Descripción: Mejorar UX, preparar para escala
    ├─ Duración: 4 semanas
    ├─ Hitos:
    │  • Semana 2: Performance optimization
    │  • Semana 4: Production deployment
    └─ Éxito: 99.9% uptime, <100ms latency

    [más fases...]

    DECISIONES PROPUESTAS:
    ═════════════════════
    • Tech Stack: TypeScript + Next.js (del blueprint)
    • Database: PostgreSQL + Redis (detectado de reglas)
    • Deployment: Vercel (recomendado para stack)

    PREGUNTAS ABIERTAS:
    ═════════════════
    ❓ ALTA PRIORIDAD:
       - ¿Cuándo necesitas estar en producción?
       - ¿Cuál es tu presupuesto de recursos?

    ❓ MEDIA PRIORIDAD:
       - ¿Necesitas multitenancy desde el inicio?

    OPCIONES:
    1. Confirmar (crear roadmap con estas fases)
    2. Modificar una fase específica
    3. Agregar una nueva fase
    4. Cancelar (no crear roadmap)

    Elige 1-4:
    ```

36. USER: Selects option

37. IF "1" (Confirm):
    - Continue to STEP 5 (Generate Roadmap File)

38. IF "2" (Modify phase):
    - MAIN AGENT: Show list of phases with numbers
    - USER: Selects phase number
    - MAIN AGENT: Ask what to modify (title, duration, milestones, success criteria)
    - USER: Provides modification
    - Update `proposed_phases` array
    - Return to Step 35 for final validation

39. IF "3" (Add phase):
    - MAIN AGENT (example in Spanish):
      ```
      📝 Nueva fase:

      Nombre: (ej: "Phase 3: Enterprise Features")
      Descripción: (ej: "Add multi-user management, SSO, advanced analytics")
      Duración (semanas): 4
      Hitos principales: (uno por línea)

      Escribe la información:
      ```
    - USER: Provides phase details
    - SUBAGENT: Add new phase to `proposed_phases`
    - Return to Step 35

40. IF "4" (Cancel):
    - MAIN AGENT: "Comando cancelado. No se creó ningún roadmap."
    - → **EXIT COMMAND**

---

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Generate Roadmap File**
**═══════════════════════════════════════════════════════════════════**

41. SUBAGENT: Build JSON following `logbook_roadmap_schema.json` exactly

42. SUBAGENT: Populate structure:
    ```json
    {
      "roadmap": {
        "product_name": "From parameter or auto-detected",
        "product_status": "planning",
        "created_date": "Today's date",
        "last_updated": "Today's date"
      },
      "vision": {
        "problem": "From vision.problem",
        "mission": "From vision.mission",
        "target_users": "From vision.target_users",
        "success_criteria": "From vision.success_criteria"
      },
      "phases": [
        {
          "phase_id": "phase_1",
          "phase_number": 1,
          "title": "From confirmed proposal",
          "description": "From confirmed proposal",
          "duration_weeks": X,
          "start_week": calculated,
          "end_week": calculated,
          "status": "pending",
          "milestones": [
            {
              "title": "From confirmed proposal",
              "week": N,
              "status": "pending",
              "deliverables": [...]
            }
          ],
          "success_criteria": [...]
        }
      ],
      "decisions": [
        {
          "decision_id": "dec_1",
          "decision": "From proposed_decisions",
          "rationale": "From proposed_decisions",
          "date_decided": "Today's date"
        }
      ],
      "recent_context": [
        {
          "entry_type": "creation",
          "timestamp": "Now",
          "content": "Roadmap created with X phases"
        }
      ]
    }
    ```

43. SUBAGENT: Validate against `logbook_roadmap_schema.json`

44. SUBAGENT: Write to `ai_files/roadmap_w[N].json` (where N is the wave_number from STEP 0)

---

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Post-Creation Summary**
**═══════════════════════════════════════════════════════════════════**

45. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Roadmap creado exitosamente!

    📁 Archivo generado:
      • ai_files/roadmap_w[N].json

    📊 Resumen del roadmap:
      • Producto: [product-name]
      • Fases: [X fases] planificadas
      • Duración total: [Y semanas]
      • Status: planning
      • Decisiones documentadas: [Z]

    📋 Fases en el roadmap:
      1. [Phase 1 Title] - [X semanas]
      2. [Phase 2 Title] - [X semanas]
      [...]

    🎯 Próximo paso:

      Crea un logbook para la primera fase:
      /waves:logbook-create [product-name]-phase-1

      El logbook te ayudará a registrar el progreso,
      decisiones y hallazgos durante la ejecución.

    💡 Tip: Actualiza el roadmap según progresa:
      /waves:roadmap-update roadmap_w[N].json
    ```

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Orchestrator Subagents:**

1. **roadmap-creator**
   - Tools: Read, Write
   - Responsibilities:
     - (Flow B) Generate proposed phases from vision questions
     - (Flow A) Read manifest/rules/blueprint, generate aligned phases
     - Generate proposed_decisions and open_questions
     - Return structured phase proposal
   - Workflows: `workflows/roadmap/generate-phases.md`, `workflows/roadmap/align-to-context.md`

---

**═══════════════════════════════════════════════════════════════════**
**WORKFLOWS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

1. `workflows/roadmap/check-prerequisites.md`
   - Check user_pref.json exists

2. `workflows/roadmap/detect-context.md`
   - Check for manifest, rules, blueprint
   - Determine Flow A or B

3. `workflows/roadmap/gather-vision.md`
   - 4 vision questions (problem, mission, target_users, success_criteria)
   - Handle "auto-detect" option for each

4. `workflows/roadmap/generate-phases.md`
   - Create phase proposals from vision
   - Set durations, milestones, success criteria

5. `workflows/roadmap/align-to-context.md`
   - Read manifest/rules/blueprint
   - Generate phases aligned with architecture and tech stack

6. `workflows/roadmap/validate-roadmap.md`
   - Present phases for user confirmation
   - Handle modifications and additions
   - Collect final approvals

7. `workflows/roadmap/generate-roadmap-json.md`
   - Build roadmap JSON from confirmed phases
   - Validate against schema
   - Write to file

---

**Status:** ✅ DESIGNED

