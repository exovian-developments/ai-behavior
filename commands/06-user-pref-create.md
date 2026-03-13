# Command: `/waves:user-pref-create`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Create complete user preferences file with ALL options from schema (advanced setup).

**Difference from `project-init`:**
- `project-init` → 5 essential questions + smart defaults
- `user-pref-create` → ALL preferences, detailed configuration

**Schema:** `ai_files/schemas/user_pref_schema.json`

**Output:** `ai_files/user_pref.json` (complete)

---

## Flow

```
STEP 0: Check if user_pref.json exists
        ├─ IF EXISTS → Warn: "Ya existe, ¿sobrescribir?"
        └─ IF NOT → Continue

STEP 1: Guided sections (one by one)

        📋 SECCIÓN 1: LLM Guidance
        "Configuremos cómo quieres que el LLM se comporte:"

        • explain_before_answering (true/false)
        • ask_before_assuming (true/false)
        • suggest_multiple_options (true/false)
        • allow_self_correction (true/false)
        • persistent_personality (true/false)
        • feedback_loop_enabled (true/false)

        📋 SECCIÓN 2: User Profile
        • name
        • communication_tone (formal/friendly_with_sarcasm/strict/custom)
        • emoji_usage (true/false)
        • preferred_language
        • technical_background
        • explanation_style
        • learning_style

        📋 SECCIÓN 3: Output Preferences
        • format_code_with_comments (true/false)
        • block_comment_tags (start/end)
        • code_language
        • use_inline_explanations (true/false)
        • highlight_gotchas (true/false)
        • response_structure (array of sections)

        📋 SECCIÓN 4: Project Context
        • project_type (software/general)
        • is_project_known_by_user (true/false)

STEP 2: Show summary of all selections

STEP 3: Generate user_pref.json

STEP 4: Success message
        "✅ Preferencias creadas! Para ajustes futuros:
         /waves:user-pref-update"
```

---

## Question Format

For each option, show current default and ask:

```
📌 explain_before_answering
   Descripción: El LLM explica su razonamiento antes de responder
   Valor por defecto: true

   ¿Mantener default o cambiar? (Enter para mantener, o escribe true/false):
```

---

**Status:** ✅ DESIGNED
