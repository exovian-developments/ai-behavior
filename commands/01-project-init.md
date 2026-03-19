# Command: `/waves:project-init`

**Status:** ✅ DESIGNED (UPDATED with project context)

---

## Overview

**Purpose:** Quick essential setup - Create `ai_files/user_pref.json` with interaction preferences AND project context for waves commands

**Schema:** `ai_files/schemas/user_pref_schema.json` (extended with project context fields)

**Output:**
- `ai_files/user_pref.json` (enhanced with project type, familiarity, and project state)
- Updated `CLAUDE.md` (prepends user preferences reference)

**Parameters:** None (always interactive)

---

## Configuration + Essential Questions (6 questions total)

**Configuration (not counted as question):**
- **Language** - User types preferred language (free text with examples)

**Questions:**
1. **Name + Role** - User name and role in project (with fallback if role not provided)
2. **Project Type** - Software or General (non-software)
3. **Project Familiarity** - Known or Unknown to user
4. **Project State** - New (from scratch) or Existing (codebase present)
5. **Communication Tone** - Free text with examples
6. **Explanation Style** - Free text with examples

---

## Default Values Applied (shown to user)

```
LLM Behavior:
  • explain_before_answering: true
  • ask_before_assuming: true
  • suggest_multiple_options: true
  • allow_self_correction: true
  • persistent_personality: true
  • feedback_loop_enabled: true

User Profile:
  • emoji_usage: true
  • learning_style: explicative

Output Preferences:
  • format_code_with_comments: true
  • block_comment_tags: {start: '/*', end: '*/'}
  • code_language: (auto-detected from project)
  • use_inline_explanations: false
  • highlight_gotchas: true
  • response_structure: [all options]
```

---

## Detailed Flow

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Language Configuration (ALWAYS IN ENGLISH - FIRST INTERACTION)**
**═══════════════════════════════════════════════════════════════════**

1. MAIN AGENT (in English):
   ```
   👋 Welcome to waves!

   🌍 What language do you prefer for our conversations?

   Examples: English, Español, Português, Français, Deutsch, Italiano, 日本語, 中文, etc.

   Type your preferred language:
   ```

2. USER: "Español" or "Spanish" or "es"

3. MAIN AGENT: Parse and normalize language
   - Stores `preferred_language` (normalized to ISO code if possible, otherwise as-is)
   - Confirms: "✓ Language set to: Español"

