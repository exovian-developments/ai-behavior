---
description: Update an existing logbook with progress entries, objective status changes, new objectives, and reminders. Includes automatic history compaction.
---

# Command: /waves:logbook-update

You are executing the waves logbook update command. Follow these instructions exactly.

## Your Role

You are the main orchestrator for logbook updates. You will help users track progress, update objective statuses, add new objectives discovered during work, and manage reminders.

## Step -1: Prerequisites Check (CRITICAL)

Check if `ai_files/user_pref.json` exists.

IF NOT EXISTS:
```
⚠️ Missing configuration!

Please run first:
/waves:project-init
```
→ EXIT COMMAND

IF EXISTS:
1. Read `ai_files/user_pref.json`
2. Extract `user_profile.preferred_language` → Use for all interactions
3. Extract `project_context.project_type` → For schema validation

**From this point, conduct ALL interactions in the user's preferred language.**

## Step 0: Parameter Check and Logbook Selection

Check if filename parameter was provided with the command.

**IF parameter provided:**
1. Search for file in `ai_files/waves/*/logbooks/[filename].json`
2. IF NOT EXISTS → Error: "Logbook not found: [filename]"
3. IF EXISTS → Load logbook, note which wave it belongs to, continue

**IF NO parameter:**
1. Show tip:
```
💡 TIP: You can run faster with:
   /waves:logbook-update TICKET-123.json
```

2. List available logbooks from all waves `ai_files/waves/*/logbooks/*.json`, grouped by wave:
```
📚 Available logbooks:

Wave w1:
1. [filename1].json (updated [time ago])
2. [filename2].json (updated [time ago])

Wave w0:
3. [filename3].json (updated [time ago])

Choose 1-[N] or type the filename:
```

3. User selects → Load logbook

## Step 1: Check Due Reminders

Read `future_reminders` array from loaded logbook.

FOR EACH reminder WHERE `when <= now`:
```
⏰ Pending reminder:
"[reminder.content]"
(Created: [reminder.created_at])

Mark as seen? (Yes/No)
```

IF "Yes" → Remove from array

## Step 2: Show Current Status

Display logbook summary:

```
📋 Logbook: [ticket.title]

🎯 Main Objectives:
┌────┬─────────────────────────────────────────────┬─────────────┐
│ ID │ Content                                     │ Status      │
├────┼─────────────────────────────────────────────┼─────────────┤
│ 1  │ [objective.content truncated...]            │ [icon] [status] │
│ 2  │ [objective.content truncated...]            │ [icon] [status] │
└────┴─────────────────────────────────────────────┴─────────────┘

📝 Secondary Objectives (active/pending):
┌────┬─────────────────────────────────────────────┬─────────────┐
│ 1  │ [objective.content truncated...]            │ [icon] [status] │
│ 2  │ [objective.content truncated...]            │ [icon] [status] │
│ 3  │ [objective.content truncated...]            │ [icon] [status] │
└────┴─────────────────────────────────────────────┴─────────────┘

📊 Recent context: [count]/20 entries
📜 Compacted history: [count]/10 entries
```

**Status Icons:**
- ⚪ not_started
- 🟡 active
- 🔴 blocked
- 🟢 achieved
- ⚫ abandoned

## Step 3: Select Operation

```
What would you like to do?

1. 📝 Add progress (new context entry)
2. ✅ Update objective status
3. ➕ Add new objective
4. ⏰ Add reminder
5. 💾 Save and exit

Choose 1-5:
```

Route to corresponding operation.

---

# OPERATION 1: Add Progress Entry

```
📝 Describe the progress, finding, or decision:

(Examples: "Completed endpoint with validation",
 "Discovered bug in middleware",
 "Decision: use pattern X because Y")
```

Wait for user input. Store as `content`.

```
How would you describe your current state? (optional, Enter to skip)
(focused, frustrated, excited, uncertain, blocked)
```

Store as `mood` or null.

**Create context entry:**

```json
{
  "id": [next_id],
  "created_at": "[now UTC ISO 8601]",
  "content": "[user_input]",
  "mood": "[mood_if_provided]"
}
```

**Prepend** to `recent_context` array (index 0, newest first).

**Check: History Compaction Needed?**

IF `recent_context.length > 20`:
→ Go to **STEP COMPACT**

```
✅ Progress added!

Would you like to do another operation? (Yes/No)
```

IF "Yes" → Go to Step 3
IF "No" → Go to **STEP SAVE**

---

# OPERATION 2: Update Objective Status

```
What type of objective do you want to update?

1. Main objective
2. Secondary objective

Choose 1 or 2:
```

**Show objectives of selected type with current status:**

```
[Main/Secondary] Objectives:

1. [ID: 1] ⚪ not_started - [content truncated...]
2. [ID: 2] 🟡 active - [content truncated...]
3. [ID: 3] 🟢 achieved - [content truncated...]

Which one do you want to update? (number or ID):
```

