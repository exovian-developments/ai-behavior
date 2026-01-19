# Command: `/ai-behavior:implement [logbook]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Execute implementation of logbook objectives with automatic code auditing and compliance verification loop.

**Flow:**
1. Select logbook →
2. Select objective →
3. Implementer subagent writes code →
4. Auditor subagent verifies compliance →
5. If non-compliant, loop back with fixes →
6. Update logbook with progress

**Parameters:** `[logbook]` (optional) - Name of the logbook file

**Key Features:**
- Interactive logbook selection if not provided
- Shows available logbooks with last modified date
- Implements code following project rules
- Automatic compliance auditing
- Retry loop for non-compliant code
- Progress updates visible to user
- Updates logbook context on completion

---

## Subagents

| Subagent | Purpose |
|----------|---------|
| **code-implementer** | Reads rules, manifest, objective; writes code; generates change manifest |
| **code-auditor** | Validates changes against project rules; returns compliance report |

---

## Artifacts

| Artifact | Purpose |
|----------|---------|
| **change_manifest** | JSON object passed from implementer → main → auditor |

---

**═══════════════════════════════════════════════════════════════════**
**FLOW - ENTRY POINT**
**═══════════════════════════════════════════════════════════════════**

## Step -1: Prerequisites Check

1. MAIN AGENT: Check if `ai_files/user_pref.json` exists

2. IF NOT EXISTS → MAIN AGENT (in English as fallback):
   ```
   ⚠️ Missing configuration!

   Please run first:
   /ai-behavior:project-init

   This command requires user preferences to be configured.
   ```
   → **EXIT COMMAND**

3. IF EXISTS → Read `preferred_language`, `project_context.project_type`

4. IF `project_type !== "software"`:
   ```
   ⚠️ This command is only available for software projects.

   Your project is configured as: [project_type]

   To change this, run:
   /ai-behavior:project-init
   ```
   → **EXIT COMMAND**

5. Check if `ai_files/project_manifest.json` exists
   - IF NOT EXISTS → Error: "Run /ai-behavior:manifest-create first"
   → **EXIT COMMAND**

**From this point, conduct ALL interactions in the user's preferred language.**

---

## Step 0: Command Explanation (First time only)

Check if user has used this command before (can store in user_pref or check context).

IF first time:
```
📘 Command: /ai-behavior:implement

This command helps you implement objectives from your logbook:

1. 📋 Select a logbook and objective
2. 🤖 An AI agent implements the code following your project rules
3. 🔍 Another AI agent audits compliance with rules
4. 🔄 If issues found, automatically fixes and re-audits
5. ✅ Updates your logbook with progress

Continue? (Yes/No)
```

IF No → Exit

---

## Step 1: Logbook Selection

### Step 1.1: Check Parameter

IF logbook parameter provided:
- Validate file exists: `ai_files/logbooks/[logbook]`
- IF NOT EXISTS:
  ```
  ⚠️ Logbook not found: [logbook]
  ```
  → Go to Step 1.2

- IF EXISTS → Load logbook, go to Step 2

### Step 1.2: List Available Logbooks

Scan `ai_files/logbooks/` directory.

IF empty:
```
📂 No logbooks found in ai_files/logbooks/

To create a logbook for your task, run:
  /ai-behavior:logbook-create [filename]

Example:
  /ai-behavior:logbook-create TICKET-123.json

A logbook helps you:
• Define clear objectives for your task
• Track progress across sessions
• Get implementation guidance based on your codebase
```
→ **EXIT COMMAND**

IF logbooks exist:
```
📚 Available logbooks:

  #  Logbook                    Last Modified      Main Objectives
  ─────────────────────────────────────────────────────────────────
  1  TICKET-123.json            2 hours ago        2 (1 active)
  2  feature-auth.json          1 day ago          3 (0 active)
  3  bug-fix-login.json         3 days ago         1 (1 achieved)

Options:
  [1-N] Select logbook by number
  [name] Type logbook filename
  [c] Create new logbook
  [q] Quit

Choose:
```

### Step 1.3: Handle User Choice

- IF number 1-N → Load corresponding logbook
- IF filename → Validate and load
- IF "c" or "create":
  ```
  To create a new logbook, run:
    /ai-behavior:logbook-create [filename]

  Example:
    /ai-behavior:logbook-create TICKET-456.json
  ```
  → **EXIT COMMAND**
- IF "q" or "quit" → Exit

---

## Step 2: Load Logbook and Show Status

Load selected logbook and display current status:

