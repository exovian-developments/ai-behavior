# Command: `/waves:manifest-update`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Detect changes since last manifest update and intelligently update the manifest with new features, architecture changes, dependencies, and other relevant modifications.

**Input:** Existing manifest file (`project_manifest.json`, `research_manifest.json`, etc.)

**Output:** Updated manifest file with `last_updated` refreshed

**Parameters:** None (auto-detects changes based on `last_updated` field)

**Key Decision Points:**
1. **FORK 1:** Git available vs No Git (timestamp-based)
2. **FORK 2:** (Software only) Framework-specific autogeneration detection

**Flow Derivations (2 main flows):**
- **A:** Git-based Update → Precise history analysis → Deduplicated file list → Criteria-based update
- **B:** Timestamp-based Update → File modification dates → Change detection → Criteria-based update

---

## Update Criteria (Inferred from Schema)

Changes that warrant manifest updates:

| Category | Trigger | Manifest Field |
|----------|---------|----------------|
| **Architecture** | New directory in architectural layer (e.g., `/services/`, `/controllers/`) | `technical_details.architecture_patterns_by_layer` |
| **Features** | New feature module or user-facing functionality | `features[]` |
| **Core/Services** | New internal service, utility, or core module | `technical_details.modules` |
| **Business Flow** | New API endpoint, route, or workflow | `technical_details.modules`, `features[]` |
| **Tech Stack** | New dependency added to package.json/requirements.txt | `platform_info`, `dependencies` |
| **Entry Points** | New main file or bootstrap logic | `technical_details.entry_points` |

**Non-triggers (ignore):**
- Bug fixes within existing files (no structural change)
- Refactoring that doesn't add new modules
- Documentation changes
- Test file changes (unless new test framework)
- Style/formatting changes

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO PRINCIPAL - ENTRY POINT**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

1. MAIN AGENT: Check if `ai_files/user_pref.json` exists
   - IF NOT EXISTS → Error: "Run /waves:project-init first"

2. MAIN AGENT: Read `project_context.project_type` from user_pref.json

3. MAIN AGENT: Check if corresponding manifest exists:
   - Software → `ai_files/project_manifest.json`
   - Academic → `ai_files/research_manifest.json`
   - Creative → `ai_files/creative_manifest.json`
   - Business → `ai_files/business_manifest.json`
   - General → `ai_files/general_manifest.json`

4. IF manifest NOT EXISTS → MAIN AGENT:
   ```
   ⚠️ No existe un manifiesto para actualizar.

   Primero crea el manifiesto con:
   /waves:manifest-create
   ```
   → **EXIT COMMAND**

5. IF all valid → Continue to STEP 0

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Read Current Manifest and Extract Baseline**
**═══════════════════════════════════════════════════════════════════**

6. MAIN AGENT: Read manifest file

7. MAIN AGENT: Extract key fields:
   - `last_updated` → Baseline date for change detection
   - `project.name` → For display
   - Current state of all trackable fields