User selects objective.

```
Current status: [current_status]

New status:
1. ⚪ not_started (pending)
2. 🟡 active (in progress)
3. 🔴 blocked (blocked)
4. 🟢 achieved (completed)
5. ⚫ abandoned (cancelled)

Choose 1-5:
```

**Update objective status.**

**Auto-create context entry documenting the change:**

```json
{
  "id": [next_id],
  "created_at": "[now UTC]",
  "content": "Objective [ID] status changed: [old] → [new]. [objective.content]"
}
```

**IF status changed to "achieved" on secondary objective:**

Check if ALL secondary objectives for related main are achieved.

IF yes:
```
🎉 All secondary objectives completed!

Mark main objective #[id] as achieved?
"[main_objective.content]"

(Yes/No)
```

IF "Yes" → Update main objective status to "achieved"

```
✅ Status updated!

Would you like to do another operation? (Yes/No)
```

IF "Yes" → Go to Step 3
IF "No" → Go to **STEP SAVE**

---

# OPERATION 3: Add New Objective

```
What type of objective do you want to add?

1. Main objective - High level, requires scope
2. Secondary objective - Granular, requires completion_guide

Choose 1 or 2:
```

---

## OPERATION 3A: Add Main Objective

```
📌 New main objective

What is the verifiable outcome? (max 180 chars)
(Example: "POST /products endpoint creates product with validation")
```

Store as `content`.

```
What is the business/technical context? (max 300 chars)
(Why is it needed? Who requires it?)
```

Store as `context`.

**IF project_type === "software":**

```
What are the reference files? (one per line, empty Enter to finish)
(Example: src/controllers/ProductController.ts)
```

Store as `files` array.

```
What project rules apply? (IDs separated by comma, or Enter for none)
(Example: 3, 7, 12)
```

Store as `rules` array.

Create main objective:
```json
{
  "id": [next_main_id],
  "created_at": "[now UTC]",
  "content": "[content]",
  "context": "[context]",
  "scope": {
    "files": ["[files]"],
    "rules": [[rules]]
  },
  "status": "not_started"
}
```

**IF project_type === "general":**

```
What reference materials apply? (one per line, empty Enter to finish)
(Example: Chapter 2 in Google Docs, Client brief, https://reference.com)
```

Store as `references` array.

```
What standards or guides apply? (one per line, or Enter for none)
(Example: APA 7th edition, Brand guidelines, ISO 27001)
```

Store as `standards` array.

Create main objective:
```json
{
  "id": [next_main_id],
  "created_at": "[now UTC]",
  "content": "[content]",
  "context": "[context]",
  "scope": {
    "references": ["[references]"],
    "standards": ["[standards]"]
  },
  "status": "not_started"
}
```

Go to confirmation step.

---

## OPERATION 3B: Add Secondary Objective

```
📝 New secondary objective

What is the specific outcome? (max 180 chars)
(Should be completable in one work session)
```

Store as `content`.

**IF project_type === "software":**

```
Provide the completion guide (one per line, empty Enter to finish):
(Reference specific files, patterns, line numbers, rules)

Example:
• Use pattern from src/services/UserService.ts:45
• Apply rule #3: input validation
```

**IF project_type === "general":**

```
Provide the completion guide (one per line, empty Enter to finish):
(Reference documents, sections, examples, standards)

Example:
• Follow Chapter 2 structure
• Apply APA format for citations
• Review tutor feedback (notes 15-nov)
```

Store as `completion_guide` array.

Create secondary objective:
```json
{
  "id": [next_secondary_id],
  "created_at": "[now UTC]",
  "content": "[content]",
  "completion_guide": ["[guide_items]"],
  "status": "not_started"
}
```

**Add to respective array and create context entry:**

```json
{
  "id": [next_id],
  "created_at": "[now UTC]",
  "content": "New [main/secondary] objective added: [content]"
}
```

```
✅ Objective added!

Would you like to do another operation? (Yes/No)
```

IF "Yes" → Go to Step 3
IF "No" → Go to **STEP SAVE**

---

# OPERATION 4: Add Reminder

```
⏰ New reminder

What do you want to remember?
```

Store as `reminder_content`.

```
When should the reminder appear?

1. Next session
2. In X hours (specify)
3. Specific date (YYYY-MM-DD HH:MM)

Choose 1-3:
```

Calculate `when` datetime based on selection.

Create reminder:
```json
{
  "id": [next_reminder_id],
  "created_at": "[now UTC]",
  "content": "[reminder_content]",
  "when": "[calculated_datetime]"
}
```

Add to `future_reminders` array.

```
✅ Reminder created!

Would you like to do another operation? (Yes/No)
```

IF "Yes" → Go to Step 3
IF "No" → Go to **STEP SAVE**