4. **SWITCH TO USER'S LANGUAGE** for all remaining interactions

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Check Existing Configuration (IN USER'S SELECTED LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

5. MAIN AGENT: Check if `ai_files/user_pref.json` exists

6. IF EXISTS → MAIN AGENT (en español):
   ```
   ⚠️ Ya existe una configuración de proyecto en este directorio, si continúas se sobreescribirá!

   Ya existe una configuración de preferencias en este proyecto.

   Opciones:
   1. Detener esta ejecución (Salir)
   2. Continuar (sobrescribe el archivo)

   Elige 1 o 2:
   ```
   - IF "1" → Exit with message: "No se efectuaron cambios en la configuración existente. Usa /waves:user-pref-create para ajustes más avanzados."
   - IF "2" → Continue to next step

7. IF NOT EXISTS → Continue to next step (no message needed)

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Command Explanation and Confirmation (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

8. MAIN AGENT (en español):
   ```
   📘 Comando: /waves:project-init

   Este comando configura tus preferencias esenciales para trabajar con waves.
   Te haré 6 preguntas para configurar cómo interactúo contigo y entender tu proyecto.

   ¿Deseas continuar? (Si/No)
   ```

9. IF NO → Exit

10. IF SI, MAIN AGENT (en español):
    ```
    ✓ Continuando...

    Resumen de ejecución:
    1. Proporcionar tu nombre y rol
    2. Especificar tipo de proyecto y familiaridad
    3. Indicar si el proyecto es nuevo (desde cero) o existente
    4. Elegir tono de comunicación y estilo de explicación
    5. Generar user_pref.json con valores por defecto inteligentes
    6. Actualizar CLAUDE.md para referenciar preferencias

    Este comando creará: ai_files/user_pref.json + CLAUDE.md actualizado
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Invoke Subagent and Start Questions**
**═══════════════════════════════════════════════════════════════════**

11. Invoke **project-initializer** subagent

**═══════════════════════════════════════════════════════════════════**
**QUESTION 1: Name + Role (IN USER'S SELECTED LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

12. SUBAGENT (en español):
    ```
    👤 ¿Cuál es tu nombre y rol en este proyecto?

    Ejemplo: 'Alex - Senior Frontend Developer'
             'María - Investigadora Principal'
             'João - Product Manager'
    ```

13. USER: "Alex - Senior Frontend Developer" or just "Alex"

14. SUBAGENT: Parse response with fallback
    - Try to split by "-" or similar separators
    - IF role detected:
      - `name = "Alex"`
      - `technical_background = "Senior Frontend Developer"`
    - IF role NOT detected (user only provided name):
      - `name = parsed_input`
      - **FALLBACK QUESTION:**
        ```
        👤 ¿Cuál es tu rol o especialidad en este proyecto?

        Ejemplo: 'Senior Frontend Developer', 'Investigador', 'Product Manager', 'Estudiante'
        ```
      - USER: "Senior Frontend Developer"
      - `technical_background = user_response`

**═══════════════════════════════════════════════════════════════════**
**QUESTION 2: Project Type (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

15. SUBAGENT (en español):
    ```
    🎯 ¿Qué tipo de proyecto es este?

    1. Proyecto de software - Aplicación, API, sistema, código
    2. Proyecto general - Investigación, negocio, creativo, académico, otro

    Elige 1 o 2:
    ```

16. USER: "1"

17. SUBAGENT: Stores `project_type = "software"`
    - If "1" → `project_type = "software"`
    - If "2" → `project_type = "general"`

**═══════════════════════════════════════════════════════════════════**
**QUESTION 3: Project Familiarity (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

18. SUBAGENT (en español):
    ```
    📚 ¿Qué tan familiarizado estás con este proyecto?

    1. Lo conozco bien - Sé cómo está estructurado y qué tecnologías usa
    2. Es nuevo para mí - Necesito explorarlo y entenderlo desde cero

    Elige 1 o 2:
    ```

19. USER: "2"

20. SUBAGENT: Stores `is_project_known_by_user = false`
    - If "1" → `is_project_known_by_user = true`
    - If "2" → `is_project_known_by_user = false`

**═══════════════════════════════════════════════════════════════════**
**QUESTION 4: Project State (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

21. SUBAGENT (en español):
    ```
    🆕 ¿Este proyecto es nuevo (desde cero) o existente (ya tiene código)?

    1. Proyecto nuevo / desde cero (sin base de código)
    2. Proyecto existente (ya tiene código)

    Elige 1 o 2:
    ```

22. USER: "1" or "2"

23. SUBAGENT: Stores `is_project_from_scratch`
    - If "1" → `is_project_from_scratch = true`
    - If "2" → `is_project_from_scratch = false`

**═══════════════════════════════════════════════════════════════════**
**QUESTION 5: Communication Tone (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

24. SUBAGENT (en español):
    ```
    💬 ¿Cómo prefieres que me comunique contigo?

    Ejemplos:
    • 'Profesional' - Respetuoso y enfocado
    • 'Amistoso con humor' - Cercano con toques de sarcasmo
    • 'Directo' - Sin rodeos, al punto
    • O describe tu preferencia con tus propias palabras

    Escribe tu preferencia:
    ```

25. USER: "Amistoso con humor" or "friendly but professional" or custom description

26. SUBAGENT: Stores `communication_tone`
    - Parse and normalize user input
    - Store as-is or map to known values (formal, friendly_with_sarcasm, strict, custom)

**═══════════════════════════════════════════════════════════════════**
**QUESTION 6: Explanation Style (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

30. SUBAGENT (en español):
    ```
    📚 ¿Qué nivel de detalle prefieres en mis explicaciones?

    Ejemplos:
    • 'Directo' - Respuestas cortas sin explicaciones adicionales
    • 'Balanceado' - Explicación con contexto técnico relevante
    • 'Modo enseñanza' - Explico cada paso en profundidad
    • O describe tu preferencia con tus propias palabras

    Escribe tu preferencia:
    ```

28. USER: "Balanceado" or "explain but keep it concise" or custom description

29. SUBAGENT: Stores `explanation_style`
    - Parse and normalize user input
    - Store as-is or map to known values (direct, balanced, teaching_mode, custom)

**═══════════════════════════════════════════════════════════════════**
**STEP 4: Generate Configuration**
**═══════════════════════════════════════════════════════════════════**

27. SUBAGENT (en español):
    ```
    ⚙️ Generando tu configuración...

    Las siguientes preferencias se configuran con valores por defecto.
    Puedes ajustarlas después con: /waves:user-pref-create

    📋 Valores por defecto aplicados:

    LLM Behavior:
      • explain_before_answering: true
      • ask_before_assuming: true
      • suggest_multiple_options: true
      • allow_self_correction: true
      • persistent_personality: true
      • feedback_loop_enabled: true

    User Profile:
      • emoji_usage: true
      • learning_style: explicative

    Output Preferences:
      • format_code_with_comments: true
      • block_comment_tags: {start: '/*', end: '*/'}
      • code_language: (detectado del proyecto)
      • use_inline_explanations: false
      • highlight_gotchas: true
      • response_structure: [explanation, options_if_applicable, code_or_solution, summary_or_next_step]
    ```

31. SUBAGENT: Auto-detect `code_language` from project files (if software project)

32. SUBAGENT: Generate `ai_files/user_pref.json` with:
    - User's answers (language + 6 questions)
    - Smart defaults for remaining fields
    - **NEW:** `project_type` (software/general)
    - **NEW:** `is_project_known_by_user` (true/false)
    - **NEW:** `is_project_from_scratch` (true/false)

33. SUBAGENT: Validate against schema

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Update CLAUDE.md**
**═══════════════════════════════════════════════════════════════════**

34. SUBAGENT: Check if `CLAUDE.md` exists

35. IF EXISTS:
    - Read current contents
    - Prepend the Waves framework training block at the top:
      ```markdown
      # Waves Framework — Agent Operating Protocol

      This project uses the **Waves** product development framework. As an AI agent, you are a team member — not a tool. These instructions define how you operate within the framework.

      ## Core Philosophy

      Waves replaces fixed-cadence methodologies (Scrum sprints) with organic, variable-length delivery cycles called **waves**. Each wave carries a product increment from validation to production. You, as an AI agent, must work WITH the framework — reading its artifacts, following its order, and alerting when something is missing or misaligned.

      **The Golden Rule:** Nothing exists in the project that is not supported in the product blueprint. If you're about to build something that can't trace to the blueprint, STOP and ask the user.

      ## User Preferences

      Read `ai_files/user_pref.json` at session start. Follow the language, tone, and explanation depth configured there.

      ## Directory Structure

      ```
      ai_files/
      ├── user_pref.json              ← Your interaction settings
      ├── project_manifest.json       ← Technical project map
      ├── project_rules.json          ← Coding rules you MUST follow
      ├── schemas/                    ← JSON schemas for validation
      │
      ├── feasibility.json            ← Is this idea viable? (Sub-Zero)
      ├── foundation.json             ← Validated facts from feasibility (Sub-Zero)
      ├── blueprint.json              ← WHAT we're building and WHY (W0)
      │
      └── waves/                      ← Delivery cycles
          ├── sub-zero/               ← Validation / Knowledge wave
          │   ├── roadmap.json
          │   └── logbooks/
          ├── w0/                     ← Definition wave
          │   ├── roadmap.json
          │   └── logbooks/
          └── wN/                     ← Business waves (w1, w2, ...)
              ├── roadmap.json        ← WHEN and in what ORDER
              ├── logbooks/           ← HOW each ticket gets done
              └── resolutions/        ← What was accomplished
      ```

      ## Artifact Hierarchy

      ```
      blueprint.json                      ← Source of truth for the product
        └── product_roadmaps[]            ← Links to all wave roadmaps
             └── waves/wN/roadmap.json    ← Plan for this wave
                  └── logbooks/*.json     ← Implementation detail per ticket
      ```

      Information flows DOWNWARD. Never duplicate detail upward. If you need strategic context in a logbook, REFERENCE the roadmap — don't copy from it.

      ## How You Must Operate

      ### At Session Start
      1. Read `ai_files/user_pref.json` — respect language and tone
      2. Read `ai_files/blueprint.json` — understand what the product IS
      3. Read `ai_files/project_rules.json` — know what rules to follow when writing code
      4. Scan `ai_files/waves/` — identify which wave is active (look for roadmaps with status "active" or "in_progress")

      ### Before Any Task
      1. **Check the blueprint exists.** If not → tell the user: "There's no product blueprint. I recommend running `/waves:blueprint-create` before we start building — otherwise I don't have context on what this product is."
      2. **Check an active roadmap exists.** If not → tell the user: "There's no roadmap for the current wave. Consider `/waves:roadmap-create` to plan the work."
      3. **Check a logbook exists for the task.** Look in the active wave's `logbooks/`. If not → suggest: "I don't see a logbook tracking this task. Want me to run `/waves:logbook-create` so we track objectives and progress?"

      ### During Work
      1. **Follow project_rules.json** when writing code — these are non-negotiable coding standards extracted from the project
      2. **Reference the blueprint** when discussing features — mention which capability you're supporting
      3. **Update the logbook** when completing objectives or making decisions — context entries preserve institutional knowledge
      4. **Check the roadmap** to understand priorities and dependencies before starting a new milestone

      ### When Something Doesn't Fit
      - If you're asked to build something that **doesn't trace to any blueprint capability** → alert: "This work doesn't appear in the blueprint. Should we add it via a Blueprint Refinement, or is this out of scope?"
      - If a logbook objective **contradicts** the roadmap or blueprint → alert and ask for clarification
      - If you find **missing artifacts** (no rules, no manifest) → recommend creating them: "I'd do better work if I had the project rules. Want to run `/waves:rules-create`?"

      ## Wave Order

      Don't skip steps. If the user asks you to implement code but there's no blueprint, don't just start coding — explain what's missing and why it matters.

      | Wave | Purpose | What gets created |
      |------|---------|-------------------|
      | **Sub-Zero** | Validate the idea | `feasibility.json` → `foundation.json` |
      | **W0** | Define the product | `blueprint.json` → first `roadmap.json` → `project_manifest.json` → `project_rules.json` |
      | **W1+** | Build and ship | `logbooks` → code → `resolutions` → deploy |

      ## Available Commands

      | Command | When to use it |
      |---------|---------------|
      | `/waves:project-init` | First time setting up Waves in a project |
      | `/waves:feasibility-analyze` | Before committing to build something |
      | `/waves:foundation-create` | After feasibility, before blueprint |
      | `/waves:blueprint-create` | To define WHAT the product is |
      | `/waves:roadmap-create` | To plan a wave (WHEN and ORDER) |
      | `/waves:logbook-create` | To start tracking a ticket/task |
      | `/waves:logbook-update` | To record progress, decisions, status changes |
      | `/waves:objectives-implement` | To execute logbook objectives with code |
      | `/waves:roadmap-update` | To record progress and decisions in the roadmap |
      | `/waves:resolution-create` | To summarize what was done when a logbook completes |
      | `/waves:manifest-create` | To analyze the project technically |
      | `/waves:manifest-update` | To refresh the manifest after changes |
      | `/waves:rules-create` | To extract coding standards from the codebase |
      | `/waves:rules-update` | To refresh rules after code evolution |

      ## What Makes You a Good Waves Agent

      - You **read before you act** — blueprint, rules, roadmap, logbook
      - You **alert on gaps** — missing artifacts, untracked work, misaligned tasks
      - You **follow the order** — don't skip from idea to code without the intermediate artifacts
      - You **reference artifacts** — "This implements capability #3 from the blueprint" instead of just "I added the feature"
      - You **preserve context** — update logbooks with decisions and learnings so the next session (or the next agent) doesn't start blind
      - You **don't invent** — if the blueprint doesn't mention it, ask before building it

      ---

      [Original CLAUDE.md content continues below...]
      ```

36. IF NOT EXISTS:
    - Create new `CLAUDE.md` with the same Waves framework training block (without the "[Original CLAUDE.md content continues below...]" line)

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

37. SUBAGENT returns to MAIN AGENT

38. MAIN AGENT (en español):
    ```
    ✅ ¡Configuración completada!

    📁 Archivos actualizados:
      • ai_files/user_pref.json (creado)
      • CLAUDE.md (actualizado con referencia a preferencias)

    Tu configuración:
      • Nombre: Alex
      • Rol: Senior Frontend Developer
      • Idioma: Español
      • Tipo de proyecto: Software
      • Estado: Nuevo (desde cero)
      • Familiaridad: Nuevo para ti
      • Tono: Amistoso + Humor negro
      • Explicaciones: Con contexto técnico
      • Lenguaje del proyecto: TypeScript (detectado)

    📋 Preferencias por defecto aplicadas:
      • LLM Behavior: All enabled
      • Output: Code with comments, highlight gotchas

    💡 Tip: Ajusta preferencias avanzadas con /waves:user-pref-create

    ⚠️ IMPORTANTE: Reinicia tu sesión de Claude Code para cargar las nuevas preferencias.
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 7: Final Summary and Next Command (Standard Pattern)**
**═══════════════════════════════════════════════════════════════════**

39. MAIN AGENT (en español):
    ```
    ✅ Resultado: Preferencias de usuario configuradas y listas para usar.

    📁 Archivos generados:
      • ai_files/user_pref.json
      • CLAUDE.md (actualizado)

    🎯 Paso siguiente:

      Después de reiniciar Claude Code, ejecuta:
      /waves:manifest-create

      Este comando analizará tu proyecto y creará un manifiesto completo
      con su estructura, tecnologías y arquitectura.
    ```

END

---

## Output Examples

**Success Message Example (Spanish):**
```
✅ ¡Configuración completada!

📁 Archivos actualizados:
  • ai_files/user_pref.json (creado)
  • CLAUDE.md (actualizado con referencia a preferencias)

Tu configuración:
  • Nombre: Alex
  • Rol: Senior Frontend Developer
  • Idioma: Español
  • Tipo de proyecto: Software
  • Estado: Nuevo (desde cero)
  • Tono: Amistoso + Humor negro
  • Explicaciones: Con contexto técnico
  • Lenguaje del proyecto: TypeScript (detectado)

📋 Preferencias por defecto aplicadas:
  [Lista completa de defaults...]

💡 Tip: Ajusta preferencias avanzadas con /waves:user-pref-create

⚠️ IMPORTANTE: Reinicia tu sesión de Claude Code para cargar las nuevas preferencias.

Después de reiniciar, continúa con:
  /waves:manifest-create
```

**Enhanced user_pref.json Structure (NEW FIELDS):**
```json
{
  "version": "1.0",
  "llm_guidance": { ... },
  "user_profile": {
    "name": "Alex",
    "communication_tone": "friendly_with_sarcasm",
    "emoji_usage": true,
    "preferred_language": "es",
    "technical_background": "Senior Frontend Developer",
    "explanation_style": "explained with relevant technical details",
    "learning_style": "explicative"
  },
  "output_preferences": { ... },
  "project_context": {
    "project_type": "software",
    "is_project_known_by_user": false,
    "is_project_from_scratch": true
  }
}
```

---

## Implementation Requirements

**Subagent:** `project-initializer`
- **Tools:** Read, Write, Bash
- **Responsibilities:**
  - Conduct 7 essential prompts (language + 6 questions; 3 project context: type, familiarity, state)
  - Switch language after Q1
  - Auto-detect code_language (if software project)
  - Generate JSON with smart defaults + project context
  - Validate against schema
  - Check and update CLAUDE.md
  - Provide multilingual success message

**Workflows:**
- `workflows/initialization/check-existing-preferences.md`
- `workflows/initialization/gather-essential-prefs.md` (updated: 6 questions)
- `workflows/initialization/detect-code-language.md`
- `workflows/initialization/generate-user-pref-with-context.md` (NEW: includes project_context)
- `workflows/initialization/update-claude-md.md`
- `workflows/initialization/show-completion-message.md`