8. MAIN AGENT (in user's language, example in Spanish):
   ```
   📘 Comando: /waves:manifest-update

   Detectaré los cambios desde la última actualización del manifiesto
   y actualizaré automáticamente los campos relevantes.

   📅 Última actualización: 2024-11-15
   📁 Manifiesto: ai_files/project_manifest.json

   ¿Deseas continuar? (Si/No)
   ```

9. IF NO → Exit
10. IF SI → Continue

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Detect Version Control System**
**═══════════════════════════════════════════════════════════════════**

11. MAIN AGENT: Check if `.git` directory exists

12. IF `.git` EXISTS:
    - Store `version_control = "git"`
    - Go to **FLUJO A: Git-based Update**

13. IF `.git` NOT EXISTS:
    - Store `version_control = "none"`
    - IF `project_type === "software"`:
      ```
      💡 Recomendación: Este proyecto de software no usa Git.

      Considera inicializar control de versiones:
      git init

      Git permite un seguimiento más preciso de cambios.
      Continuaré con análisis basado en fechas de archivos...
      ```
    - Go to **FLUJO B: Timestamp-based Update**

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO A: GIT-BASED UPDATE (Precise History Analysis)**
**═══════════════════════════════════════════════════════════════════**

**═══════════════════════════════════════════════════════════════════**
**STEP A1: Get Git History Since Last Update**
**═══════════════════════════════════════════════════════════════════**

14. MAIN AGENT: Invoke **git-history-analyzer** subagent

15. SUBAGENT: Execute git commands to analyze history:
    ```bash
    # Get commit count since last_updated
    git rev-list --count --since="2024-11-15" HEAD

    # Get all commits since last_updated
    git log --since="2024-11-15" --oneline

    # Get summary of changes
    git diff --stat $(git rev-list -n1 --before="2024-11-15" HEAD)..HEAD
    ```

16. SUBAGENT: Store results:
    - `commit_count` = Number of commits since last update
    - `commits_list` = List of commit hashes and messages
    - `change_summary` = Overall diff stats

17. SUBAGENT (example in Spanish):
    ```
    📊 Análisis de historial Git:

    📅 Período: 2024-11-15 → 2024-11-25 (10 días)
    📝 Commits encontrados: 15
    📁 Archivos afectados: 47

    Analizando cambios en detalle...
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A2: Build File Change Summary (Modified, New, Deleted)**
**═══════════════════════════════════════════════════════════════════**

18. SUBAGENT: Get detailed file changes:
    ```bash
    # Get all files that changed with their status
    git diff --name-status $(git rev-list -n1 --before="2024-11-15" HEAD)..HEAD
    ```

19. SUBAGENT: Parse output and categorize:
    - `M` → Modified files
    - `A` → Added (new) files
    - `D` → Deleted files
    - `R` → Renamed files

20. SUBAGENT: Build categorized lists:
    ```
    📋 Resumen de cambios:

    ✏️ Archivos modificados (32):
      • src/services/auth.ts
      • src/components/Dashboard.tsx
      • src/api/endpoints.ts
      • ... y 29 más

    ➕ Archivos nuevos (12):
      • src/features/payments/PaymentForm.tsx
      • src/features/payments/paymentService.ts
      • src/services/notifications.ts
      • ... y 9 más

    ➖ Archivos eliminados (3):
      • src/utils/deprecated-helper.ts
      • src/components/OldWidget.tsx
      • config/legacy.json
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A3: Filter Autogenerated Files**
**═══════════════════════════════════════════════════════════════════**

21. SUBAGENT: Invoke **autogen-detector** subagent

22. AUTOGEN-DETECTOR: Read and parse `.gitignore`
    - Extract ignored patterns
    - These are typically autogenerated or not tracked

23. AUTOGEN-DETECTOR: Analyze framework (from manifest `platform_info.framework`):
    - IF Next.js → Check for `.next/`, `out/`
    - IF React → Check for `build/`, `dist/`
    - IF Flutter → Check for `.dart_tool/`, `build/`
    - IF Python → Check for `__pycache__/`, `.pyc`, `venv/`
    - etc.

24. AUTOGEN-DETECTOR: Check for code generation libraries:
    ```bash
    # Check package.json for generators
    grep -E "(prisma|graphql-codegen|swagger-codegen|openapi-generator)" package.json
    ```
    - IF Prisma found → Ignore `prisma/generated/`
    - IF GraphQL Codegen → Ignore `generated/graphql/`
    - IF OpenAPI Generator → Ignore `generated/api/`

25. AUTOGEN-DETECTOR: Return list of patterns to ignore

26. SUBAGENT: Filter file lists, removing autogenerated files:
    ```
    🔍 Filtrado de archivos autogenerados:

    Ignorados por .gitignore: 5 archivos
    Ignorados por framework (Next.js): 3 archivos
    Ignorados por codegen (Prisma): 8 archivos

    📋 Archivos relevantes para análisis:
      • Modificados: 28 (de 32 original)
      • Nuevos: 10 (de 12 original)
      • Eliminados: 2 (de 3 original)
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A4: Deduplicate - Only Analyze Latest Version**
**═══════════════════════════════════════════════════════════════════**

27. SUBAGENT: For modified files, ensure we only analyze current state:
    ```bash
    # We don't need to see intermediate changes
    # Just analyze the file as it exists NOW in HEAD
    # The git diff already gives us the final state
    ```

28. SUBAGENT: Build final "files to analyze" list:
    - Modified files → Analyze current HEAD version
    - New files → Analyze current HEAD version
    - Deleted files → Note for removal from manifest (if applicable)

29. SUBAGENT (example):
    ```
    📝 Lista final de archivos a analizar:

    Para actualización del manifest analizaré:
    • 28 archivos modificados (versión actual)
    • 10 archivos nuevos
    • 2 archivos eliminados (verificar si afectan manifest)

    Total: 40 archivos
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A5: Analyze Changes Against Update Criteria**
**═══════════════════════════════════════════════════════════════════**

30. SUBAGENT: Invoke **manifest-change-analyzer** subagent

31. CHANGE-ANALYZER: For each NEW file, check against criteria:

    **Architecture Detection:**
    ```
    IF new file path matches architectural pattern:
      - /services/* → New service detected
      - /controllers/* → New controller detected
      - /repositories/* → New repository detected
      - /features/*/* → New feature module detected
      - /api/* → New API layer component
    THEN → Flag for `technical_details.architecture_patterns_by_layer` update
    ```

    **Feature Detection:**
    ```
    IF new directory under /features/ OR new route/page:
      - Analyze file content for feature name
      - Check for user-facing functionality
    THEN → Flag for `features[]` update
    ```

    **Tech Stack Detection:**
    ```
    IF package.json or requirements.txt modified:
      - Diff dependencies
      - Identify new packages
    THEN → Flag for `platform_info` or `dependencies` update
    ```

    **Business Flow Detection:**
    ```
    IF new API endpoint or route handler:
      - Parse route definitions
      - Identify new business operations
    THEN → Flag for `technical_details.modules` update
    ```

32. CHANGE-ANALYZER: For DELETED files, check if they were in manifest:
    ```
    IF deleted file was referenced in manifest:
      - Check if feature still exists (other files)
      - Check if service was completely removed
    THEN → Flag for removal from manifest
    ```

33. CHANGE-ANALYZER: Generate change report:
    ```
    📋 Cambios detectados para el manifiesto:

    ➕ Agregar a features[]:
      • "Sistema de pagos" (src/features/payments/)
      • "Notificaciones push" (src/services/notifications.ts)

    ➕ Agregar a technical_details.modules:
      • "PaymentService" - Procesamiento de pagos con Stripe
      • "NotificationService" - Push notifications via Firebase

    ➕ Agregar a architecture_patterns_by_layer.Backend:
      • "Payment Gateway Integration"

    📦 Actualizar dependencies:
      • + stripe@12.0.0
      • + firebase-admin@11.0.0
      • - deprecated-lib@1.0.0 (eliminada)

    ➖ Remover de manifest:
      • "LegacyWidget" (archivo eliminado, feature deprecado)
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP A6: Apply Updates to Manifest**
**═══════════════════════════════════════════════════════════════════**

34. SUBAGENT: Show proposed changes for confirmation:
    ```
    📝 Cambios propuestos al manifiesto:

    ¿Deseas aplicar estos cambios? (Si/No/Revisar cada uno)
    ```

35. IF "Revisar cada uno":
    - Show each change individually
    - User approves/rejects each

36. IF "Si" or approved changes:
    - Update manifest JSON
    - Update `last_updated` to today's date
    - Update `llm_notes.is_up_to_date` to true
    - Validate against schema

37. SUBAGENT returns to MAIN AGENT

**═══════════════════════════════════════════════════════════════════**
**STEP A7: Success Message**
**═══════════════════════════════════════════════════════════════════**

38. MAIN AGENT (example in Spanish):
    ```
    ✅ ¡Manifiesto actualizado!

    📁 Archivo: ai_files/project_manifest.json
    📅 Nueva fecha: 2024-11-25

    📊 Resumen de actualizaciones:

    Features agregados: 2
      • Sistema de pagos
      • Notificaciones push

    Módulos agregados: 2
      • PaymentService
      • NotificationService

    Dependencias actualizadas: 3
      • +2 nuevas, -1 eliminada

    Features removidos: 1
      • LegacyWidget (deprecado)

    🎯 Próximo paso:

      Si agregaste nuevas capas de arquitectura, considera:
      /waves:rules-update

      Para documentar las convenciones del nuevo código.
    ```

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**FLUJO B: TIMESTAMP-BASED UPDATE (For Non-Git Projects)**
**═══════════════════════════════════════════════════════════════════**

> **Note:** This flow uses file modification timestamps instead of git history.
> Less precise but works for projects without version control.
> Primarily used for general projects (academic, creative, business).

**═══════════════════════════════════════════════════════════════════**
**STEP B1: Find Files Modified Since Last Update**
**═══════════════════════════════════════════════════════════════════**

39. MAIN AGENT: Invoke **timestamp-analyzer** subagent

40. SUBAGENT: Find modified files using terminal commands:
    ```bash
    # Find all files modified after last_updated date
    find . -type f -newermt "2024-11-15" ! -path "*/\.*" ! -path "*/node_modules/*"

    # Alternative: Get files with stat for more precise timestamps
    find . -type f -exec stat -f "%m %N" {} \; | sort -rn
    ```

41. SUBAGENT: Build list of recently modified files

**═══════════════════════════════════════════════════════════════════**
**STEP B2: Find New Files Created Since Last Update**
**═══════════════════════════════════════════════════════════════════**

42. SUBAGENT: Identify new files by creation date:
    ```bash
    # On macOS - get birth time (creation time)
    find . -type f -exec stat -f "%B %N" {} \; | awk -v date="$(date -j -f "%Y-%m-%d" "2024-11-15" +%s)" '$1 > date {print $2}'

    # On Linux - creation time less reliable, use ctime as approximation
    find . -type f -ctime -10  # files changed in last 10 days
    ```

43. SUBAGENT: Differentiate new vs modified:
    - Compare creation time vs modification time
    - If creation time > last_updated → New file
    - If only modification time > last_updated → Modified file

**═══════════════════════════════════════════════════════════════════**
**STEP B3: Limitation - Cannot Detect Deleted Files**
**═══════════════════════════════════════════════════════════════════**

44. SUBAGENT (example in Spanish):
    ```
    ⚠️ Nota: Sin Git no puedo detectar archivos eliminados.

    Si eliminaste archivos que estaban en el manifiesto,
    necesitarás revisarlos manualmente o usar:
    /waves:manifest-create (para regenerar desde cero)
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP B4: Display Change Summary**
**═══════════════════════════════════════════════════════════════════**

45. SUBAGENT (example in Spanish):
    ```
    📊 Análisis basado en fechas de archivos:

    📅 Período: 2024-11-15 → 2024-11-25

    ✏️ Archivos modificados (8):
      • documentos/capitulo-4.docx (modificado hace 2 días)
      • datos/encuesta-resultados.xlsx (modificado hace 5 días)
      • presentaciones/avance-tesis.pptx (modificado hoy)
      • ... y 5 más

    ➕ Archivos nuevos (3):
      • documentos/capitulo-5.docx (creado hace 3 días)
      • imagenes/grafico-resultados.png (creado hace 4 días)
      • referencias/nueva-fuente.pdf (creado ayer)

    ❓ Archivos eliminados: No detectables sin Git
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP B5: Analyze Changes for Manifest Update**
**═══════════════════════════════════════════════════════════════════**

46. SUBAGENT: Based on project type, analyze relevance:

    **For Academic (research_manifest):**
    - New .docx/.pdf in chapters/ → Update `structure.chapters`
    - New files in references/ → Update `academic_details.bibliography_sources`
    - Progress on milestones → Update `milestones[].status`

    **For Creative (creative_manifest):**
    - New images/designs → Update `assets[]`
    - New deliverable files → Update `deliverables[].status`

    **For Business (business_manifest):**
    - New documents → Update relevant sections
    - Financial spreadsheets → Note for KPIs update

    **For General (general_manifest):**
    - Track progress on objectives
    - Update deliverables status

47. SUBAGENT: Generate proposed updates

**═══════════════════════════════════════════════════════════════════**
**STEP B6: Apply Updates and Show Summary**
**═══════════════════════════════════════════════════════════════════**

48. SUBAGENT: Show proposed changes:
    ```
    📝 Cambios propuestos al manifiesto:

    Actualizar structure.chapters:
      • Agregar: "Capítulo 5: Conclusiones" (nuevo archivo)

    Actualizar milestones:
      • "Capítulo 4" → status: "completed" (archivo modificado extensivamente)
      • "Capítulo 5" → status: "in_progress" (archivo nuevo detectado)

    Actualizar academic_details.bibliography_sources:
      • +1 nueva referencia detectada

    ¿Deseas aplicar estos cambios? (Si/No)
    ```

49. IF "Si":
    - Update manifest
    - Update `last_updated`
    - Validate against schema

50. MAIN AGENT: Show success message (similar to STEP A7)

**Status:** ✅ DESIGNED

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

### **Git-based Flow Subagents:**

1. **git-history-analyzer**
   - Tools: Bash (git commands), Read
   - Responsibilities: Execute git commands to get history, commits, diffs
   - Output: Commit count, file change summary

2. **autogen-detector**
   - Tools: Read, Grep, Glob
   - Responsibilities: Parse .gitignore, detect framework, find codegen libraries
   - Output: List of patterns/files to ignore

3. **manifest-change-analyzer**
   - Tools: Read, Glob, Grep
   - Responsibilities: Analyze new/modified files against update criteria
   - Output: Proposed manifest changes with rationale

### **Timestamp-based Flow Subagents:**

4. **timestamp-analyzer**
   - Tools: Bash (find, stat), Read
   - Responsibilities: Find files by modification/creation date
   - Output: Categorized list of changed files

### **Shared Subagents:**

5. **manifest-updater**
   - Tools: Read, Write
   - Responsibilities: Apply approved changes to manifest, validate
   - Output: Updated manifest file

---

**═══════════════════════════════════════════════════════════════════**
**WORKFLOWS REQUIRED**
**═══════════════════════════════════════════════════════════════════**

1. `workflows/update/check-prerequisites.md`
   - Verify user_pref.json and manifest exist

2. `workflows/update/git-history-analysis.md`
   - Git commands for history extraction
   - Parse diff output

3. `workflows/update/autogen-detection.md`
   - Parse .gitignore
   - Framework-specific detection
   - Codegen library detection

4. `workflows/update/change-criteria-analysis.md`
   - Detailed criteria for each manifest field
   - Pattern matching for architectural changes

5. `workflows/update/timestamp-analysis.md`
   - Find commands for file dates
   - Cross-platform compatibility (macOS/Linux)

6. `workflows/update/apply-manifest-changes.md`
   - JSON update logic
   - Schema validation

---

**═══════════════════════════════════════════════════════════════════**
**GIT COMMANDS REFERENCE**
**═══════════════════════════════════════════════════════════════════**

```bash
# Get commits since date
git log --since="2024-11-15" --oneline

# Get commit count
git rev-list --count --since="2024-11-15" HEAD

# Get file changes with status (M/A/D/R)
git diff --name-status $(git rev-list -n1 --before="2024-11-15" HEAD)..HEAD

# Get diff stats
git diff --stat $(git rev-list -n1 --before="2024-11-15" HEAD)..HEAD

# Get last commit before date
git rev-list -n1 --before="2024-11-15" HEAD

# Check if file was in previous state
git show $(git rev-list -n1 --before="2024-11-15" HEAD):path/to/file
```

---

**═══════════════════════════════════════════════════════════════════**
**TIMESTAMP COMMANDS REFERENCE**
**═══════════════════════════════════════════════════════════════════**

```bash
# macOS - Find files modified after date
find . -type f -newermt "2024-11-15" ! -path "*/\.*"

# macOS - Get modification time in epoch
stat -f "%m %N" filename

# macOS - Get birth (creation) time
stat -f "%B %N" filename

# Linux - Find files modified after date
find . -type f -newermt "2024-11-15" ! -path "*/.*"

# Linux - Get modification time
stat -c "%Y %n" filename

# Cross-platform - Find and sort by date
find . -type f -exec ls -lt {} + | head -50
```

---

**Status:** ✅ DESIGNED (2 flows complete - Git-based, Timestamp-based)