```
📋 Logbook: [ticket.title]

🎯 Main Objectives:
┌────┬─────────────────────────────────────────────┬─────────────┐
│ #  │ Content                                     │ Status      │
├────┼─────────────────────────────────────────────┼─────────────┤
│ 1  │ Endpoint GET /products/:id returns...       │ 🟡 active   │
│ 2  │ AddPieceService contains business logic...  │ ⚪ not_started│
└────┴─────────────────────────────────────────────┴─────────────┘

📝 Secondary Objectives for Main #1:
┌────┬─────────────────────────────────────────────┬─────────────┐
│ 1.1│ ProductDetailDTO includes specifications    │ ⚪ not_started│
│ 1.2│ ProductController.getById implemented       │ ⚪ not_started│
│ 1.3│ Unit tests for getById                      │ ⚪ not_started│
└────┴─────────────────────────────────────────────┴─────────────┘
```

---

## Step 3: Select Objective to Implement

```
🎯 Which objective do you want to implement?

Options:
  [1.1, 1.2, ...] Select secondary objective
  [auto] Let me choose the next logical one
  [q] Quit

Choose:
```

IF "auto":
- Select first `not_started` secondary objective
- If none, select first `not_started` from next main objective
- If all completed:
  ```
  ✅ All objectives are completed!

  Consider running:
    /ai-behavior:resolution-create [logbook]
  ```
  → **EXIT COMMAND**

Load selected objective with its `completion_guide`.

---

## Step 4: Prepare Implementation Context

MAIN AGENT prepares context package:

```
🔍 Preparing implementation context...

  ✓ Loading project manifest
  ✓ Loading project rules
  ✓ Reading completion guide
  ✓ Identifying reference files
```

Build context object:
```json
{
  "objective": {
    "id": "1.1",
    "content": "ProductDetailDTO includes specifications array",
    "completion_guide": [
      "Use pattern from src/dtos/BaseDTO.ts:12",
      "Apply rule #3: @Expose() decorators",
      "..."
    ]
  },
  "rules": [
    { "id": 3, "content": "Use @Expose() on public DTO fields", "criteria": [...] },
    { "id": 7, "content": "All endpoints require AuthGuard", "criteria": [...] }
  ],
  "manifest_summary": {
    "framework": "NestJS",
    "patterns": ["DTO pattern", "Repository pattern"],
    "relevant_layers": ["api_layer", "dto_layer"]
  },
  "reference_files": [
    { "path": "src/dtos/BaseDTO.ts", "purpose": "Base class to extend" },
    { "path": "src/dtos/ProductListDTO.ts", "purpose": "Similar DTO for reference" }
  ]
}
```

---

## Step 5: Invoke Code Implementer

```
🤖 Starting implementation...

Objective: [objective.content]
```

MAIN AGENT invokes **code-implementer** subagent with:
- Implementation context (from Step 4)
- `project_manifest_path`
- `project_rules_path`
- `preferred_language`

### Subagent Progress (visible to user):

```
🔧 Implementing: ProductDetailDTO

  [1/4] Reading reference files...
  [2/4] Analyzing patterns...
  [3/4] Writing code...
  [4/4] Generating change manifest...
```

### Subagent Returns:

```json
{
  "success": true,
  "changes": [
    {
      "file": "src/dtos/ProductDetailDTO.ts",
      "action": "created",
      "lines_added": 45,
      "description": "New DTO with specifications array"
    }
  ],
  "change_manifest": {
    "objective_id": "1.1",
    "files_modified": ["src/dtos/ProductDetailDTO.ts"],
    "files_created": ["src/dtos/ProductDetailDTO.ts"],
    "files_deleted": [],
    "patterns_applied": ["BaseDTO inheritance", "@Expose decorators"],
    "rules_followed": [3],
    "code_snippets": [
      {
        "file": "src/dtos/ProductDetailDTO.ts",
        "content": "... full file content or key sections ..."
      }
    ],
    "implementation_notes": "Created DTO extending BaseDTO with specifications array field"
  },
  "summary": "Created ProductDetailDTO.ts with specifications array, following BaseDTO pattern"
}
```

---

## Step 6: Show Implementation Summary

```
✅ Implementation complete!

📄 Changes:
  + src/dtos/ProductDetailDTO.ts (created, 45 lines)

📋 Patterns applied:
  • BaseDTO inheritance
  • @Expose decorators

🔍 Now auditing compliance with project rules...
```

---

## Step 7: Invoke Code Auditor

MAIN AGENT invokes **code-auditor** subagent with:
- `change_manifest` (from implementer)
- `project_rules` (full rules that apply)
- `preferred_language`

### Subagent Progress:

```
🔍 Auditing compliance...

  [1/3] Reading modified files...
  [2/3] Checking rule #3: @Expose decorators...
  [3/3] Validating patterns...
```

