# Command: `/ai-behavior:logbook-create [filename]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Create a new logbook for a ticket/task with structured objectives and actionable guidance.

**Schema (selected by project_type):**
- Software → `ai_files/schemas/logbook_software_schema.json`
- General → `ai_files/schemas/logbook_general_schema.json`

**Output:** `ai_files/logbooks/[filename].json`

**Parameters:** `[filename]` (optional) - Name for the logbook file

**Key Features:**
- Interactive ticket/task clarification
- **Software:** Code tracing, main objectives with scope (files + rules), secondary with completion_guide referencing code
- **General:** Main objectives with scope (references + standards), secondary with completion_guide referencing documents/practices
- User validation at key checkpoints

---

## Flow Derivations

| Flow | Condition | Description |
|------|-----------|-------------|
| **A** | Software project | Full analysis with code tracing, rules integration |
| **B** | General project | Simplified flow without code analysis |

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

   This command requires user preferences to be configured.
   ```
   → **EXIT COMMAND**

3. IF EXISTS → Read and get `preferred_language`, `project_context.project_type`

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Parameter Check and Tip**
**═══════════════════════════════════════════════════════════════════**

4. MAIN AGENT: Check if filename parameter provided

5. IF NO parameter → Show tip (in user's language):
   ```
   💡 TIP: Puedes ejecutar más rápido con:
      /ai-behavior:logbook-create TICKET-123.json
   ```

6. IF parameter provided → Validate filename format
   - Must end in `.json`
   - No special characters except `-` and `_`
   - IF invalid → Ask for valid filename

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Check Existing Logbook**
**═══════════════════════════════════════════════════════════════════**

7. MAIN AGENT: Check if `ai_files/logbooks/[filename].json` exists

8. IF EXISTS → MAIN AGENT:
   ```
   ⚠️ Ya existe una bitácora con ese nombre!

   Archivo: ai_files/logbooks/[filename].json

   Opciones:
   1. Usar otro nombre
   2. Sobrescribir (se perderá el contenido actual)

   Elige 1 o 2:
   ```
   - IF "1" → Ask for new filename, repeat check
   - IF "2" → Continue with warning

9. IF NOT EXISTS → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Gather Ticket Information**
**═══════════════════════════════════════════════════════════════════**

10. MAIN AGENT:
    ```
    📋 Vamos a crear la bitácora de trabajo.

    ¿Cuál es el título del ticket o tarea?
    (Ejemplo: "Implementar endpoint GET /products/:id")
    ```

11. USER: Provides title

12. MAIN AGENT:
    ```
    ¿Tienes una URL del ticket? (Jira, GitHub, etc.)
    (Escribe la URL o presiona Enter para omitir)
    ```

13. USER: Provides URL or skips

14. MAIN AGENT:
    ```
    Describe el ticket/tarea con todos los detalles relevantes:
    - ¿Qué se necesita lograr?
    - ¿Hay criterios de aceptación?
    - ¿Hay restricciones o consideraciones especiales?
    ```

15. USER: Provides description

16. MAIN AGENT: Validate description clarity
    - IF description is vague or unclear:
      ```
      🤔 Necesito más claridad para crear objetivos precisos.

      [Specific questions about unclear aspects]

      ¿Puedes clarificar?
      ```
    - Repeat until objectives are clear enough to proceed

**═══════════════════════════════════════════════════════════════════**
**STEP 3: FORK - Software vs General**
**═══════════════════════════════════════════════════════════════════**

17. MAIN AGENT: Read `project_type` from `user_pref.json`

18. IF `project_type === "software"` → Go to **FLUJO A**

19. IF `project_type === "general"` → Go to **FLUJO B**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A: SOFTWARE PROJECT**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP A1: Initial Code Tracing**
**═══════════════════════════════════════════════════════════════════**

20. MAIN AGENT:
    ```
    🔍 Analizando el proyecto para identificar código relacionado...
    ```

21. MAIN AGENT: Read `ai_files/project_manifest.json`
    - Identify relevant layers from `architecture_patterns_by_layer`
    - Identify relevant features from `features`
    - Note entry points and tech stack

22. MAIN AGENT: Trace code based on ticket description
    - Search for related files, classes, functions
    - Identify patterns and conventions in related code
    - Note dependencies between components

23. MAIN AGENT: Read `ai_files/project_rules.json` (if exists)
    - Identify rules that apply to the identified layers/features
    - Note rule IDs for scope.rules

24. MAIN AGENT: Present analysis summary
    ```
    📊 Análisis inicial completado:

    Capas relacionadas:
    • api_layer (src/controllers/)
    • data_layer (src/models/)

    Archivos de referencia identificados:
    • src/controllers/ProductController.ts
    • src/models/Product.ts
    • src/dtos/ProductDTO.ts

    Reglas aplicables:
    • #3: Controllers must use DTOs for responses
    • #7: All endpoints require authentication middleware

    ¿Esta información es correcta? (Si/No/Ajustar)
    ```

25. USER: Validates or adjusts
    - IF "Ajustar" → User provides corrections, agent updates

**═══════════════════════════════════════════════════════════════════**
**STEP A2: Generate Main Objectives**
**═══════════════════════════════════════════════════════════════════**

26. MAIN AGENT: Based on ticket and analysis, generate main objectives
    - Each objective must have: content, context, scope (files + rules)
    - Prioritize objectives by dependency order
    - Typically 1-3 main objectives

27. MAIN AGENT: Present main objectives for validation
    ```
    🎯 Objetivos principales propuestos:

    OBJETIVO 1:
    ├─ Contenido: Endpoint GET /products/:id retorna producto con especificaciones
    ├─ Contexto: Frontend necesita datos completos para página de detalle de producto
    ├─ Archivos de referencia:
    │  • src/controllers/ProductController.ts
    │  • src/models/Product.ts
    │  • src/dtos/ProductDetailDTO.ts (new)
    └─ Reglas: #3, #7

    ¿Apruebas estos objetivos? (Si/No/Ajustar)
    ```

28. USER: Validates or adjusts
    - IF "No" → Ask what to change, regenerate
    - IF "Ajustar" → User provides specific changes
    - IF "Si" → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP A3: Generate Secondary Objectives with Completion Guide**
**═══════════════════════════════════════════════════════════════════**

29. MAIN AGENT: Invoke **secondary-objective-generator** subagent for each main objective

30. SUBAGENT: For each main objective:
    - Deep trace from scope.files
    - Discover related code, patterns, dependencies
    - Read referenced rules from project_rules.json
    - Generate secondary objectives with completion_guide

31. SUBAGENT returns secondary objectives:
    ```
    Objetivo secundario 1.1:
    ├─ Contenido: ProductDetailDTO incluye array de especificaciones con name, value, unit
    └─ Guía de completación:
       • Usar patrón de BaseDTO en src/dtos/BaseDTO.ts:12
       • Seguir estructura de ProductListDTO.ts para campos base
       • Aplicar regla #3: usar decoradores @Expose() para campos públicos
       • El modelo Product.ts:45 ya tiene relación con Specification

    Objetivo secundario 1.2:
    ├─ Contenido: ProductController tiene método getById que usa ProductDetailDTO
    └─ Guía de completación:
       • Seguir patrón de UserController.getById en src/controllers/UserController.ts:67
       • Aplicar regla #7: agregar @UseGuards(AuthGuard) antes del método
       • Inyectar ProductService que ya existe en src/services/ProductService.ts
    ```

32. MAIN AGENT: Present all secondary objectives
    ```
    📋 Objetivos secundarios generados:

    Para Objetivo Principal 1:
    ┌─────────────────────────────────────────────────────────────┐
    │ 1.1 ProductDetailDTO incluye especificaciones              │
    │     Guía:                                                  │
    │     • Usar patrón de BaseDTO en src/dtos/BaseDTO.ts:12     │
    │     • Seguir estructura de ProductListDTO.ts               │
    │     • Aplicar regla #3: decoradores @Expose()              │
    ├─────────────────────────────────────────────────────────────┤
    │ 1.2 ProductController.getById usa ProductDetailDTO         │
    │     Guía:                                                  │
    │     • Seguir patrón de UserController.getById:67           │
    │     • Aplicar regla #7: @UseGuards(AuthGuard)              │
    └─────────────────────────────────────────────────────────────┘

    ¿Apruebas estos objetivos secundarios? (Si/No/Ajustar)
    ```

33. USER: Validates or adjusts
    - IF adjustments needed → Regenerate affected objectives

**═══════════════════════════════════════════════════════════════════**
**STEP A4: Create Logbook File**
**═══════════════════════════════════════════════════════════════════**

34. Go to **STEP FINAL: Generate and Save Logbook**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B: GENERAL PROJECT (uses logbook_general_schema.json)**
**═══════════════════════════════════════════════════════════════════**

**Schema:** `ai_files/schemas/logbook_general_schema.json`

**Key Differences from Software:**
- `scope.files` → `scope.references` (documents, URLs, assets)
- `scope.rules` → `scope.standards` (style guides, regulations, methodologies)
- `completion_guide` references documents/practices instead of code

**═══════════════════════════════════════════════════════════════════**
**STEP B1: Gather References and Standards**
**═══════════════════════════════════════════════════════════════════**

35. MAIN AGENT:
    ```
    📚 Para crear objetivos efectivos, necesito conocer:

    ¿Qué materiales de referencia tienes disponibles?
    (Documentos, URLs, ejemplos, trabajo previo)

    Ejemplos:
    • "Capítulo 2 ya completado en Google Docs"
    • "Brief del cliente en PDF"
    • "https://competitor.com/landing para inspiración"
    ```

36. USER: Provides references

37. MAIN AGENT:
    ```
    ¿Hay estándares o guías que debas seguir?
    (Guías de estilo, normativas, metodologías)

    Ejemplos:
    • "APA 7ma edición para citas"
    • "Brand guidelines de la empresa"
    • "ISO 27001 para documentación"
    • Ninguno específico (Enter para omitir)
    ```

38. USER: Provides standards or skips

**═══════════════════════════════════════════════════════════════════**
**STEP B2: Generate Main Objectives**
**═══════════════════════════════════════════════════════════════════**

39. MAIN AGENT: Based on ticket and references, generate main objectives
    - Each objective has: content, context, scope (references + standards)
    - Focus on deliverables and milestones

40. MAIN AGENT: Present main objectives
    ```
    🎯 Objetivos principales propuestos:

    OBJETIVO 1:
    ├─ Contenido: Capítulo 3 de la tesis completado con análisis de resultados
    ├─ Contexto: Requerido para revisión del tutor antes del 15 de diciembre
    ├─ Referencias:
    │  • Capítulo 2 (estructura a seguir)
    │  • Datos de encuesta en Excel
    │  • Notas de reunión con tutor (15-nov)
    └─ Estándares: APA 7ma edición

    ¿Apruebas estos objetivos? (Si/No/Ajustar)
    ```

41. USER: Validates or adjusts

**═══════════════════════════════════════════════════════════════════**
**STEP B3: Generate Secondary Objectives**
**═══════════════════════════════════════════════════════════════════**

42. MAIN AGENT: Generate secondary objectives
    - Break down main objectives into actionable steps
    - completion_guide references documents, examples, standards

43. MAIN AGENT: Present secondary objectives
    ```
    📋 Objetivos secundarios:

    Para Objetivo Principal 1:
    ┌─────────────────────────────────────────────────────────────┐
    │ 1.1 Tablas de datos procesadas y formateadas               │
    │     Guía:                                                  │
    │     • Usar formato de tabla del Capítulo 2 como referencia │
    │     • Aplicar APA 7ma edición para títulos y notas         │
    │     • Incluir fuente de datos en pie de tabla              │
    ├─────────────────────────────────────────────────────────────┤
    │ 1.2 Análisis estadístico completado                        │
    │     Guía:                                                  │
    │     • Revisar metodología acordada en notas del 15-nov     │
    │     • Usar prueba t-student para comparación de grupos     │
    │     • Documentar p-value y nivel de significancia          │
    ├─────────────────────────────────────────────────────────────┤
    │ 1.3 Narrativa de resultados redactada                      │
    │     Guía:                                                  │
    │     • Seguir estructura de Capítulo 2 sección de hallazgos │
    │     • Conectar cada tabla con interpretación en texto      │
    │     • Incluir limitaciones mencionadas por el tutor        │
    └─────────────────────────────────────────────────────────────┘

    ¿Apruebas? (Si/No/Ajustar)
    ```

44. USER: Validates or adjusts

45. Go to **STEP FINAL: Generate and Save Logbook**

---

**═══════════════════════════════════════════════════════════════════**
**STEP FINAL: Generate and Save Logbook**
**═══════════════════════════════════════════════════════════════════**

42. MAIN AGENT: If filename not provided, ask for it:
    ```
    📁 ¿Qué nombre quieres para la bitácora?
    (Ejemplo: TICKET-123.json, feature-auth.json)
    ```

47. MAIN AGENT: Generate logbook JSON structure
    - ticket: from user input
    - objectives.main: approved main objectives (status: "not_started")
    - objectives.secondary: approved secondary objectives (status: "not_started")
    - recent_context: Initial entry documenting logbook creation
    - history_summary: empty array
    - future_reminders: empty array

48. MAIN AGENT: Validate against appropriate schema
    - IF `project_type === "software"` → Validate against `logbook_software_schema.json`
    - IF `project_type === "general"` → Validate against `logbook_general_schema.json`

49. MAIN AGENT: Save to `ai_files/logbooks/[filename].json`

50. MAIN AGENT: Create initial recent_context entry:
    ```json
    {
      "id": 1,
      "created_at": "2025-11-26T10:00:00Z",
      "content": "Logbook created. Main objectives: [count]. Secondary objectives: [count]. Ready to start implementation."
    }
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP SUCCESS: Completion Message**
**═══════════════════════════════════════════════════════════════════**

