# Command: `/waves:rules-create`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Create development rules/standards for the project based on existing code patterns (software) or user-defined standards (general projects).

**Schemas:**
- Software → `ai_files/schemas/project_rules_schema.json`
- General → `ai_files/schemas/project_standards_schema.json`

**Outputs:**
- Software → `ai_files/project_rules.json`
- General (all types) → `ai_files/project_standards.json` (open schema, adapts to academic/creative/business/other)

**Parameters:**
- Software: `[layer]` (optional) - Specific layer to analyze (architecture, presentation_layer, data_layer, api_layer, infra, testing, naming_conventions)
- General: None (conversational flow)

**Key Decision Points:**
1. **FORK 1:** Software vs General project (from `user_pref.json`)

**Flow Derivations:**
- **A:** Software → Layer-based analysis with criteria validation + antipattern detection
- **B:** General → User-guided free-form standards definition

---

## Rule Creation Criteria (From Schema `$comment`)

### **Mandatory Criteria - A rule MUST meet ALL of these:**

| # | Criterion | Description |
|---|-----------|-------------|
| 1 | **Project-wide consistency** | Promotes consistent patterns across the entire project |
| 2 | **Improves maintainability** | Enhances code clarity, structure, and long-term maintenance |
| 3 | **No contradictions** | Does not contradict or create ambiguity with existing rules |
| 4 | **Implementation patterns** | Establishes how things should be done (not tool-specific setups) |
| 5 | **Context-independent** | Can be applied without situational context or library-specific knowledge |

### **YAGNI Principle - MUST be applied:**

| Principle | Application |
|-----------|-------------|
| **No overengineering** | Rules should address current needs, not hypothetical scenarios |
| **No future features** | Avoid rules for features that may never be implemented |
| **Focus on current state** | Base rules on what exists NOW in the codebase |
| **Avoid complexity** | Simple, clear rules over complex edge-case handling |

### **Rule Sections (Software):**

| Section | Applies To | Description |
|---------|------------|-------------|
| `architecture` | All | Overall system structure and patterns |
| `presentation_layer` | Frontend/Fullstack | UI components, state management |
| `data_layer` | All | Data models, repositories, storage |
| `api_layer` | Backend/Fullstack | API endpoints, contracts, validation |
| `infra` | All | Infrastructure, deployment, configuration |
| `testing` | All | Test patterns, coverage expectations |
| `naming_conventions` | All | Naming standards for files, classes, functions |

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO PRINCIPAL - ENTRY POINT**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

1. MAIN AGENT: Check `ai_files/user_pref.json` exists
   - IF NOT → Error: "Run /waves:project-init first"

2. MAIN AGENT: Read `project_context.project_type`

3. IF `project_type === "software"`:
   - Check `ai_files/project_manifest.json` exists
   - IF NOT → Error: "Run /waves:manifest-create first"

4. Check if rules file already exists:
   - IF EXISTS → Warn and offer: Overwrite / Merge / Cancel
   - IF NOT EXISTS → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Command Explanation**
**═══════════════════════════════════════════════════════════════════**