### Subagent Returns (Compliant):

```json
{
  "compliant": true,
  "rules_checked": [3, 7],
  "findings": [],
  "summary": "All rules satisfied. Code follows project conventions."
}
```

### Subagent Returns (Non-Compliant):

```json
{
  "compliant": false,
  "rules_checked": [3, 7],
  "findings": [
    {
      "rule_id": 3,
      "severity": "error",
      "file": "src/dtos/ProductDetailDTO.ts",
      "line": 15,
      "issue": "Field 'specifications' missing @Expose() decorator",
      "expected": "@Expose() decorator on public field",
      "found": "No decorator"
    },
    {
      "rule_id": 3,
      "severity": "warning",
      "file": "src/dtos/ProductDetailDTO.ts",
      "line": 8,
      "issue": "Consider adding @Type() for nested array",
      "suggestion": "@Type(() => SpecificationDTO)"
    }
  ],
  "summary": "Found 1 error and 1 warning. Requires fixes."
}
```

---

## Step 8: Handle Audit Result

### Step 8A: Compliant - Success

```
✅ Audit passed!

All project rules satisfied:
  ✓ Rule #3: @Expose decorators
  ✓ Rule #7: AuthGuard (not applicable)

📋 Updating logbook...
```

→ Go to Step 9

### Step 8B: Non-Compliant - Retry Loop

```
⚠️ Audit found issues:

  ❌ [Rule #3] src/dtos/ProductDetailDTO.ts:15
     Field 'specifications' missing @Expose() decorator

  ⚡ [Rule #3] src/dtos/ProductDetailDTO.ts:8 (warning)
     Consider adding @Type() for nested array

🔄 Attempting automatic fix... (Attempt 1/3)
```

MAIN AGENT re-invokes **code-implementer** with:
- Original context
- `audit_findings` (the issues to fix)
- `retry_attempt: 1`
- Instruction: "Fix the following compliance issues"

Repeat Steps 5-7 until:
- Compliant → Go to Step 9
- Max retries (3) reached → Go to Step 8C

### Step 8C: Max Retries Exceeded

```
⚠️ Could not achieve full compliance after 3 attempts.

Remaining issues:
  ❌ [Rule #3] Field 'specifications' missing @Expose() decorator

Options:
  1) Accept current implementation (will note issues in logbook)
  2) Try manual fix (opens file for you to edit)
  3) Abort (revert changes)

Choose [1-3]:
```

Handle user choice accordingly.

---

## Step 9: Update Logbook

Update logbook with:
1. Change objective status to `achieved`
2. Add context entry documenting implementation

```
📋 Updating logbook...

  ✓ Objective 1.1 marked as achieved
  ✓ Added context entry with implementation details
```

### Context Entry Added:

```json
{
  "id": 12,
  "created_at": "2025-12-11T23:00:00Z",
  "content": "Implemented: ProductDetailDTO with specifications array. Patterns: BaseDTO inheritance, @Expose decorators. Audit: passed (rules #3).",
  "mood": "focused"
}
```

---

## Step 10: Next Steps

```
✅ Objective 1.1 completed!

📊 Progress:
  Main objective #1: 1/3 secondary objectives done

🎯 Next objective:
  1.2: ProductController.getById implemented

  Completion guide:
  • Follow UserController.getById pattern at line 67
  • Apply rule #7: @UseGuards(AuthGuard)
  • Return ProductDetailDTO using plainToInstance

Continue with objective 1.2? (Yes/No/Quit)
```

IF "Yes" → Go to Step 4 with next objective
IF "No" or "Quit" → Show final summary and exit

---

## Final Summary

```
✅ Implementation session complete!

📊 Session summary:
  • Objectives completed: 2
  • Files created: 2
  • Files modified: 1
  • Audit attempts: 3 (all passed)

📋 Logbook updated: ai_files/logbooks/[filename]

💡 Commands:
  • Continue later: /ai-behavior:implement [filename]
  • Update progress: /ai-behavior:logbook-update [filename]
  • Close ticket: /ai-behavior:resolution-create [filename]
```

---

## Error Handling

| Error | Handling |
|-------|----------|
| Implementer fails | Show error, offer retry or abort |
| Auditor fails | Skip audit, warn user, continue |
| File write fails | Show error, check permissions |
| Max retries exceeded | Offer accept/manual/abort options |

---

## Configuration Options (future)

Could be added to `user_pref.json`:

```json
{
  "implement_settings": {
    "max_audit_retries": 3,
    "auto_continue_next": false,
    "show_code_diff": true,
    "require_tests": false
  }
}
```

---

**Status:** ✅ DESIGNED