47. MAIN AGENT:
    ```
    ✅ ¡Bitácora creada exitosamente!

    📁 Archivo: ai_files/logbooks/[filename].json

    📊 Resumen:
    • Ticket: [title]
    • Objetivos principales: [count]
    • Objetivos secundarios: [count]

    🎯 Primer objetivo a trabajar:
    [First secondary objective content]

    Guía:
    [completion_guide items]

    💡 Comandos útiles:
    • /ai-behavior:logbook-update [filename] - Actualizar progreso
    • /ai-behavior:resolution-create [filename] - Generar resolución al terminar

    ¡Listo para comenzar!
    ```

---

## Subagents

| Subagent | Purpose | Tools |
|----------|---------|-------|
| **secondary-objective-generator** | Deep code analysis, generate secondary objectives with completion_guide | Read, Glob, Grep |

---

## Workflows

| Workflow | Purpose |
|----------|---------|
| `workflows/logbook/gather-ticket-info.md` | Interactive ticket information gathering |
| `workflows/logbook/trace-related-code.md` | Code tracing from manifest and description |
| `workflows/logbook/generate-main-objectives.md` | Create main objectives with scope |
| `workflows/logbook/generate-secondary-objectives.md` | Deep analysis and completion_guide |
| `workflows/logbook/validate-and-save.md` | Schema validation and file creation |

