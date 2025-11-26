# Command: `/ai-behavior:manifest-create`

**Status:** ✅ DESIGNED (All 7 flows complete)

---

## Overview

**Purpose:** Analyze project and create manifest file based on project type (software or general)

**Schemas:**
- Software → `ai_files/schemas/project_manifest_schema.json`
- Academic → `ai_files/schemas/research_manifest_schema.json`
- Creative → `ai_files/schemas/creative_manifest_schema.json`
- Business → `ai_files/schemas/business_manifest_schema.json`
- General → `ai_files/schemas/general_manifest_schema.json`

**Outputs (depending on project type):**
- Software → `ai_files/project_manifest.json` + `ai_files/architecture_map.json` (if existing project)
- Academic → `ai_files/research_manifest.json`
- Creative → `ai_files/creative_manifest.json`
- Business → `ai_files/business_manifest.json`
- General → `ai_files/general_manifest.json`

**Parameters:** None (always interactive, uses context from `user_pref.json`)

**Key Decision Points:**
1. **FORK 1:** Software vs General (from `user_pref.json` → `project_context.project_type`)
2. **FORK 2:** (Software only) New vs Existing project
3. **FORK 3:** (Software Existing only) Known vs Unknown (from `user_pref.json` → `project_context.is_project_known_by_user`)
4. **FORK 4:** (General only) Academic, Creative, Business, or Other
5. **FORK 5:** (General only) New vs Existing project

**Flow Derivations (8 total):**

**Software Projects:**
- **A1:** Software Nuevo → 5 questions → Generate template manifest
- **A2.1:** Software Existente Conocido → 3 checkpoint questions → 6 subagents → Generate manifest + architecture map
- **A2.2:** Software Existente Desconocido → 0 questions → 6 subagents (with progress prints) → Generate manifest + architecture map

**General Projects (New):**
- **B1:** Académico Nuevo → 5 questions → Generate research manifest
- **B2:** Creativo Nuevo → 5 questions → Generate creative manifest
- **B3:** Negocio Nuevo → 9 questions (Business Canvas) → Generate business manifest
- **B4:** Otro Nuevo → 5 generic questions → Generate general manifest

**General Projects (Existing):**
- **BE:** General Existente → Directory discovery → Parallel subagents → Executive summary → Generate manifest

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO PRINCIPAL - ENTRY POINT (Common to all flows)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check (CRITICAL - BEFORE ANYTHING)**
**═══════════════════════════════════════════════════════════════════**

0. MAIN AGENT: Check if `ai_files/user_pref.json` exists

1. IF NOT EXISTS → MAIN AGENT (in English as fallback):
   ```
   ⚠️ Missing configuration!

   The file ai_files/user_pref.json was not found.

   Please run first:
   /ai-behavior:project-init

   This command will configure your preferences and project context,
   which are required before creating the manifest.
   ```
   → **EXIT COMMAND**

2. IF EXISTS → Read and validate structure
   - Check `project_context.project_type` exists
   - Check `project_context.is_project_known_by_user` exists
   - Check `user_profile.preferred_language` exists

3. IF any required field is missing → MAIN AGENT:
   ```
   ⚠️ Incomplete configuration!

   Your ai_files/user_pref.json is missing required fields.

   Please run:
   /ai-behavior:project-init

   to complete the configuration.
   ```
   → **EXIT COMMAND**