---

# STEP COMPACT: History Compaction

When `recent_context.length > 20`:

```
📦 Compacting history...

Recent context exceeds 20 entries.
Compacting oldest entries.
```

**Process:**

1. Take oldest entry (last in array)

2. Using **context-summarizer** subagent (or inline logic), compress to max 140 chars:
   - Original: "Completed endpoint implementation with full validation including email format, password strength, and duplicate user checks. Also added rate limiting middleware."
   - Summary: "EP done: validation (email, password, duplicates) + rate limiting middleware added"

3. Create `history_summary` entry:
```json
{
  "id": [next_summary_id],
  "created_at": "[now UTC]",
  "content": "[summary]",
  "mood": "[preserved_if_exists]"
}
```

4. **Prepend** to `history_summary` array

5. **Remove** oldest from `recent_context`

6. **Check:** IF `history_summary.length > 10`:
   - Remove oldest (last) from `history_summary`

```
✅ History compacted:
• Entry moved: "[original_content_truncated]..."
• Summary: "[summary]"
```

Return to calling step.

---

# STEP SAVE: Save and Exit

**Validate JSON against appropriate schema:**
- IF `project_type === "software"` → Validate against `logbook_software_schema.json`
- IF `project_type === "general"` → Validate against `logbook_general_schema.json`

**Save to `ai_files/waves/[wave_name]/logbooks/[filename].json`**

## STEP AUDIT: Re-audit if structurally modified

Detect whether this update materially changed the logbook (and therefore needs a fresh integrity audit):

**Trigger conditions** (any of):
- A new main or secondary objective was added (Operations 3A or 3B).
- A `scope.rules` field changed on any objective.
- A `completion_guide` was modified or added.

**If none of the trigger conditions match** (e.g. only progress entries or status updates were added), skip this step. Set `audit.is_already_audited = false` only if the logbook had `audit.is_already_audited = true` AND a structural change occurred — otherwise leave the field as-is.

**If a trigger condition matched:**

1. Set `audit.is_already_audited = false` in the logbook (a fresh audit is owed).
2. Save the logbook with the flag updated.
3. Spawn the integrity reviewer subagent following the **same protocol as Step A6 in `waves:logbook-create`** (blocking, model from `agent_config.metacognition_model`, output to `ai_files/waves/[wave_name]/audits/logbook-[basename].json`, same adversarial prompt).
4. Process findings the same way: critical findings reviewed and applied with full context; warnings decided per-finding; rejections recorded in `resolved_decisions` with `method: "integrity_audit_override"`.
5. Update the logbook with `audit.is_already_audited = true` and `audit.audit_file` after the audit completes.
6. Append a `recent_context` entry: `"Integrity audit re-run after structural update: [N] critical, [M] warnings. Audit report: ai_files/waves/[wave_name]/audits/logbook-[basename].json"`.

This step exists because rules and objectives added during update are exactly the kind of change that drifts from project standards — the omissions the integrity reviewer was designed to catch.

**Show summary:**

```
✅ Logbook updated!

📁 File: ai_files/waves/[wave_name]/logbooks/[filename].json

📊 Changes made:
• Context entries added: [count]
• Objectives updated: [count]
• New objectives: [count]
• Reminders: [count]
[If integrity audit ran:]
• Integrity audit: [N] critical, [M] warnings ([applied/noted breakdown])

🎯 Next objective to work on:
[First not_started or active secondary objective]

Guide:
[completion_guide items]
```

---

# Quick Update Mode

When the agent has been working with the user and has context from the session, offer a quick update:

```
💡 I detected we've been working on:
• Completed: [detected achievements]
• Findings: [detected findings]

Would you like to add this to the logbook automatically? (Yes/No/Adjust)
```

This allows:
1. Detect completed objectives from conversation
2. Extract findings and decisions
3. Propose context entries
4. User confirms or adjusts

---

# Automatic Context Entry Triggers

The agent should automatically offer to add context entries when:

| Trigger | Suggested Entry |
|---------|-----------------|
| Error resolved | "Resolved [error]: [solution]" |
| Decision made | "Decision: [choice] because [reason]" |
| Blocker encountered | "Blocked: [issue]. Waiting for [dependency]" |
| Objective completed | "Completed: [objective.content]" |
| New discovery | "Found: [discovery] in [location]" |

---

## Status Icons Reference

| Icon | Status | Meaning |
|------|--------|---------|
| ⚪ | not_started | Pending, not yet begun |
| 🟡 | active | Currently in progress |
| 🔴 | blocked | Waiting on external input/dependency |
| 🟢 | achieved | Completed successfully |
| ⚫ | abandoned | Cancelled, no longer needed |

---

## Subagents Reference

| Subagent | Purpose |
|----------|---------|
| context-summarizer | Compress context entries for history_summary (max 140 chars) |

END OF COMMAND
