# Command: `/ai-behavior:resolution-create [logbook]`

**Status:** ✅ DESIGNED

**Applies to:** Software projects only

---

## Overview

**Purpose:** Generate a resolution document from a software development logbook, documenting what was accomplished, code changes, and technical learnings.

**Schema:** `ai_files/schemas/ticket_resolution_schema.json`

**Input:** Logbook file (parameter or selection) - must be from a software project

**Output:** Resolution markdown file in `ai_files/resolutions/`

**Parameters:** `[logbook]` (optional) - Logbook filename to use

**Note:** For general projects, the logbook itself serves as documentation. Use `/ai-behavior:logbook-update` to mark objectives as achieved and add final context entries.

---

## Flow

```
STEP 0: Determine which logbook to use

        IF parameter provided:
           └─ Use specified logbook: /ai-behavior:resolution-create mi-feature.json

        IF NO parameter:
           └─ Check if working on a logbook in current session
              ├─ IF yes → Confirm: "¿Usar logbook 'mi-feature.json'?"
              └─ IF no → List available logbooks

STEP 1: List logbooks (if needed)
        ┌─────────────────────────────────────────┐
        │ 📚 Bitácoras disponibles:               │
        │                                         │
        │ 1. auth-implementation.json (5 días)    │
        │ 2. payment-feature.json (2 días)        │
        │ 3. bug-fix-login.json (1 día)           │
        │                                         │
        │ Elige 1-3:                              │
        └─────────────────────────────────────────┘

STEP 2: Read and analyze logbook
        └─ Extract: objectives, findings, decisions, blockers resolved

STEP 3: Generate resolution document
        ┌─────────────────────────────────────────┐
        │ # Resolution: Auth Implementation       │
        │                                         │
        │ **Date:** 2024-11-25                    │
        │ **Duration:** 5 days                    │
        │ **Logbook:** auth-implementation.json   │
        │                                         │
        │ ## Summary                              │
        │ Implemented OAuth2 authentication...    │
        │                                         │
        │ ## Objectives Completed                 │
        │ - [x] User login with Google            │
        │ - [x] Session management                │
        │ - [x] Protected routes                  │
        │                                         │
        │ ## Key Decisions                        │
        │ - Used NextAuth.js over custom impl     │
        │ - JWT tokens stored in httpOnly cookies │
        │                                         │
        │ ## Challenges & Solutions               │
        │ 1. Token refresh issue → Added retry    │
        │                                         │
        │ ## Learnings                            │
        │ - NextAuth simplifies OAuth flow...     │
        │                                         │
        │ ## Files Modified                       │
        │ - src/auth/[...nextauth].ts            │
        │ - src/middleware.ts                     │
        └─────────────────────────────────────────┘

STEP 4: Show preview and confirm
        "¿Guardar esta resolución? (Si/No/Editar)"

STEP 5: Save file
        └─ ai_files/resolutions/auth-implementation-resolution.md

STEP 6: Success message
        "✅ Resolución creada!

         📁 Archivo: ai_files/resolutions/auth-implementation-resolution.md

         💡 Tip: Esta resolución servirá como referencia futura
         para problemas similares."
```

---

## Output Naming Convention

```
Logbook: auth-implementation.json
Resolution: auth-implementation-resolution.md

Logbook: bug-fix-login.json
Resolution: bug-fix-login-resolution.md
```

---

## Prerequisites

1. Check `user_pref.json` exists
2. Check `project_context.project_type === "software"`
   - IF NOT software → Show message:
     ```
     ⚠️ Este comando es solo para proyectos de software.

     Para proyectos generales, tu bitácora ya documenta el progreso.
     Usa /ai-behavior:logbook-update para marcar objetivos como completados
     y agregar entradas finales de contexto.
     ```
     → **EXIT COMMAND**

---

**Status:** ✅ DESIGNED