4. IF all valid → Continue to STEP 0

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Command Explanation (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

5. MAIN AGENT: Read `ai_files/user_pref.json`
   - Get `preferred_language` → Use for all interactions
   - Get `project_context.project_type` → Determines FORK 1
   - Get `project_context.is_project_known_by_user` → Determines FORK 3 (if software)

2. MAIN AGENT (in user's language, example in Spanish):
   ```
   📘 Comando: /ai-behavior:manifest-create

   Este comando analizará tu proyecto y creará un manifiesto completo con:
   - Información del proyecto y contexto
   - Tecnologías, frameworks y dependencias (si es software)
   - Estructura y arquitectura (si es software)
   - Features, objetivos o entregables

   ¿Deseas continuar? (Si/No)
   ```

3. IF NO → Exit with message: "Comando cancelado. No se creó ningún archivo."

4. IF SI → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Check Existing Manifest (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

5. MAIN AGENT: Check if manifest file already exists
   - For software: Check `ai_files/project_manifest.json`
   - For general: Check based on project_type (research_manifest.json, creative_manifest.json, etc.)

6. IF EXISTS → MAIN AGENT (example in Spanish):
   ```
   ⚠️ Ya existe un manifiesto en este proyecto!

   Archivo encontrado: ai_files/project_manifest.json

   Opciones:
   1. Detener (usar /ai-behavior:manifest-update en su lugar)
   2. Continuar (sobrescribe el archivo existente)

   Elige 1 o 2:
   ```
   - IF "1" → Exit with message: "No se efectuaron cambios. Usa /ai-behavior:manifest-update para actualizar el manifiesto existente."
   - IF "2" → Continue (show warning: "⚠️ El archivo será sobrescrito al finalizar")

7. IF NOT EXISTS → Continue silently

**═══════════════════════════════════════════════════════════════════**
**STEP 2: FORK 1 - Software vs General Project**
**═══════════════════════════════════════════════════════════════════**

8. MAIN AGENT: Read `project_type` from `user_pref.json`

9. IF `project_type === "software"` → Go to **STEP 3A (FORK 2)**

10. IF `project_type === "general"` → Go to **STEP 3B (FORK 4)**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A: SOFTWARE PROJECTS**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 3A: FORK 2 - New vs Existing Project (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

11. MAIN AGENT (example in Spanish):
    ```
    🎯 ¿Es este un proyecto nuevo o existente?

    1. Proyecto nuevo - Voy a empezar a desarrollar desde cero
    2. Proyecto existente - Ya tiene código y estructura

    Elige 1 o 2:
    ```

12. USER: "1" or "2"

13. MAIN AGENT: Store selection
    - IF "1" → Go to **FLUJO A1: Software Nuevo**
    - IF "2" → Go to **STEP 4A2: FORK 3**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A1: SOFTWARE NUEVO**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 4A1: Invoke Subagent for New Project Setup**
**═══════════════════════════════════════════════════════════════════**

14. MAIN AGENT: Invoke **manifest-creator-new-software** subagent

**═══════════════════════════════════════════════════════════════════**
**STEP 5A1: Question 1 - Application Type (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

15. SUBAGENT (example in Spanish):
    ```
    📱 ¿Qué tipo de aplicación vas a desarrollar?

    1. Web - Aplicación web, SPA, sitio
    2. Mobile - iOS, Android, multiplataforma
    3. Backend - API, microservicio, servidor
    4. Full-stack - Frontend + Backend integrados
    5. Desktop - Aplicación de escritorio
    6. CLI - Herramienta de línea de comandos
    7. Otro - Especifica

    Elige 1-7:
    ```

16. USER: "1"

17. SUBAGENT: Store `application_type`

**═══════════════════════════════════════════════════════════════════**
**STEP 6A1: Question 2 - Primary Language (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

18. SUBAGENT (example in Spanish):
    ```
    💻 ¿Qué lenguaje principal usarás?

    1. TypeScript / JavaScript
    2. Python
    3. Java / Kotlin
    4. C# / .NET
    5. Go
    6. Rust
    7. PHP
    8. Ruby
    9. Swift
    10. Dart
    11. Otro - Especifica

    Elige 1-11:
    ```

19. USER: "1"

20. SUBAGENT: Store `primary_language = "TypeScript"`

**═══════════════════════════════════════════════════════════════════**
**STEP 7A1: Question 3 - Framework (Dynamic based on language)**
**═══════════════════════════════════════════════════════════════════**

21. SUBAGENT: Generate framework options dynamically based on language and app type

    **Example for TypeScript + Web:**
    ```
    ⚙️ ¿Qué framework usarás?

    1. React
    2. Next.js
    3. Vue.js
    4. Nuxt.js
    5. Angular
    6. Svelte / SvelteKit
    7. Vanilla (sin framework)
    8. Otro - Especifica

    Elige 1-8:
    ```

22. USER: "2"

23. SUBAGENT: Store `framework = "Next.js"`

**═══════════════════════════════════════════════════════════════════**
**STEP 8A1: Question 4 - Project Description (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

24. SUBAGENT (example in Spanish):
    ```
    📝 Describe tu proyecto en 1-2 oraciones:

    Ejemplo: "Una plataforma de e-learning para cursos de programación con
    videos interactivos y ejercicios prácticos."
    ```

25. USER: Provides description

26. SUBAGENT: Store `description`

**═══════════════════════════════════════════════════════════════════**
**STEP 9A1: Question 5 - Main Features (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

27. SUBAGENT (example in Spanish):
    ```
    ✨ Lista 3-5 features principales que planeas implementar:

    Escribe una feature por línea, ejemplos:
    - Autenticación de usuarios con OAuth
    - Dashboard con métricas en tiempo real
    - Sistema de notificaciones push
    - Carrito de compras con checkout

    Escribe tus features:
    ```

28. USER: Provides features (multiline)

29. SUBAGENT: Parse features into array

**═══════════════════════════════════════════════════════════════════**
**STEP 10A1: Generate Project Manifest Template**
**═══════════════════════════════════════════════════════════════════**

30. SUBAGENT (example in Spanish):
    ```
    ⚙️ Generando manifiesto del proyecto...
    ```

31. SUBAGENT: Generate `ai_files/project_manifest.json` with:
    ```json
    {
      "project": {
        "name": "Detected from package.json or directory name",
        "description": "User's description",
        "start_date": "Today's date",
        "last_updated": "Today's date"
      },
      "platform_info": {
        "primary_language": "TypeScript",
        "framework": "Next.js",
        "version": "To be added when project initializes",
        "build_tool": "Suggested based on stack (e.g., npm, pnpm, yarn)",
        "package_manager": "Suggested based on stack"
      },
      "technical_details": {
        "modules": "To be populated as development progresses",
        "architecture_patterns_by_layer": "Suggested patterns for Next.js (e.g., App Router, API Routes, React Server Components)"
      },
      "features": [
        "List of user-provided features"
      ],
      "llm_notes": {
        "is_up_to_date": true,
        "recommended_actions": [
          "Initialize Next.js project with `npx create-next-app@latest`",
          "Set up TypeScript configuration",
          "Configure recommended architecture patterns",
          "Run /ai-behavior:rules-create to establish coding conventions"
        ]
      }
    }
    ```

32. SUBAGENT: Validate against schema

**═══════════════════════════════════════════════════════════════════**
**STEP 11A1: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

33. SUBAGENT returns to MAIN AGENT

34. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Manifiesto del proyecto creado!

    📁 Archivo generado:
      • ai_files/project_manifest.json

    📋 Resumen de tu proyecto:
      • Tipo: Web
      • Lenguaje: TypeScript
      • Framework: Next.js
      • Features: 5 features principales definidas

    💡 Valores por defecto aplicados:
      • Build tool sugerido: npm/pnpm
      • Patrones de arquitectura recomendados para Next.js
      • Acciones recomendadas incluidas

    🎯 Próximo paso:

      Inicializa tu proyecto Next.js:
      npx create-next-app@latest

      Luego ejecuta:
      /ai-behavior:rules-create

      Este comando establecerá las convenciones de código y
      estructura para cada capa de tu arquitectura.
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**STEP 4A2: FORK 3 - Known vs Unknown Existing Project**
**═══════════════════════════════════════════════════════════════════**

35. MAIN AGENT: Read `is_project_known_by_user` from `user_pref.json`

36. IF `is_project_known_by_user === true` → Go to **FLUJO A2.1: Software Existente Conocido**

37. IF `is_project_known_by_user === false` → Go to **FLUJO A2.2: Software Existente Desconocido**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A2.1: SOFTWARE EXISTENTE CONOCIDO**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 5A2.1: Invoke Subagent for Known Existing Project**
**═══════════════════════════════════════════════════════════════════**

38. MAIN AGENT: Invoke **manifest-creator-known-software** subagent

**═══════════════════════════════════════════════════════════════════**
**STEP 6A2.1: Auto-detect Technologies (Silent)**
**═══════════════════════════════════════════════════════════════════**

39. SUBAGENT: Scan project files to detect:
    - package.json, requirements.txt, build.gradle, etc.
    - Extract: language, framework, version, dependencies

40. SUBAGENT: Store detected values

**═══════════════════════════════════════════════════════════════════**
**STEP 7A2.1: Checkpoint Question 1 - Confirm Technologies**
**═══════════════════════════════════════════════════════════════════**

41. SUBAGENT (example in Spanish):
    ```
    🔍 Detecté las siguientes tecnologías:

    • Lenguaje: TypeScript
    • Framework: Next.js 14.2.0
    • Build tool: npm
    • Node version: 18.x

    ✅ ¿Es correcto? ¿Deseas agregar o corregir algo?

    Opciones:
    1. Correcto, continuar
    2. Corregir/Agregar información

    Elige 1 o 2:
    ```

42. USER: "1" or "2"

43. IF "2" → SUBAGENT asks: "¿Qué deseas corregir o agregar?" → User provides corrections → Update detected values

**═══════════════════════════════════════════════════════════════════**
**STEP 8A2.1: Checkpoint Question 2 - Architecture Type**
**═══════════════════════════════════════════════════════════════════**

44. SUBAGENT (example in Spanish):
    ```
    🏗️ ¿Qué tipo de arquitectura usa tu proyecto?

    1. Component-based (React/Vue components)
    2. Clean Architecture (layers: domain, application, infrastructure)
    3. MVC (Model-View-Controller)
    4. Microservices
    5. Modular Monolith
    6. Serverless
    7. Otro - Especifica

    Elige 1-7:
    ```

45. USER: "1"

46. SUBAGENT: Store `architecture_type = "Component-based"`

**═══════════════════════════════════════════════════════════════════**
**STEP 9A2.1: Checkpoint Question 3 - Confirm/Add Features**
**═══════════════════════════════════════════════════════════════════**

47. SUBAGENT (example in Spanish):
    ```
    ✨ Como conoces el proyecto, lista las features principales que tiene:

    Escribe una feature por línea, ejemplos:
    - Autenticación con NextAuth
    - Dashboard de analytics
    - API REST con validación
    - Sistema de comentarios

    Escribe las features:
    ```

48. USER: Provides features (multiline)

49. SUBAGENT: Parse features into array

**═══════════════════════════════════════════════════════════════════**
**STEP 10A2.1: Multi-Subagent Discovery (6 Parallel Subagents)**
**═══════════════════════════════════════════════════════════════════**

50. SUBAGENT (example in Spanish):
    ```
    🔍 Analizando el proyecto en profundidad con 6 agentes especializados...

    Esto tomará un momento. Los agentes analizarán:
    1. Puntos de entrada y flujos principales
    2. Navegación y rutas (frontend)
    3. Endpoints y eventos (backend)
    4. Dependencias y librerías
    5. Arquitectura y patrones
    6. Features implementadas

    Iniciando análisis...
    ```

51. SUBAGENT: Invoke 6 specialized subagents **in parallel**:

    **Subagent 1: entry-point-analyzer**
    - Find main entry points (index.ts, main.ts, app.tsx, etc.)
    - Trace application startup flow
    - Identify initialization logic
    - Return: List of entry points with descriptions

    **Subagent 2: navigation-mapper** (Frontend focused)
    - Find routing configuration (React Router, Next.js App Router, etc.)
    - Map all routes and pages
    - Identify navigation patterns
    - Return: Route map with components

    **Subagent 3: flow-tracker** (Backend/API focused)
    - Find API endpoints (controllers, route handlers)
    - Map event handlers
    - Trace data flow through layers
    - Return: API endpoint map with methods

    **Subagent 4: dependency-auditor**
    - Analyze package.json, requirements.txt, etc.
    - Categorize dependencies (UI, state, API, testing, etc.)
    - Identify version constraints
    - Return: Dependency tree with categories

    **Subagent 5: architecture-detective**
    - Analyze directory structure
    - Identify architectural layers
    - Detect patterns (HOCs, hooks, services, repositories, etc.)
    - Identify separation of concerns
    - Return: Architecture map with layers and patterns

    **Subagent 6: feature-extractor**
    - Cross-reference routes, components, APIs
    - Identify cohesive feature modules
    - Extract user-facing features
    - Return: Feature list with implementation details

52. SUBAGENT: Wait for all 6 subagents to complete

**═══════════════════════════════════════════════════════════════════**
**STEP 11A2.1: Cross-Analysis and Consolidation**
**═══════════════════════════════════════════════════════════════════**

53. SUBAGENT (example in Spanish):
    ```
    ✅ Análisis completado. Consolidando hallazgos...
    ```

54. SUBAGENT: Combine findings from all 6 subagents:
    - Validate consistency between subagent reports
    - Cross-reference features from user input vs feature-extractor
    - Reconcile architecture findings
    - Identify any conflicts or gaps

55. SUBAGENT: Generate `ai_files/project_manifest.json`:
    ```json
    {
      "project": {
        "name": "From package.json or directory",
        "description": "Generated from README or user input",
        "start_date": "From git history or 'Unknown'",
        "last_updated": "Today's date"
      },
      "platform_info": {
        "primary_language": "From checkpoint Q1",
        "framework": "From checkpoint Q1",
        "version": "From checkpoint Q1",
        "build_tool": "From dependency-auditor",
        "package_manager": "From dependency-auditor"
      },
      "technical_details": {
        "modules": "From architecture-detective",
        "architecture_patterns_by_layer": {
          "Frontend": "From architecture-detective + navigation-mapper",
          "Backend": "From architecture-detective + flow-tracker",
          "Data": "From architecture-detective"
        },
        "entry_points": "From entry-point-analyzer",
        "routing": "From navigation-mapper",
        "api_endpoints": "From flow-tracker"
      },
      "features": "Combined from user input + feature-extractor",
      "dependencies": "From dependency-auditor",
      "llm_notes": {
        "is_up_to_date": true,
        "recommended_actions": "Generated based on findings"
      }
    }
    ```

56. SUBAGENT: Generate `ai_files/architecture_map.json` (NEW ARTIFACT):
    ```json
    {
      "layers": {
        "Frontend": {
          "patterns": ["From architecture-detective"],
          "routes": ["From navigation-mapper"],
          "components": ["Key components identified"]
        },
        "Backend": {
          "patterns": ["From architecture-detective"],
          "endpoints": ["From flow-tracker"],
          "services": ["Key services identified"]
        }
      },
      "dependencies": {
        "categorized": "From dependency-auditor"
      },
      "cross_references": {
        "features_to_components": "Mapping from feature-extractor",
        "components_to_apis": "Mapping from cross-analysis"
      }
    }
    ```

57. SUBAGENT: Validate both files against schemas

**═══════════════════════════════════════════════════════════════════**
**STEP 12A2.1: Success Message with Findings Summary**
**═══════════════════════════════════════════════════════════════════**

58. SUBAGENT returns to MAIN AGENT

59. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Análisis completo y manifiesto creado!

    📁 Archivos generados:
      • ai_files/project_manifest.json
      • ai_files/architecture_map.json (mapa detallado de arquitectura)

    🔍 Hallazgos principales:

    Tecnologías:
      • TypeScript + Next.js 14.2.0
      • 24 dependencias categorizadas

    Arquitectura:
      • Component-based con App Router
      • 3 capas identificadas: Frontend, API Routes, Data
      • 12 rutas mapeadas
      • 8 endpoints API documentados

    Features:
      • 7 features principales identificadas y mapeadas

    Patrones detectados:
      • React Server Components
      • API Route Handlers
      • Server Actions
      • Custom Hooks (15 hooks encontrados)

    📋 Acciones recomendadas:
      • Actualizar 3 dependencias desactualizadas
      • Documentar 2 endpoints sin documentación
      • Considerar implementar caché en 4 endpoints

    🎯 Próximo paso:

      Establece las reglas de código por capa:
      /ai-behavior:rules-create [layer]

      Capas disponibles: Frontend, Backend, Data

      Ejemplo:
      /ai-behavior:rules-create Frontend
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A2.2: SOFTWARE EXISTENTE DESCONOCIDO**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 5A2.2: Invoke Subagent for Unknown Existing Project**
**═══════════════════════════════════════════════════════════════════**

60. MAIN AGENT: Invoke **manifest-creator-unknown-software** subagent

61. MAIN AGENT (example in Spanish):
    ```
    🔍 Como este proyecto es nuevo para ti, voy a analizarlo en profundidad
    sin hacerte preguntas. Te mostraré el progreso a medida que lo analizo.

    Esto tomará unos minutos...
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 6A2.2: Exhaustive Analysis with Progress Prints (0 Questions)**
**═══════════════════════════════════════════════════════════════════**

62. SUBAGENT: Start analysis with progress updates

    **Progress Print 1:**
    ```
    📂 Analizando estructura del proyecto...
    ```

63. SUBAGENT: Analyze directory structure
    - Count files by extension
    - Identify framework-specific patterns
    - Detect configuration files

    **Progress Print 2:**
    ```
    ✅ Estructura analizada: 247 archivos TypeScript, Next.js detectado

    💻 Detectando tecnologías y dependencias...
    ```

64. SUBAGENT: Scan package files
    - Detect language, framework, versions
    - Extract dependencies
    - Identify build tools

    **Progress Print 3:**
    ```
    ✅ Tecnologías detectadas: TypeScript 5.x, Next.js 14.2.0, 24 dependencias

    🏗️ Identificando arquitectura y patrones...
    ```

65. SUBAGENT: Analyze architecture
    - Detect layers and separation
    - Identify patterns
    - Map directory structure to architecture

    **Progress Print 4:**
    ```
    ✅ Arquitectura identificada: Component-based con App Router, 3 capas

    ✨ Extrayendo features y funcionalidades...
    ```

66. SUBAGENT: Extract features
    - Map routes to features
    - Identify API endpoints
    - Cross-reference components

    **Progress Print 5:**
    ```
    ✅ Features extraídas: 7 features principales identificadas

    🔗 Evaluando dependencias y versiones...
    ```

67. SUBAGENT: Audit dependencies
    - Check for outdated versions
    - Identify security issues
    - Categorize dependencies

    **Progress Print 6:**
    ```
    ✅ Dependencias evaluadas: 3 actualizaciones disponibles

    🚀 Iniciando análisis profundo con 6 agentes especializados...
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 7A2.2: Multi-Subagent Discovery (Same as A2.1, with prints)**
**═══════════════════════════════════════════════════════════════════**

68. SUBAGENT: Invoke same 6 specialized subagents as A2.1 **in parallel**

    **Progress Print 7:**
    ```
    🔍 Agentes trabajando en paralelo:
      [⏳] Entry Point Analyzer - Trazando puntos de entrada...
      [⏳] Navigation Mapper - Mapeando rutas y navegación...
      [⏳] Flow Tracker - Rastreando flujos de datos...
      [⏳] Dependency Auditor - Auditando dependencias...
      [⏳] Architecture Detective - Investigando arquitectura...
      [⏳] Feature Extractor - Extrayendo features...
    ```

69. SUBAGENT: As each subagent completes, update progress:

    **Progress Print 8 (example):**
    ```
    🔍 Agentes trabajando en paralelo:
      [✅] Entry Point Analyzer - 4 entry points encontrados
      [✅] Navigation Mapper - 12 rutas mapeadas
      [⏳] Flow Tracker - Rastreando flujos de datos...
      [✅] Dependency Auditor - 24 dependencias categorizadas
      [⏳] Architecture Detective - Investigando arquitectura...
      [✅] Feature Extractor - 7 features identificadas
    ```

70. SUBAGENT: Wait for all 6 subagents to complete

    **Progress Print 9:**
    ```
    ✅ Todos los agentes completaron el análisis

    🔄 Consolidando hallazgos y validando consistencia...
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 8A2.2: Cross-Analysis and Generate Manifests**
**═══════════════════════════════════════════════════════════════════**

71. SUBAGENT: Perform same cross-analysis as A2.1 (Step 54-57)
    - Validate consistency
    - Reconcile findings
    - Generate `project_manifest.json`
    - Generate `architecture_map.json`
    - Validate against schemas

    **Progress Print 10:**
    ```
    ✅ Manifiestos generados y validados
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 9A2.2: Educational Success Message (Teach the User)**
**═══════════════════════════════════════════════════════════════════**

72. SUBAGENT returns to MAIN AGENT

73. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Análisis exhaustivo completado!

    🎓 Ahora conoces mejor tu proyecto! Aquí está lo que descubrí:

    📁 Archivos generados:
      • ai_files/project_manifest.json
      • ai_files/architecture_map.json

    📊 Resumen del proyecto:

    🏗️ Arquitectura:
      • Tipo: Component-based con Next.js App Router
      • Capas: Frontend (components, pages), Backend (API routes), Data (services)
      • Patrones principales:
        - React Server Components (15 componentes)
        - API Route Handlers (8 endpoints)
        - Custom Hooks (12 hooks reutilizables)
        - Server Actions (4 acciones)

    💻 Stack tecnológico:
      • Lenguaje: TypeScript 5.3.2
      • Framework: Next.js 14.2.0 (App Router)
      • Build: npm
      • Node: 18.x

    🔗 Dependencias (24 total):
      • UI: React 18, Tailwind CSS
      • Estado: Zustand
      • API: Axios
      • Validación: Zod
      • Testing: Jest, React Testing Library

    📍 Navegación (12 rutas):
      • / (home)
      • /dashboard
      • /projects
      • /projects/[id]
      • /settings
      • ... y 7 más

    🔌 API Endpoints (8):
      • GET /api/projects
      • POST /api/projects
      • GET /api/projects/[id]
      • PUT /api/projects/[id]
      • DELETE /api/projects/[id]
      • ... y 3 más

    ✨ Features principales (7):
      1. Autenticación con NextAuth (Google + GitHub)
      2. Dashboard con métricas en tiempo real
      3. CRUD de proyectos con TypeScript types
      4. Sistema de comentarios y colaboración
      5. Notificaciones push con WebSockets
      6. Exportación de datos a PDF/Excel
      7. Sistema de roles y permisos

    📋 Recomendaciones:
      • ⚠️ 3 dependencias desactualizadas (actualizar pronto)
      • 💡 Considera agregar tests para 4 endpoints sin cobertura
      • 🔒 2 endpoints podrían beneficiarse de rate limiting
      • 📚 Documentar arquitectura en README.md

    🎯 Próximo paso:

      Ahora que conoces la estructura, establece las convenciones de código:
      /ai-behavior:rules-create Frontend

      Esto extraerá los patrones y convenciones que ya estás usando
      en el código y los documentará para mantener consistencia.

      Capas disponibles para analizar:
      • Frontend - Componentes, hooks, páginas
      • Backend - API routes, servicios, validaciones
      • Data - Modelos, schemas, tipos
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B: GENERAL PROJECTS (Non-Software)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 3B: FORK 4 - Type of General Project (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

74. MAIN AGENT (example in Spanish):
    ```
    🎯 ¿Qué tipo de proyecto general es?

    1. Académico / Investigación - Tesis, paper, investigación
    2. Creativo - Diseño, arte, multimedia, video
    3. Negocio / Startup - Business plan, emprendimiento
    4. Otro - Proyecto personalizado

    Elige 1-4:
    ```

75. USER: "1", "2", "3", or "4"

76. MAIN AGENT: Store `general_project_subtype` and continue to FORK 5

**═══════════════════════════════════════════════════════════════════**
**STEP 4B: FORK 5 - New vs Existing General Project (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

77. MAIN AGENT (example in Spanish):
    ```
    📂 ¿Es este un proyecto nuevo o ya tienes archivos/contenido existente?

    1. Proyecto nuevo - Voy a empezar desde cero
    2. Proyecto existente - Ya tengo archivos, documentos o contenido

    Elige 1 o 2:
    ```

78. USER: "1" or "2"

79. MAIN AGENT: Route based on selection
    - IF "1" → Go to appropriate NEW flow (B1, B2, B3, B4 based on subtype)
    - IF "2" → Go to **FLUJO BE: General Existente Discovery**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO BE: PROYECTO GENERAL EXISTENTE (Discovery Flow)**
**═══════════════════════════════════════════════════════════════════**

> **Note:** This flow applies to ALL general project types (Academic, Creative, Business, Other)
> when the user has existing files/content to analyze.

**═══════════════════════════════════════════════════════════════════**
**STEP 5BE: Project Structure Discovery (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

80. MAIN AGENT: Invoke **general-project-scanner** subagent

81. SUBAGENT: Scan project directory structure
    - Map all directories (exclude hidden, node_modules, .git, etc.)
    - Count files by extension
    - Categorize files by type

82. SUBAGENT (example in Spanish):
    ```
    📂 Estructura del proyecto detectada:

    proyecto/
    ├── documentos/
    │   ├── capitulos/
    │   └── referencias/
    ├── datos/
    │   └── encuestas/
    ├── imagenes/
    └── presentaciones/

    📊 Resumen de archivos:

    Documentos:
      • .docx: 15 archivos
      • .pdf: 23 archivos
      • .md: 8 archivos

    Datos:
      • .xlsx: 5 archivos
      • .csv: 12 archivos

    Imágenes:
      • .png: 45 archivos
      • .jpg: 28 archivos

    Presentaciones:
      • .pptx: 3 archivos

    Total: 139 archivos en 6 directorios
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 6BE: User Choice - Scope of Analysis (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

83. SUBAGENT (example in Spanish):
    ```
    🔍 ¿Cómo prefieres que analice tu proyecto?

    1. Directorio específico - Analizo solo una carpeta que elijas
    2. Todo el proyecto - Análisis completo (toma más tiempo)

    Elige 1 o 2:
    ```

84. USER: "1" or "2"

85. IF "1" (Specific directory):
    SUBAGENT:
    ```
    📁 ¿Qué directorio quieres que analice?

    Directorios disponibles:
    • documentos/
    • documentos/capitulos/
    • documentos/referencias/
    • datos/
    • datos/encuestas/
    • imagenes/
    • presentaciones/

    Escribe el nombre del directorio:
    ```
    USER: "documentos/capitulos/"
    → Go to **STEP 7BE** with `scope = specific_directory`

86. IF "2" (Full project):
    SUBAGENT:
    ```
    🚀 Iniciando análisis completo del proyecto...

    Esto puede tomar varios minutos dependiendo del tamaño.
    Te mostraré el progreso a medida que analizo cada directorio.
    ```
    → Go to **STEP 7BE** with `scope = full_project`

**═══════════════════════════════════════════════════════════════════**
**STEP 7BE: Multi-Subagent Parallel Discovery**
**═══════════════════════════════════════════════════════════════════**

87. SUBAGENT: Determine directories to analyze based on scope

88. IF `scope = specific_directory`:
    - Invoke single **directory-analyzer** subagent for chosen directory

89. IF `scope = full_project`:
    - **PARALLEL EXECUTION:** Invoke multiple **directory-analyzer** subagents
    - One subagent per top-level directory (documentos/, datos/, imagenes/, etc.)
    - Each subagent runs independently and concurrently

90. SUBAGENT: Show progress as each analyzer completes:
    ```
    🔍 Análisis en progreso:

      [✅] documentos/ - 23 archivos analizados, tema principal: "IA en educación"
      [✅] datos/ - 17 archivos analizados, datasets de encuestas detectados
      [⏳] imagenes/ - Analizando...
      [⏳] presentaciones/ - En cola...
    ```

91. Each **directory-analyzer** subagent returns:
    - Summary of content found
    - Key topics/themes detected
    - File relationships identified
    - Relevant metadata extracted

**═══════════════════════════════════════════════════════════════════**
**STEP 8BE: Consolidation and Executive Summary**
**═══════════════════════════════════════════════════════════════════**

92. SUBAGENT: Consolidate findings from all directory-analyzers
    - Merge detected themes
    - Cross-reference related files
    - Identify project structure and purpose

93. SUBAGENT (example in Spanish):
    ```
    ✅ Análisis completado!

    📋 Resumen ejecutivo del proyecto:

    🎯 Tipo detectado: Investigación Académica

    📚 Tema principal:
      "Impacto de la inteligencia artificial en la educación superior"

    📊 Contenido identificado:

    Documentos de investigación:
      • 5 capítulos de tesis (parcialmente completados)
      • 23 referencias bibliográficas en PDF
      • 8 notas de investigación en Markdown

    Datos de investigación:
      • 12 archivos CSV con respuestas de encuestas
      • 5 hojas de cálculo con análisis estadístico
      • Datos de ~500 participantes

    Material visual:
      • 45 gráficos y diagramas
      • 28 imágenes de referencia
      • 3 presentaciones (defensa, avance, propuesta)

    📈 Estado del proyecto:
      • Capítulos completados: 3 de 5
      • Análisis de datos: En progreso
      • Conclusiones: Pendiente

    🔗 Relaciones detectadas:
      • Los archivos CSV alimentan los gráficos en documentos/capitulos/
      • Las referencias PDF se citan en los capítulos
      • Las presentaciones resumen el contenido de los capítulos
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 9BE: Generate Manifest Based on Project Subtype**
**═══════════════════════════════════════════════════════════════════**

94. SUBAGENT: Based on `general_project_subtype` and discovery findings:
    - IF Academic → Generate `research_manifest.json` with discovered content
    - IF Creative → Generate `creative_manifest.json` with discovered assets
    - IF Business → Generate `business_manifest.json` with discovered docs
    - IF Other → Generate `general_manifest.json` with discovered structure

95. SUBAGENT: Populate manifest with:
    - Detected project name/title
    - Discovered themes/topics
    - File inventory and organization
    - Progress status (if determinable)
    - Recommended next actions based on gaps

96. SUBAGENT: Validate against appropriate schema

**═══════════════════════════════════════════════════════════════════**
**STEP 10BE: Success Message with Discovery Insights**
**═══════════════════════════════════════════════════════════════════**

97. SUBAGENT returns to MAIN AGENT

98. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Análisis y manifiesto completados!

    📁 Archivo generado:
      • ai_files/research_manifest.json

    🔍 Lo que descubrí de tu proyecto:

      Tema: Impacto de la IA en educación superior
      Metodología detectada: Cuantitativa (encuestas)
      Estado: ~60% completado (3/5 capítulos)

      Archivos clave identificados:
      • Tesis principal: documentos/capitulos/
      • Datos: datos/encuestas/ (500 participantes)
      • Referencias: 23 fuentes bibliográficas

    📋 Recomendaciones basadas en el análisis:
      • Completar capítulo 4 (Análisis de resultados)
      • Actualizar gráficos con últimos datos
      • Agregar 5-7 referencias más recientes (2023-2024)

    🎯 Próximo paso:

      Establece los estándares de tu investigación:
      /ai-behavior:rules-create academic

      Esto documentará tus convenciones de escritura,
      formato de citas y estructura de capítulos.
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJOS B1-B4: PROYECTOS GENERALES NUEVOS**
**═══════════════════════════════════════════════════════════════════**

> **Note:** The following flows (B1, B2, B3, B4) are for NEW general projects only.
> For EXISTING general projects, use FLUJO BE above.

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B1: PROYECTO ACADÉMICO / INVESTIGACIÓN (NUEVO)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 4B1: Invoke Subagent for Academic Project**
**═══════════════════════════════════════════════════════════════════**

77. MAIN AGENT: Invoke **manifest-creator-academic** subagent

**═══════════════════════════════════════════════════════════════════**
**STEP 5B1: Question 1 - Research Topic (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

78. SUBAGENT (example in Spanish):
    ```
    📚 ¿Cuál es el tema de tu investigación?

    Ejemplo: "Impacto de la inteligencia artificial en la educación superior"
    ```

79. USER: Provides research topic

80. SUBAGENT: Store `research_topic`

**═══════════════════════════════════════════════════════════════════**
**STEP 6B1: Question 2 - Methodology (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

81. SUBAGENT (example in Spanish):
    ```
    🔬 ¿Qué metodología de investigación usarás?

    1. Cualitativa - Entrevistas, estudios de caso, etnografía
    2. Cuantitativa - Encuestas, experimentos, análisis estadístico
    3. Mixta - Combinación de cualitativa y cuantitativa
    4. Revisión bibliográfica - State of the art
    5. Otra - Especifica

    Elige 1-5:
    ```

82. USER: "2"

83. SUBAGENT: Store `methodology = "Cuantitativa"`

**═══════════════════════════════════════════════════════════════════**
**STEP 7B1: Question 3 - Theoretical Framework (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

84. SUBAGENT (example in Spanish):
    ```
    📖 ¿Cuál es el marco teórico principal de tu investigación?

    Ejemplo: "Teoría del aprendizaje constructivista, Modelo TAM (Technology Acceptance Model)"
    ```

85. USER: Provides theoretical framework

86. SUBAGENT: Store `theoretical_framework`

**═══════════════════════════════════════════════════════════════════**
**STEP 8B1: Question 4 - Timeline/Milestones (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

87. SUBAGENT (example in Spanish):
    ```
    📅 Define los hitos/entregables de tu investigación:

    Escribe uno por línea, ejemplos:
    - Capítulo 1: Marco teórico (15 Feb 2025)
    - Capítulo 2: Metodología (28 Feb 2025)
    - Recolección de datos (30 Mar 2025)
    - Capítulo 3: Análisis de resultados (30 Abr 2025)
    - Capítulo 4: Conclusiones (15 May 2025)
    - Defensa de tesis (30 May 2025)

    Escribe tus hitos:
    ```

88. USER: Provides milestones (multiline)

89. SUBAGENT: Parse milestones into array with dates

**═══════════════════════════════════════════════════════════════════**
**STEP 9B1: Question 5 - Citation Format (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

90. SUBAGENT (example in Spanish):
    ```
    📝 ¿Qué formato de citas usarás?

    1. APA (American Psychological Association)
    2. MLA (Modern Language Association)
    3. Chicago
    4. IEEE
    5. Vancouver
    6. Harvard
    7. Otro - Especifica

    Elige 1-7:
    ```

91. USER: "1"

92. SUBAGENT: Store `citation_format = "APA"`

**═══════════════════════════════════════════════════════════════════**
**STEP 10B1: Generate Research Manifest**
**═══════════════════════════════════════════════════════════════════**

93. SUBAGENT (example in Spanish):
    ```
    ⚙️ Generando manifiesto de investigación...
    ```

94. SUBAGENT: Generate `ai_files/research_manifest.json`:
    ```json
    {
      "research": {
        "title": "From research_topic",
        "type": "Academic research",
        "methodology": "Cuantitativa",
        "theoretical_framework": "User's framework",
        "start_date": "Today or user-specified",
        "expected_completion": "From last milestone"
      },
      "structure": {
        "chapters": "Parsed from milestones",
        "milestones": [
          {
            "title": "Capítulo 1: Marco teórico",
            "due_date": "2025-02-15",
            "status": "pending"
          }
        ]
      },
      "academic_details": {
        "citation_format": "APA",
        "bibliography_sources": [],
        "keywords": "To be populated",
        "research_questions": "To be defined"
      },
      "llm_notes": {
        "is_up_to_date": true,
        "recommended_actions": [
          "Define specific research questions",
          "Start compiling bibliography",
          "Create /ai-behavior:rules-create academic for citation and writing standards"
        ]
      }
    }
    ```

95. SUBAGENT: Validate against research_manifest_schema.json

**═══════════════════════════════════════════════════════════════════**
**STEP 11B1: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

96. SUBAGENT returns to MAIN AGENT

97. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Manifiesto de investigación creado!

    📁 Archivo generado:
      • ai_files/research_manifest.json

    📋 Resumen de tu investigación:
      • Tema: Impacto de la IA en educación superior
      • Metodología: Cuantitativa
      • Marco teórico: TAM, Constructivismo
      • Hitos: 6 entregables definidos
      • Formato de citas: APA

    🎯 Próximo paso:

      Establece los estándares académicos para tu investigación:
      /ai-behavior:rules-create academic

      Este comando creará academic_standards.json con:
      • Reglas de citación APA
      • Estructura de capítulos
      • Convenciones de escritura académica
      • Formato de tablas y figuras
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B2: PROYECTO CREATIVO (Diseño/Arte/Multimedia)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 4B2: Invoke Subagent for Creative Project**
**═══════════════════════════════════════════════════════════════════**

98. MAIN AGENT: Invoke **manifest-creator-creative** subagent

**═══════════════════════════════════════════════════════════════════**
**STEP 5B2: Question 1 - Concept/Brief (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

99. SUBAGENT (example in Spanish):
    ```
    🎨 Describe el concepto o brief de tu proyecto creativo:

    Ejemplo: "Serie de ilustraciones digitales inspiradas en mitología
    mesoamericana con estética cyberpunk para libro de arte"
    ```

100. USER: Provides concept

101. SUBAGENT: Store `concept`

**═══════════════════════════════════════════════════════════════════**
**STEP 6B2: Question 2 - Visual/Artistic Style (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

102. SUBAGENT (example in Spanish):
     ```
     🖌️ ¿Qué estilo visual o artístico seguirás?

     Ejemplo: "Ilustración digital vectorial, flat design con texturas,
     paleta neón sobre fondos oscuros"
     ```

103. USER: Provides style

104. SUBAGENT: Store `visual_style`

**═══════════════════════════════════════════════════════════════════**
**STEP 7B2: Question 3 - Color Palette/References (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

105. SUBAGENT (example in Spanish):
     ```
     🎨 Define tu paleta de colores o referencias visuales:

     Puedes especificar:
     - Colores hex (#FF00FF, #00FFFF, #FF10F0)
     - Referencias (Behance, Dribbble, artistas)
     - Mood board links

     Escribe tu paleta/referencias:
     ```

106. USER: Provides color palette/references

107. SUBAGENT: Store `color_palette`

**═══════════════════════════════════════════════════════════════════**
**STEP 8B2: Question 4 - Assets Needed (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

108. SUBAGENT (example in Spanish):
     ```
     📦 ¿Qué assets o recursos necesitas crear?

     Escribe uno por línea, ejemplos:
     - 12 ilustraciones principales (tamaño A4, 300dpi)
     - Logo y variantes (SVG + PNG)
     - Paleta de colores documentada
     - Tipografía personalizada
     - Mockups de libro (portada + contraportada)

     Escribe tus assets:
     ```

109. USER: Provides assets (multiline)

110. SUBAGENT: Parse assets into array

**═══════════════════════════════════════════════════════════════════**
**STEP 9B2: Question 5 - Deliverables/Milestones (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

111. SUBAGENT (example in Spanish):
     ```
     📅 Define los entregables y fechas:

     Escribe uno por línea, ejemplos:
     - Bocetos iniciales (10 Feb 2025)
     - 4 ilustraciones finales (28 Feb 2025)
     - Diseño de portada (15 Mar 2025)
     - Libro completo maquetado (30 Mar 2025)

     Escribe tus entregables:
     ```

112. USER: Provides deliverables (multiline)

113. SUBAGENT: Parse deliverables with dates

**═══════════════════════════════════════════════════════════════════**
**STEP 10B2: Generate Creative Manifest**
**═══════════════════════════════════════════════════════════════════**

114. SUBAGENT (example in Spanish):
     ```
     ⚙️ Generando manifiesto creativo...
     ```

115. SUBAGENT: Generate `ai_files/creative_manifest.json`:
     ```json
     {
       "project": {
         "title": "From concept",
         "type": "Creative/Design",
         "concept": "User's concept",
         "start_date": "Today",
         "expected_completion": "From last deliverable"
       },
       "creative_details": {
         "visual_style": "User's style",
         "color_palette": "User's palette",
         "references": "Parsed references",
         "tools": "To be defined (Figma, Adobe, Procreate, etc.)"
       },
       "assets": [
         {
           "name": "12 ilustraciones principales",
           "format": "A4, 300dpi",
           "status": "pending"
         }
       ],
       "deliverables": [
         {
           "title": "Bocetos iniciales",
           "due_date": "2025-02-10",
           "status": "pending"
         }
       ],
       "llm_notes": {
         "is_up_to_date": true,
         "recommended_actions": [
           "Create mood board",
           "Gather reference materials",
           "Create /ai-behavior:rules-create creative for design standards"
         ]
       }
     }
     ```

116. SUBAGENT: Validate against creative_manifest_schema.json

**═══════════════════════════════════════════════════════════════════**
**STEP 11B2: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

117. SUBAGENT returns to MAIN AGENT

118. MAIN AGENT (example in Spanish):
     ```
     ✅ ¡Manifiesto creativo generado!

     📁 Archivo generado:
       • ai_files/creative_manifest.json

     📋 Resumen de tu proyecto:
       • Concepto: Ilustraciones mitología + cyberpunk
       • Estilo: Vectorial flat design con texturas neón
       • Assets: 12 ilustraciones, logo, mockups
       • Entregables: 4 hitos hasta 30 Mar 2025

     🎯 Próximo paso:

       Establece los estándares creativos:
       /ai-behavior:rules-create creative

       Este comando creará creative_standards.json con:
       • Especificaciones de archivos (formatos, resoluciones)
       • Paleta de colores documentada
       • Tipografía y jerarquías
       • Guías de estilo visual
     ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B3: PROYECTO NEGOCIO / STARTUP**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 4B3: Invoke Subagent for Business Project**
**═══════════════════════════════════════════════════════════════════**

119. MAIN AGENT: Invoke **manifest-creator-business** subagent

120. SUBAGENT (example in Spanish):
     ```
     💼 Voy a guiarte a través del Business Model Canvas para estructurar
     tu proyecto de negocio con 9 preguntas.
     ```

**═══════════════════════════════════════════════════════════════════**
**STEP 5B3: Business Model Canvas - 9 Questions (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

**Question 1: Value Proposition**

121. SUBAGENT (example in Spanish):
     ```
     💡 1/9 - Propuesta de Valor

     ¿Qué problema resuelves y qué valor ofreces a tus clientes?

     Ejemplo: "Plataforma SaaS que automatiza la contabilidad para
     freelancers, ahorrándoles 10 horas/mes en tareas administrativas"
     ```

122. USER: Provides value proposition

123. SUBAGENT: Store `value_proposition`

**Question 2: Customer Segments**

124. SUBAGENT (example in Spanish):
     ```
     👥 2/9 - Segmentos de Clientes

     ¿Quiénes son tus clientes objetivo?

     Ejemplo: "Freelancers de diseño y desarrollo, 25-45 años,
     facturación €20k-€100k/año, en España y LatAm"
     ```

125. USER: Provides customer segments

126. SUBAGENT: Store `customer_segments`

**Question 3: Channels**

127. SUBAGENT (example in Spanish):
     ```
     📢 3/9 - Canales de Distribución

     ¿Cómo llegarás a tus clientes y entregarás tu valor?

     Ejemplo: "Marketing: SEO, LinkedIn, comunidades freelance.
     Distribución: Web app, integraciones con bancos"
     ```

128. USER: Provides channels

129. SUBAGENT: Store `channels`

**Question 4: Revenue Streams**

130. SUBAGENT (example in Spanish):
     ```
     💰 4/9 - Fuentes de Ingresos

     ¿Cómo generarás dinero?

     Ejemplo: "Suscripción mensual €29/mes (básico), €79/mes (pro),
     €199/mes (enterprise). Comisión 1% en facturas procesadas"
     ```

131. USER: Provides revenue streams

132. SUBAGENT: Store `revenue_streams`

**Question 5: Cost Structure**

133. SUBAGENT (example in Spanish):
     ```
     💸 5/9 - Estructura de Costos

     ¿Cuáles serán tus principales costos?

     Ejemplo: "Infraestructura cloud (€500/mes), equipo desarrollo
     (2 devs), marketing (€2k/mes), legal/contable (€300/mes)"
     ```

134. USER: Provides cost structure

135. SUBAGENT: Store `cost_structure`

**Question 6: Key Resources**

136. SUBAGENT (example in Spanish):
     ```
     🔑 6/9 - Recursos Clave

     ¿Qué recursos necesitas para funcionar?

     Ejemplo: "Plataforma tech (React + Node.js), integraciones bancarias,
     equipo 2 devs + 1 diseñador, capital inicial €50k"
     ```

137. USER: Provides key resources

138. SUBAGENT: Store `key_resources`

**Question 7: Key Activities**

139. SUBAGENT (example in Spanish):
     ```
     ⚙️ 7/9 - Actividades Clave

     ¿Qué actividades son esenciales para tu negocio?

     Ejemplo: "Desarrollo producto, soporte cliente, marketing digital,
     mantener integraciones bancarias, compliance legal"
     ```

140. USER: Provides key activities

141. SUBAGENT: Store `key_activities`

**Question 8: Key Partnerships**

142. SUBAGENT (example in Spanish):
     ```
     🤝 8/9 - Socios Clave

     ¿Con quién necesitas aliarte?

     Ejemplo: "Bancos (integraciones API), plataformas freelance
     (partnerships), asesores legales, partners tecnológicos (Stripe)"
     ```

143. USER: Provides key partnerships

144. SUBAGENT: Store `key_partnerships`

**Question 9: Customer Relationships**

145. SUBAGENT (example in Spanish):
     ```
     💬 9/9 - Relación con Clientes

     ¿Cómo te relacionarás con tus clientes?

     Ejemplo: "Onboarding automático + tutorial, soporte chat en vivo,
     email mensual con tips, comunidad Slack para usuarios"
     ```

146. USER: Provides customer relationships

147. SUBAGENT: Store `customer_relationships`

**═══════════════════════════════════════════════════════════════════**
**STEP 6B3: Generate Business Manifest**
**═══════════════════════════════════════════════════════════════════**

148. SUBAGENT (example in Spanish):
     ```
     ⚙️ Generando Business Model Canvas...
     ```

149. SUBAGENT: Generate `ai_files/business_manifest.json`:
     ```json
     {
       "business": {
         "name": "From directory or user input",
         "type": "Startup/Business",
         "stage": "To be defined (idea, MVP, growth, scaling)",
         "start_date": "Today"
       },
       "business_model_canvas": {
         "value_proposition": "User's answer",
         "customer_segments": "User's answer",
         "channels": "User's answer",
         "customer_relationships": "User's answer",
         "revenue_streams": "User's answer",
         "key_resources": "User's answer",
         "key_activities": "User's answer",
         "key_partnerships": "User's answer",
         "cost_structure": "User's answer"
       },
       "metrics": {
         "kpis": "To be defined",
         "targets": "To be defined"
       },
       "llm_notes": {
         "is_up_to_date": true,
         "recommended_actions": [
           "Define specific KPIs and targets",
           "Create financial projections",
           "Create /ai-behavior:rules-create business for business rules and processes"
         ]
       }
     }
     ```

150. SUBAGENT: Validate against business_manifest_schema.json

**═══════════════════════════════════════════════════════════════════**
**STEP 7B3: Success Message with Canvas Summary**
**═══════════════════════════════════════════════════════════════════**

151. SUBAGENT returns to MAIN AGENT

152. MAIN AGENT (example in Spanish):
     ```
     ✅ ¡Business Model Canvas completado!

     📁 Archivo generado:
       • ai_files/business_manifest.json

     📊 Tu Business Model Canvas:

     💡 Propuesta de Valor:
       → Automatización contabilidad para freelancers

     👥 Clientes:
       → Freelancers diseño/dev, 25-45 años, España/LatAm

     💰 Ingresos:
       → Suscripción €29-€199/mes + comisión 1%

     💸 Costos principales:
       → Cloud (€500/mes), equipo (2 devs), marketing (€2k/mes)

     🔑 Recursos clave:
       → Plataforma tech, integraciones, equipo, capital €50k

     🤝 Socios:
       → Bancos, plataformas freelance, Stripe

     📢 Canales:
       → SEO, LinkedIn, comunidades

     💬 Relación:
       → Onboarding automático, chat soporte, comunidad Slack

     ⚙️ Actividades:
       → Desarrollo, soporte, marketing, compliance

     🎯 Próximo paso:

       Establece las reglas de negocio:
       /ai-behavior:rules-create business

       Este comando creará business_rules.json con:
       • Procesos operativos
       • Políticas de precios
       • Flujos de trabajo
       • KPIs y métricas
     ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B4: PROYECTO OTRO (Personalizado/Genérico)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP 4B4: Invoke Subagent for Generic Project**
**═══════════════════════════════════════════════════════════════════**

153. MAIN AGENT: Invoke **manifest-creator-generic** subagent

**═══════════════════════════════════════════════════════════════════**
**STEP 5B4: Generic Questions (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

**Question 1: Project Name**

154. SUBAGENT (example in Spanish):
     ```
     📝 1/5 - ¿Cuál es el nombre de tu proyecto?
     ```

155. USER: Provides name

156. SUBAGENT: Store `project_name`

**Question 2: Description**

157. SUBAGENT (example in Spanish):
     ```
     📖 2/5 - Describe tu proyecto en 2-3 oraciones:

     ¿De qué trata? ¿Qué intentas lograr?
     ```

158. USER: Provides description

159. SUBAGENT: Store `description`

**Question 3: Main Objectives**

160. SUBAGENT (example in Spanish):
     ```
     🎯 3/5 - ¿Cuáles son tus objetivos principales?

     Escribe uno por línea, ejemplos:
     - Completar documento de 50 páginas
     - Organizar evento para 200 personas
     - Crear plan de marketing para Q1 2025

     Escribe tus objetivos:
     ```

161. USER: Provides objectives (multiline)

162. SUBAGENT: Parse objectives into array

**Question 4: Expected Deliverables**

163. SUBAGENT (example in Spanish):
     ```
     📦 4/5 - ¿Qué entregables esperas producir?

     Escribe uno por línea, ejemplos:
     - Documento final en PDF
     - Presentación de resultados
     - Plan de acción documentado

     Escribe tus entregables:
     ```

164. USER: Provides deliverables (multiline)

165. SUBAGENT: Parse deliverables into array

**Question 5: Milestones/Timeline**

166. SUBAGENT (example in Spanish):
     ```
     📅 5/5 - Define los hitos o fechas importantes:

     Escribe uno por línea con fecha, ejemplos:
     - Investigación inicial (15 Feb 2025)
     - Borrador completo (1 Mar 2025)
     - Revisión final (15 Mar 2025)
     - Entrega final (30 Mar 2025)

     Escribe tus hitos:
     ```

167. USER: Provides milestones (multiline)

168. SUBAGENT: Parse milestones with dates

**═══════════════════════════════════════════════════════════════════**
**STEP 6B4: Generate General Manifest**
**═══════════════════════════════════════════════════════════════════**

169. SUBAGENT (example in Spanish):
     ```
     ⚙️ Generando manifiesto genérico...
     ```

170. SUBAGENT: Generate `ai_files/general_manifest.json`:
     ```json
     {
       "project": {
         "name": "User's name",
         "type": "General/Other",
         "description": "User's description",
         "start_date": "Today",
         "expected_completion": "From last milestone"
       },
       "objectives": [
         "Objective 1",
         "Objective 2"
       ],
       "deliverables": [
         {
           "name": "Deliverable 1",
           "status": "pending"
         }
       ],
       "milestones": [
         {
           "title": "Milestone 1",
           "due_date": "2025-02-15",
           "status": "pending"
         }
       ],
       "llm_notes": {
         "is_up_to_date": true,
         "recommended_actions": [
           "Start working on first objective",
           "Create /ai-behavior:logbook-create to track progress"
         ]
       }
     }
     ```

171. SUBAGENT: Validate against general_manifest_schema.json

**═══════════════════════════════════════════════════════════════════**
**STEP 7B4: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

172. SUBAGENT returns to MAIN AGENT

173. MAIN AGENT (example in Spanish):
     ```
     ✅ ¡Manifiesto de proyecto creado!

     📁 Archivo generado:
       • ai_files/general_manifest.json

     📋 Resumen de tu proyecto:
       • Nombre: [User's project name]
       • Objetivos: [X objectives]
       • Entregables: [Y deliverables]
       • Hitos: [Z milestones]

     🎯 Próximo paso:

       Empieza a trabajar en tu proyecto y registra el progreso:
       /ai-behavior:logbook-create

       El logbook te ayudará a mantener contexto de lo que vas
       haciendo y los hallazgos importantes.
     ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Main Orchestrator Subagents:**

1. **manifest-creator-new-software**
   - Tools: Read, Write, Bash
   - Responsibilities: 5 questions for new software projects, generate template manifest
   - Workflows: `workflows/manifest/new-software-setup.md`

2. **manifest-creator-known-software**
   - Tools: Read, Write, Bash, Glob, Grep, Task (to invoke 6 specialized subagents)
   - Responsibilities: 3 checkpoint questions, orchestrate 6 analysis subagents, cross-analysis, generate manifest + architecture map
   - Workflows: `workflows/manifest/known-software-analysis.md`, `workflows/manifest/cross-analysis.md`

3. **manifest-creator-unknown-software**
   - Tools: Read, Write, Bash, Glob, Grep, Task (to invoke 6 specialized subagents)
   - Responsibilities: 0 questions, progress prints, orchestrate 6 analysis subagents, educational output
   - Workflows: `workflows/manifest/unknown-software-analysis.md`, `workflows/manifest/cross-analysis.md`

4. **manifest-creator-academic**
   - Tools: Read, Write
   - Responsibilities: 5 questions for academic projects, generate research manifest
   - Workflows: `workflows/manifest/academic-setup.md`

5. **manifest-creator-creative**
   - Tools: Read, Write
   - Responsibilities: 5 questions for creative projects, generate creative manifest
   - Workflows: `workflows/manifest/creative-setup.md`

6. **manifest-creator-business**
   - Tools: Read, Write
   - Responsibilities: 9 Business Canvas questions, generate business manifest
   - Workflows: `workflows/manifest/business-canvas.md`

7. **manifest-creator-generic**
   - Tools: Read, Write
   - Responsibilities: 5 generic questions, generate general manifest
   - Workflows: `workflows/manifest/generic-setup.md`

### **General Project Discovery Subagents (for FLUJO BE):**

8. **general-project-scanner**
   - Tools: Read, Bash, Glob
   - Responsibilities: Scan directory structure, count files by type, categorize content
   - Output: Directory tree + file type summary

9. **directory-analyzer**
   - Tools: Read, Glob, Grep
   - Responsibilities: Deep analysis of a specific directory, extract themes/topics, identify relationships
   - Output: Directory content summary with detected themes and metadata
   - Note: Multiple instances run in parallel for full project analysis

### **Specialized Analysis Subagents (for A2.1 and A2.2):**

10. **entry-point-analyzer**
    - Tools: Read, Glob, Grep
    - Responsibilities: Find and trace application entry points
    - Output: Entry points map with startup flow

11. **navigation-mapper**
    - Tools: Read, Glob, Grep
    - Responsibilities: Map routing and navigation (frontend focused)
    - Output: Routes map with components

12. **flow-tracker**
    - Tools: Read, Glob, Grep
    - Responsibilities: Map API endpoints and event handlers (backend focused)
    - Output: API endpoint map

13. **dependency-auditor**
    - Tools: Read, Bash
    - Responsibilities: Analyze dependencies, categorize, check versions
    - Output: Dependency tree with categories and recommendations

14. **architecture-detective**
    - Tools: Read, Glob, Grep
    - Responsibilities: Analyze architecture layers, patterns, separation of concerns
    - Output: Architecture map with layers and patterns

15. **feature-extractor**
    - Tools: Read, Glob, Grep
    - Responsibilities: Identify user-facing features by cross-referencing routes/components/APIs
    - Output: Feature list with implementation details

---

**═══════════════════════════════════════════════════════════════════**
**WORKFLOWS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Manifest Creation Workflows:**

1. `workflows/manifest/check-existing-manifest.md`
   - Check if manifest exists
   - Offer overwrite or cancel options

2. `workflows/manifest/new-software-setup.md`
   - 5 questions flow for new software projects
   - Generate template with smart defaults

3. `workflows/manifest/known-software-analysis.md`
   - Auto-detect technologies
   - 3 checkpoint questions
   - Orchestrate 6 specialized subagents

4. `workflows/manifest/unknown-software-analysis.md`
   - Progress prints pattern
   - Silent auto-detection
   - Orchestrate 6 specialized subagents
   - Educational output format

5. `workflows/manifest/cross-analysis.md`
   - Combine findings from 6 subagents
   - Validate consistency
   - Generate manifest + architecture map

6. `workflows/manifest/academic-setup.md`
   - 5 questions for academic research
   - Generate research manifest

7. `workflows/manifest/creative-setup.md`
   - 5 questions for creative projects
   - Generate creative manifest

8. `workflows/manifest/business-canvas.md`
   - 9 Business Model Canvas questions
   - Generate business manifest

9. `workflows/manifest/generic-setup.md`
   - 5 generic questions
   - Generate general manifest

### **General Project Discovery Workflows (for FLUJO BE):**

10. `workflows/manifest/general-project-scan.md`
    - Scan directory structure
    - Count and categorize files by type
    - Generate summary view

11. `workflows/manifest/directory-deep-analysis.md`
    - Analyze content of specific directory
    - Extract themes and topics
    - Identify file relationships

12. `workflows/manifest/consolidate-discovery.md`
    - Merge findings from multiple directory-analyzers
    - Generate executive summary
    - Populate manifest based on project subtype

### **Analysis Workflows (for specialized subagents):**

13. `workflows/analysis/find-entry-points.md`
14. `workflows/analysis/map-navigation.md`
15. `workflows/analysis/track-flows.md`
16. `workflows/analysis/audit-dependencies.md`
17. `workflows/analysis/detect-architecture.md`
18. `workflows/analysis/extract-features.md`

---

**Status:** ✅ DESIGNED (All 8 flows complete - A1, A2.1, A2.2, BE, B1, B2, B3, B4)

---

**═══════════════════════════════════════════════════════════════════**
**TODO: SCHEMAS PENDIENTES DE CREAR**
**═══════════════════════════════════════════════════════════════════**

The following schemas need to be created based on existing `project_manifest_schema.json`:

1. **`research_manifest_schema.json`** - For academic/research projects
   - Based on: FLUJO B1 structure
   - Key fields: research topic, methodology, theoretical framework, milestones, citation format

2. **`creative_manifest_schema.json`** - For creative/design projects
   - Based on: FLUJO B2 structure
   - Key fields: concept, visual style, color palette, assets, deliverables

3. **`business_manifest_schema.json`** - For business/startup projects
   - Based on: FLUJO B3 structure
   - Key fields: Business Model Canvas (9 blocks), KPIs, metrics

4. **`general_manifest_schema.json`** - For generic/other projects
   - Based on: FLUJO B4 structure
   - Key fields: objectives, deliverables, milestones

5. **`architecture_map_schema.json`** - For software architecture documentation
   - Based on: FLUJO A2.1/A2.2 output
   - Key fields: layers, patterns, routes, endpoints, cross-references

**Action:** Run schema creation command to generate these based on the flow designs above.