5. MAIN AGENT (in user's language):
   ```
   📘 Comando: /waves:rules-create

   Este comando creará reglas/estándares para tu proyecto.

   [If software]:
   Analizaré el código existente para identificar patrones,
   convenciones y también detectaré posibles antipatrones.

   [If general]:
   Te guiaré para definir los estándares que necesites
   para tu proyecto.

   ¿Deseas continuar? (Si/No)
   ```

6. IF NO → Exit
7. IF SI → Route based on project_type

**═══════════════════════════════════════════════════════════════════**
**STEP 1: FORK - Software vs General**
**═══════════════════════════════════════════════════════════════════**

8. IF `project_type === "software"` → Go to **FLUJO A**
9. IF `project_type === "general"` → Go to **FLUJO B**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A: SOFTWARE - Layer-Based Analysis**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP A1: Read Project Manifest for Context**
**═══════════════════════════════════════════════════════════════════**

10. MAIN AGENT: Read `ai_files/project_manifest.json`

11. Extract key information:
    - `platform_info.primary_language` → Language for analysis
    - `platform_info.framework` → Framework-specific patterns
    - `technical_details.architecture_patterns_by_layer` → Layers to analyze
    - `technical_details.modules` → Module structure
    - `features` → Feature modules

12. MAIN AGENT (example in Spanish):
    ```
    📊 Contexto del proyecto (desde manifest):

    Lenguaje: TypeScript
    Framework: Next.js
    Tipo: fullstack

    Capas detectadas:
    • Frontend (presentation_layer)
    • API Routes (api_layer)
    • Services (data_layer)

    Módulos: 12 identificados
    Features: 7 features principales

    ¿Qué capa deseas analizar primero?

    1. architecture - Patrones generales de arquitectura
    2. presentation_layer - Componentes UI, estado
    3. data_layer - Modelos, servicios, repositorios
    4. api_layer - Endpoints, validación
    5. naming_conventions - Convenciones de nombrado
    6. testing - Patrones de testing
    7. infra - Infraestructura y configuración
    8. Todas las capas (análisis completo)

    Elige 1-8:
    ```

13. USER: Selects layer(s) to analyze

**═══════════════════════════════════════════════════════════════════**
**STEP A2: Invoke Analysis Subagents**
**═══════════════════════════════════════════════════════════════════**

14. MAIN AGENT: For each selected layer, invoke specialized subagents **in parallel**:

    **Subagent 1: pattern-extractor**
    - Analyzes code in the layer
    - Identifies consistent patterns being used
    - Extracts implementation conventions
    - Returns: List of detected patterns

    **Subagent 2: convention-detector**
    - Analyzes naming across the layer
    - Identifies file naming patterns
    - Identifies class/function naming patterns
    - Returns: Naming conventions in use

    **Subagent 3: antipattern-detector** (Educational Agent)
    - Analyzes code for known antipatterns
    - Checks against framework best practices
    - Identifies potential code smells
    - Flags technical debt
    - Returns: List of antipatterns with explanations and suggestions

15. MAIN AGENT: Show progress:
    ```
    🔍 Analizando capa: presentation_layer

    [✅] Pattern Extractor - 8 patrones identificados
    [✅] Convention Detector - 5 convenciones detectadas
    [⏳] Antipattern Detector - Analizando...
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A3: Pattern Extractor Analysis**
**═══════════════════════════════════════════════════════════════════**

16. **pattern-extractor** subagent instructions:

    ```
    OBJECTIVE: Extract implementation patterns from the {layer} layer.

    CONTEXT:
    - Read project manifest from: ai_files/project_manifest.json
    - Language: {language}
    - Framework: {framework}
    - Layer to analyze: {layer}

    ANALYSIS STEPS:
    1. Identify all files belonging to this layer
    2. For each file, analyze:
       - Class/component structure
       - Function signatures and patterns
       - Import/export patterns
       - State management patterns (if applicable)
       - Error handling patterns
       - Dependency injection patterns

    3. Find CONSISTENT patterns (used in 3+ places)
    4. Ignore one-off implementations

    CRITERIA FOR PATTERN (must meet ALL):
    ✓ Promotes project-wide consistency
    ✓ Improves code clarity and maintainability
    ✓ Is context-independent (can be applied anywhere)
    ✓ Follows YAGNI (addresses current needs, not hypothetical)

    OUTPUT FORMAT:
    For each pattern found:
    - Pattern name
    - Description (max 280 chars)
    - Files where it's applied
    - Code example
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A4: Convention Detector Analysis**
**═══════════════════════════════════════════════════════════════════**

17. **convention-detector** subagent instructions:

    ```
    OBJECTIVE: Extract naming conventions from the {layer} layer.

    CONTEXT:
    - Read project manifest from: ai_files/project_manifest.json
    - Language: {language}
    - Framework: {framework}

    ANALYSIS STEPS:
    1. File naming patterns:
       - Component files: PascalCase? kebab-case?
       - Service files: *.service.ts? *Service.ts?
       - Test files: *.test.ts? *.spec.ts?

    2. Code naming patterns:
       - Classes: PascalCase?
       - Functions: camelCase?
       - Constants: UPPER_SNAKE_CASE?
       - Private members: _prefix? #prefix?
       - Interfaces: IPrefix? No prefix?

    3. Structure conventions:
       - Barrel exports (index.ts)?
       - Co-location (tests next to source)?
       - Feature folders?

    CRITERIA: Only report conventions used consistently (80%+ of cases)

    OUTPUT FORMAT:
    For each convention:
    - Convention name
    - Pattern description
    - Examples from codebase
    - Consistency percentage
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A5: Antipattern Detector Analysis (Educational)**
**═══════════════════════════════════════════════════════════════════**

18. **antipattern-detector** subagent instructions:

    ```
    OBJECTIVE: Identify antipatterns and bad practices for EDUCATIONAL purposes.
    This is NOT to criticize but to INFORM the user of potential improvements.

    CONTEXT:
    - Read project manifest from: ai_files/project_manifest.json
    - Language: {language}
    - Framework: {framework}
    - Layer: {layer}

    ANTIPATTERNS TO CHECK:

    General:
    □ God classes/components (too many responsibilities)
    □ Long functions (>50 lines)
    □ Deep nesting (>3 levels)
    □ Magic numbers/strings
    □ Copy-paste code (DRY violations)
    □ Dead code
    □ Inconsistent error handling

    Framework-specific ({framework}):
    [Next.js]
    □ Client components without 'use client'
    □ Fetching in client when could be server
    □ Not using Next.js Image optimization
    □ Hardcoded URLs instead of env variables

    [React]
    □ Props drilling (>3 levels)
    □ Missing key props in lists
    □ State in wrong component level
    □ useEffect without cleanup

    [Flutter]
    □ BuildContext used after async gap
    □ setState in build method
    □ Not disposing controllers

    IMPORTANT:
    - Be constructive, not critical
    - Explain WHY it's an antipattern
    - Suggest the better alternative
    - Prioritize by impact (high/medium/low)

    OUTPUT FORMAT:
    For each antipattern:
    - Name
    - Location (file:line)
    - Why it's problematic
    - Suggested improvement
    - Impact level (high/medium/low)
    - Learning resource link (if applicable)
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A6: Validate Against Criteria**
**═══════════════════════════════════════════════════════════════════**

19. MAIN AGENT: For each detected pattern/convention, validate:

    ```
    VALIDATION CHECKLIST:

    □ Promotes project-wide consistency?
      → Is this pattern used across multiple files/modules?

    □ Improves maintainability?
      → Does it make code clearer and easier to maintain?

    □ No contradictions?
      → Does it conflict with any existing rule?

    □ Implementation pattern (not config)?
      → Is it about HOW to code, not tool setup?

    □ Context-independent?
      → Can it be applied without special knowledge?

    □ YAGNI compliant?
      → Based on current code, not hypothetical needs?

    IF ALL ✓ → Include as rule
    IF ANY ✗ → Exclude with reason
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A7: Present Findings**
**═══════════════════════════════════════════════════════════════════**

20. MAIN AGENT (example in Spanish):
    ```
    📋 Análisis completado para: presentation_layer

    ═══════════════════════════════════════════════════
    ✅ PATRONES IDENTIFICADOS (8 reglas propuestas)
    ═══════════════════════════════════════════════════

    1. [architecture] Componentes usan composición sobre herencia
       "All React components use composition pattern with children
       props instead of inheritance for code reuse."

    2. [presentation_layer] Custom hooks para lógica de estado
       "Reusable stateful logic is extracted into custom hooks
       with 'use' prefix (useAuth, useForm, useApi)."

    3. [naming_conventions] Componentes en PascalCase
       "Component files and exports use PascalCase
       (UserProfile.tsx exports UserProfile)."

    ... (5 more)

    ═══════════════════════════════════════════════════
    ⚠️ ANTIPATRONES DETECTADOS (Información educativa)
    ═══════════════════════════════════════════════════

    1. 🔴 [HIGH] Props Drilling en Dashboard
       Ubicación: src/components/Dashboard/Analytics.tsx:45

       Problema: Los props se pasan a través de 4 niveles
       de componentes sin ser usados en los intermedios.

       Sugerencia: Considera usar React Context o Zustand
       para este estado compartido.

       📚 Más info: https://react.dev/learn/passing-data-deeply-with-context

    2. 🟡 [MEDIUM] useEffect sin cleanup
       Ubicación: src/hooks/useWebSocket.ts:23

       Problema: El useEffect crea una conexión WebSocket
       pero no la cierra al desmontar el componente.

       Sugerencia: Agregar return () => socket.close()

    3. 🟢 [LOW] Console.log en producción
       Ubicación: Multiple files (5 instances)

       Problema: Logs de debug dejados en el código.

       Sugerencia: Usar un logger configurable o eliminar.

    ═══════════════════════════════════════════════════

    ¿Qué deseas hacer?

    1. Guardar todas las reglas propuestas
    2. Revisar y seleccionar reglas individualmente
    3. Analizar otra capa
    4. Ver más detalles de antipatrones
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A8: Generate Rules File**
**═══════════════════════════════════════════════════════════════════**

21. IF user approves rules:

22. MAIN AGENT: Generate `ai_files/project_rules.json`:
    ```json
    {
      "project_name": "From manifest",
      "project_description": "From manifest",
      "language": "typescript",
      "type": "fullstack",
      "rules": {
        "architecture": [
          {
            "id": 1,
            "created_at": "2024-11-25T10:30:00Z",
            "description": "All React components use composition pattern with children props instead of inheritance for code reuse."
          }
        ],
        "presentation_layer": [
          {
            "id": 1,
            "created_at": "2024-11-25T10:30:00Z",
            "description": "Reusable stateful logic is extracted into custom hooks with 'use' prefix (useAuth, useForm, useApi)."
          }
        ],
        "naming_conventions": [
          {
            "id": 1,
            "created_at": "2024-11-25T10:30:00Z",
            "description": "Component files and exports use PascalCase (UserProfile.tsx exports UserProfile)."
          }
        ]
      }
    }
    ```

23. MAIN AGENT: Validate against schema

**═══════════════════════════════════════════════════════════════════**
**STEP A9: Success Message**
**═══════════════════════════════════════════════════════════════════**

24. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Reglas del proyecto creadas!

    📁 Archivo: ai_files/project_rules.json
    📊 Reglas generadas: 8

    Por sección:
    • architecture: 2 reglas
    • presentation_layer: 3 reglas
    • naming_conventions: 2 reglas
    • testing: 1 regla

    ⚠️ Antipatrones identificados: 3
    (Revisa el reporte para mejorar la calidad del código)

    🎯 Próximos pasos:

    Para analizar más capas:
    /waves:rules-create [layer]

    Para actualizar reglas existentes:
    /waves:rules-update

    Para empezar a trabajar:
    /waves:logbook-create
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B: GENERAL PROJECTS - User-Guided Standards**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP B1: Determine Project Subtype**
**═══════════════════════════════════════════════════════════════════**

25. MAIN AGENT: Read general project subtype from manifest
    - If `research_manifest.json` exists → Academic
    - If `creative_manifest.json` exists → Creative
    - If `business_manifest.json` exists → Business
    - Otherwise → General

**═══════════════════════════════════════════════════════════════════**
**STEP B2: Show Suggestions (Inspirational, Not Mandatory)**
**═══════════════════════════════════════════════════════════════════**

26. MAIN AGENT: Based on subtype, show relevant suggestions:

    **For Academic:**
    ```
    💡 Sugerencias para proyectos académicos:

    Algunos estándares comunes que podrías definir:
    • Formato de citación (APA, MLA, Chicago, IEEE)
    • Estructura de documentos y capítulos
    • Estilo de redacción (formal, persona gramatical)
    • Formato de tablas, figuras y gráficos
    • Nomenclatura de archivos
    • Convenciones de bibliografía
    • Formato de referencias cruzadas

    Estas son solo ideas. Tú decides qué es relevante para tu proyecto.
    ```

    **For Creative:**
    ```
    💡 Sugerencias para proyectos creativos:

    Algunos estándares comunes que podrías definir:
    • Especificaciones de archivos (formatos, resoluciones)
    • Paleta de colores (códigos hex, RGB)
    • Tipografías y jerarquías
    • Guías de estilo visual
    • Nomenclatura de assets
    • Flujo de revisión y aprobación
    • Formatos de entrega

    Estas son solo ideas. Tú decides qué es relevante para tu proyecto.
    ```

    **For Business:**
    ```
    💡 Sugerencias para proyectos de negocio:

    Algunos estándares comunes que podrías definir:
    • Procesos operativos clave
    • Políticas de comunicación
    • Métricas y KPIs a seguir
    • Flujos de aprobación
    • Templates de documentos
    • Estándares de reportes
    • Convenciones de nomenclatura

    Estas son solo ideas. Tú decides qué es relevante para tu proyecto.
    ```

    **For General:**
    ```
    💡 Sugerencias generales:

    Algunos estándares que podrías definir:
    • Organización de archivos y carpetas
    • Convenciones de nombrado
    • Flujos de trabajo
    • Estándares de documentación
    • Procesos de revisión

    Estas son solo ideas. Define lo que necesites.
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP B3: Open Question - User Defines Standards**
**═══════════════════════════════════════════════════════════════════**

27. MAIN AGENT (example in Spanish):
    ```
    📝 ¿Qué estándares o reglas quieres definir para tu proyecto?

    Describe libremente lo que necesitas. Puedo ayudarte a
    estructurarlo después.

    Ejemplo de respuesta:
    "Quiero usar APA 7ma edición para citas, los capítulos deben
    empezar con un resumen de 150 palabras, todas las tablas van
    numeradas con título arriba, y los archivos se nombran con
    formato capitulo-XX-seccion.docx"

    Tu turno:
    ```

28. USER: Provides free-form description of desired standards

**═══════════════════════════════════════════════════════════════════**
**STEP B4: Agent Structures User Input**
**═══════════════════════════════════════════════════════════════════**

29. MAIN AGENT: Parse user input and structure into categories

30. MAIN AGENT: If clarification needed:
    ```
    📋 Entendí lo siguiente:

    Citación:
    • Formato APA 7ma edición

    Estructura de capítulos:
    • Resumen de 150 palabras al inicio

    Tablas:
    • Numeración secuencial
    • Título arriba de la tabla

    Nomenclatura de archivos:
    • Formato: capitulo-XX-seccion.docx

    ¿Hay algo que quieras agregar o modificar?
    ```

31. USER: Confirms or provides additional input

32. IF more input → Return to STEP B4
    IF confirmed → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP B5: Generate Standards File**
**═══════════════════════════════════════════════════════════════════**

33. MAIN AGENT: Generate appropriate standards file:

    **For Academic → `academic_standards.json`:**
    ```json
    {
      "project_name": "Tesis de Maestría",
      "type": "academic",
      "standards": {
        "citation": {
          "format": "APA",
          "version": "7th edition",
          "notes": "User-defined specifics..."
        },
        "document_structure": {
          "chapter_format": "Each chapter starts with 150-word summary",
          "sections": ["Introduction", "Literature Review", "..."]
        },
        "tables_and_figures": {
          "table_numbering": "Sequential (Table 1, Table 2...)",
          "table_title_position": "Above table",
          "figure_title_position": "Below figure"
        },
        "file_naming": {
          "pattern": "capitulo-XX-seccion.docx",
          "examples": ["capitulo-01-introduccion.docx"]
        }
      },
      "created_at": "2024-11-25T10:30:00Z",
      "last_updated": "2024-11-25T10:30:00Z"
    }
    ```

34. MAIN AGENT: Show generated file for confirmation

**═══════════════════════════════════════════════════════════════════**
**STEP B6: Success Message**
**═══════════════════════════════════════════════════════════════════**

35. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Estándares del proyecto creados!

    📁 Archivo: ai_files/academic_standards.json
    📊 Categorías definidas: 4

    • Citación: APA 7ma edición
    • Estructura de documentos: Con resumen inicial
    • Tablas y figuras: Numeración secuencial
    • Nomenclatura: capitulo-XX-seccion.docx

    🎯 Próximo paso:

    Cuando quieras actualizar los estándares:
    /waves:rules-update

    Para empezar a trabajar:
    /waves:logbook-create
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Software Flow Subagents:**

1. **pattern-extractor**
   - Tools: Read, Glob, Grep
   - Responsibilities: Analyze code to find consistent implementation patterns
   - Input: Layer to analyze, manifest context
   - Output: List of patterns with descriptions and examples

2. **convention-detector**
   - Tools: Read, Glob, Grep
   - Responsibilities: Identify naming and structural conventions
   - Input: Layer to analyze, manifest context
   - Output: List of conventions with consistency percentages

3. **antipattern-detector** (Educational)
   - Tools: Read, Glob, Grep
   - Responsibilities: Find antipatterns and bad practices
   - Input: Layer to analyze, framework, language
   - Output: List of antipatterns with explanations, suggestions, and learning resources
   - Note: Constructive, educational tone - not critical

4. **criteria-validator**
   - Tools: Read
   - Responsibilities: Validate detected patterns against rule criteria
   - Input: List of patterns, existing rules
   - Output: Validated rules that meet all criteria

### **General Flow Subagents:**

5. **standards-structurer**
   - Tools: Read, Write
   - Responsibilities: Parse free-form user input into structured standards
   - Input: User description, project subtype
   - Output: Structured standards JSON

---

**═══════════════════════════════════════════════════════════════════**
**WORKFLOWS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

1. `workflows/rules/check-prerequisites.md`
   - Verify manifest exists for software projects

2. `workflows/rules/layer-analysis.md`
   - Instructions for analyzing specific layers
   - Pattern extraction methodology

3. `workflows/rules/convention-detection.md`
   - Naming convention detection methodology
   - Consistency threshold (80%+)

4. `workflows/rules/antipattern-detection.md`
   - Framework-specific antipattern checklists
   - Educational output format

5. `workflows/rules/criteria-validation.md`
   - Full criteria checklist
   - YAGNI validation

6. `workflows/rules/general-standards.md`
   - Suggestions by project subtype
   - Free-form to structured conversion

---

**═══════════════════════════════════════════════════════════════════**
**CRITERIA VALIDATION PROMPT (For Subagents)**
**═══════════════════════════════════════════════════════════════════**

```
Before creating a rule, validate against ALL criteria:

MANDATORY (must meet ALL):
□ Promotes project-wide consistency
  → Ask: Is this pattern used in 3+ places across the project?

□ Improves code clarity, structure, and long-term maintainability
  → Ask: Does following this rule make code easier to understand?

□ Does not contradict or create ambiguity with other rules
  → Ask: Is there any existing rule that conflicts with this?

□ Establishes consistent implementation patterns (not tool config)
  → Ask: Is this about HOW to write code, not how to configure tools?

□ Can be applied without situational context
  → Ask: Can any developer apply this without special knowledge?

YAGNI PRINCIPLE:
□ Addresses current project needs (not hypothetical)
  → Ask: Is this based on existing code, not future features?

□ Avoids overengineering
  → Ask: Is this the simplest rule that achieves the goal?

IF ANY CHECK FAILS → Do not create the rule
IF ALL CHECKS PASS → Create the rule with max 280 character description
```

---

**═══════════════════════════════════════════════════════════════════**
**TODO: SCHEMAS PENDIENTES**
**═══════════════════════════════════════════════════════════════════**

1. **`project_standards_schema.json`** - For general project standards
   - Flexible structure for different project types
   - Categories: citation, structure, naming, processes, custom

---

**Status:** ✅ DESIGNED (2 flows complete - Software layer-based, General user-guided)
