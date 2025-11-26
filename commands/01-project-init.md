# Command: `/ai-behavior:project-init`

**Status:** ✅ DESIGNED (UPDATED with project context)

---

## Overview

**Purpose:** Quick essential setup - Create `ai_files/user_pref.json` with interaction preferences AND project context for ai-behavior commands

**Schema:** `ai_files/schemas/user_pref_schema.json` (extended with project context fields)

**Output:**
- `ai_files/user_pref.json` (enhanced with project type and familiarity)
- Updated `CLAUDE.md` (prepends user preferences reference)

**Parameters:** None (always interactive)

---

## Configuration + Essential Questions (5 questions total)

**Configuration (not counted as question):**
- **Language** - User types preferred language (free text with examples)

**Questions:**
1. **Name + Role** - User name and role in project (with fallback if role not provided)
2. **Project Type** - Software or General (non-software)
3. **Project Familiarity** - Known or Unknown to user
4. **Communication Tone** - Free text with examples
5. **Explanation Style** - Free text with examples

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
   👋 Welcome to ai-behavior!

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
   - IF "1" → Exit with message: "No se efectuaron cambios en la configuración existente. Usa /ai-behavior:user-pref-create para ajustes más avanzados."
   - IF "2" → Continue to next step

7. IF NOT EXISTS → Continue to next step (no message needed)

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Command Explanation and Confirmation (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

8. MAIN AGENT (en español):
   ```
   📘 Comando: /ai-behavior:project-init

   Este comando configura tus preferencias esenciales para trabajar con ai-behavior.
   Te haré 5 preguntas para configurar cómo interactúo contigo y entender tu proyecto.

   ¿Deseas continuar? (Si/No)
   ```

9. IF NO → Exit

10. IF SI, MAIN AGENT (en español):
    ```
    ✓ Continuando...

    Resumen de ejecución:
    1. Proporcionar tu nombre y rol
    2. Especificar tipo de proyecto y familiaridad
    3. Elegir tono de comunicación y estilo de explicación
    4. Generar user_pref.json con valores por defecto inteligentes
    5. Actualizar CLAUDE.md para referenciar preferencias

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
**QUESTION 4: Communication Tone (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

21. SUBAGENT (en español):
    ```
    💬 ¿Cómo prefieres que me comunique contigo?

    Ejemplos:
    • 'Profesional' - Respetuoso y enfocado
    • 'Amistoso con humor' - Cercano con toques de sarcasmo
    • 'Directo' - Sin rodeos, al punto
    • O describe tu preferencia con tus propias palabras

    Escribe tu preferencia:
    ```

22. USER: "Amistoso con humor" or "friendly but professional" or custom description

23. SUBAGENT: Stores `communication_tone`
    - Parse and normalize user input
    - Store as-is or map to known values (formal, friendly_with_sarcasm, strict, custom)

**═══════════════════════════════════════════════════════════════════**
**QUESTION 5: Explanation Style (IN USER'S LANGUAGE)**
**═══════════════════════════════════════════════════════════════════**

24. SUBAGENT (en español):
    ```
    📚 ¿Qué nivel de detalle prefieres en mis explicaciones?

    Ejemplos:
    • 'Directo' - Respuestas cortas sin explicaciones adicionales
    • 'Balanceado' - Explicación con contexto técnico relevante
    • 'Modo enseñanza' - Explico cada paso en profundidad
    • O describe tu preferencia con tus propias palabras

    Escribe tu preferencia:
    ```

25. USER: "Balanceado" or "explain but keep it concise" or custom description

26. SUBAGENT: Stores `explanation_style`
    - Parse and normalize user input
    - Store as-is or map to known values (direct, balanced, teaching_mode, custom)

**═══════════════════════════════════════════════════════════════════**
**STEP 4: Generate Configuration**
**═══════════════════════════════════════════════════════════════════**

27. SUBAGENT (en español):
    ```
    ⚙️ Generando tu configuración...

    Las siguientes preferencias se configuran con valores por defecto.
    Puedes ajustarlas después con: /ai-behavior:user-pref-create

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

28. SUBAGENT: Auto-detect `code_language` from project files (if software project)

29. SUBAGENT: Generate `ai_files/user_pref.json` with:
    - User's answers (language + 5 questions)
    - Smart defaults for remaining fields
    - **NEW:** `project_type` (software/general)
    - **NEW:** `is_project_known_by_user` (true/false)

30. SUBAGENT: Validate against schema

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Update CLAUDE.md**
**═══════════════════════════════════════════════════════════════════**

31. SUBAGENT: Check if `CLAUDE.md` exists

32. IF EXISTS:
    - Read current contents
    - Prepend user preferences reference at the top:
      ```markdown
      # User Preferences

      Read and follow user preferences from: ai_files/user_pref.json

      ---

      [Original CLAUDE.md content continues below...]
      ```

33. IF NOT EXISTS:
    - Create new `CLAUDE.md` with:
      ```markdown
      # User Preferences

      Read and follow user preferences from: ai_files/user_pref.json
      ```

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Success Message and Next Steps**
**═══════════════════════════════════════════════════════════════════**

34. SUBAGENT returns to MAIN AGENT

35. MAIN AGENT (en español):
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
      • Familiaridad: Nuevo para ti
      • Tono: Amistoso + Humor negro
      • Explicaciones: Con contexto técnico
      • Lenguaje del proyecto: TypeScript (detectado)

    📋 Preferencias por defecto aplicadas:
      • LLM Behavior: All enabled
      • Output: Code with comments, highlight gotchas

    💡 Tip: Ajusta preferencias avanzadas con /ai-behavior:user-pref-create

    ⚠️ IMPORTANTE: Reinicia tu sesión de Claude Code para cargar las nuevas preferencias.
    ```

**═══════════════════════════════════════════════════════════════════**
**STEP 7: Final Summary and Next Command (Standard Pattern)**
**═══════════════════════════════════════════════════════════════════**

36. MAIN AGENT (en español):
    ```
    ✅ Resultado: Preferencias de usuario configuradas y listas para usar.

    📁 Archivos generados:
      • ai_files/user_pref.json
      • CLAUDE.md (actualizado)

    🎯 Paso siguiente:

      Después de reiniciar Claude Code, ejecuta:
      /ai-behavior:manifest-create

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
  • Tono: Amistoso + Humor negro
  • Explicaciones: Con contexto técnico
  • Lenguaje del proyecto: TypeScript (detectado)

📋 Preferencias por defecto aplicadas:
  [Lista completa de defaults...]

💡 Tip: Ajusta preferencias avanzadas con /ai-behavior:user-pref-create

⚠️ IMPORTANTE: Reinicia tu sesión de Claude Code para cargar las nuevas preferencias.

Después de reiniciar, continúa con:
  /ai-behavior:manifest-create
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
    "is_project_known_by_user": false
  }
}
```

---

## Implementation Requirements

**Subagent:** `project-initializer`
- **Tools:** Read, Write, Bash
- **Responsibilities:**
  - Conduct 6 essential questions (2 new: project_type, familiarity)
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
