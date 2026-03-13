# Command: `/waves:user-pref-update`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Allow user to update their preferences by opening the file in system's default text editor.

**Why this approach:**
- No interactive UI available in CLI
- JSON is human-readable
- User has full control over all options
- System editors handle JSON well (VS Code, TextEdit, nano, vim)

**Input:** Existing `ai_files/user_pref.json`

**Output:** User-modified `ai_files/user_pref.json`

---

## Flow

```
STEP 0: Check user_pref.json exists
        └─ IF NOT → Error: "Run /waves:project-init first"

STEP 1: Show current configuration summary
        ┌─────────────────────────────────────────┐
        │ 📋 Tu configuración actual:             │
        │                                         │
        │ Idioma: Español                         │
        │ Tono: Amistoso con humor                │
        │ Explicaciones: Balanceado               │
        │ Emojis: Sí                              │
        │ ...                                     │
        └─────────────────────────────────────────┘

STEP 2: Offer to open in editor
        "¿Quieres abrir el archivo para editarlo?

         Se abrirá con tu editor de texto predeterminado.
         Guarda los cambios cuando termines.

         (Si/No)"

STEP 3: IF Si → Open file with system command
        ├─ macOS: open ai_files/user_pref.json
        ├─ Linux: xdg-open ai_files/user_pref.json
        └─ Windows: start ai_files/user_pref.json

STEP 4: Wait message
        "📝 Editando preferencias...

         Guarda el archivo cuando termines y presiona Enter aquí
         para validar los cambios."

STEP 5: User presses Enter → Validate JSON
        ├─ IF valid → "✅ Preferencias actualizadas!"
        ├─ IF invalid JSON → Show error, offer to re-edit
        └─ IF schema violation → Show what's wrong

STEP 6: Remind to restart session
        "⚠️ Reinicia tu sesión de Claude Code para aplicar
         los cambios al CLAUDE.md"
```

---

## Alternative: Show editable fields inline

If user prefers not to open editor:

```
"¿Prefieres editar aquí directamente?

Escribe el nombre del campo a cambiar:
• communication_tone
• emoji_usage
• explanation_style
• preferred_language
..."

User: "communication_tone"

"Valor actual: friendly_with_sarcasm
 Opciones: formal, friendly_with_sarcasm, strict, [custom]

 Nuevo valor:"

User: "formal"

"✅ communication_tone actualizado a 'formal'
 ¿Cambiar otro campo? (Si/No)"
```

---

**Status:** ✅ DESIGNED