---

## Output Example

```json
{
  "ticket": {
    "title": "Implementar endpoint GET /products/:id",
    "url": "https://jira.company.com/browse/PROJ-123",
    "description": "Frontend necesita endpoint para obtener detalles completos de un producto incluyendo especificaciones técnicas para la página de detalle."
  },
  "objectives": {
    "main": [
      {
        "id": 1,
        "created_at": "2025-11-26T10:00:00Z",
        "content": "Endpoint GET /products/:id retorna producto con especificaciones técnicas",
        "context": "Frontend necesita datos completos para página de detalle. Actualmente solo existe endpoint de listado.",
        "scope": {
          "files": [
            "src/controllers/ProductController.ts",
            "src/models/Product.ts",
            "src/dtos/ProductDetailDTO.ts (new)"
          ],
          "rules": [3, 7]
        },
        "status": "not_started"
      }
    ],
    "secondary": [
      {
        "id": 1,
        "created_at": "2025-11-26T10:00:00Z",
        "content": "ProductDetailDTO incluye array de especificaciones con campos name, value, unit",
        "completion_guide": [
          "Usar patrón de BaseDTO en src/dtos/BaseDTO.ts:12",
          "Seguir estructura de ProductListDTO.ts para campos base",
          "Aplicar regla #3: usar decoradores @Expose() para campos públicos",
          "El modelo Product.ts:45 ya tiene relación con Specification"
        ],
        "status": "not_started"
      },
      {
        "id": 2,
        "created_at": "2025-11-26T10:00:00Z",
        "content": "ProductController tiene método getById que retorna ProductDetailDTO",
        "completion_guide": [
          "Seguir patrón de UserController.getById en src/controllers/UserController.ts:67",
          "Aplicar regla #7: agregar @UseGuards(AuthGuard) antes del método",
          "Inyectar ProductService existente en src/services/ProductService.ts"
        ],
        "status": "not_started"
      }
    ]
  },
  "recent_context": [
    {
      "id": 1,
      "created_at": "2025-11-26T10:00:00Z",
      "content": "Logbook created. Main objectives: 1. Secondary objectives: 2. Ready to start implementation."
    }
  ],
  "history_summary": [],
  "future_reminders": []
}
```

---

**Status:** ✅ DESIGNED
