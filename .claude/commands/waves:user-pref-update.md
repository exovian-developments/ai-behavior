---
description: Update existing user preferences. View current settings and modify individual fields or open in editor.
---

# Command: /waves:user-pref-update

You are executing the waves user preferences update command. Follow these instructions exactly.

## Your Role

You help the user modify their existing preferences through either inline editing or opening the file in an editor.

## Step 0: Prerequisites Check

1. Check if `ai_files/user_pref.json` exists.
   - IF NOT EXISTS → Display: "⚠️ No preferences found. Run /waves:project-init first." → EXIT COMMAND

2. Read `ai_files/user_pref.json`.
3. Extract `preferred_language`.

**From this point, conduct ALL interactions in the user's preferred language.**

## Step 1: Show Current Configuration

Display a summary of current settings:
```
📋 Your current configuration:

Language: [preferred_language]
Name: [name]
Tone: [communication_tone]
Explanations: [explanation_style]
Emojis: [emoji_usage]
Project type: [project_type]
Familiarity: [is_project_known_by_user]

LLM Behavior:
  • explain_before_answering: [value]
  • ask_before_assuming: [value]
  • suggest_multiple_options: [value]
  • allow_self_correction: [value]
  • persistent_personality: [value]
  • feedback_loop_enabled: [value]

Output Preferences:
  • format_code_with_comments: [value]
  • highlight_gotchas: [value]
  • code_language: [value]

Agent Configuration (Waves 2.0+):
  • metacognition_model: [value or "not set — defaults to opus"]
```

**If `agent_config.metacognition_model` is missing from the file, show:**
```
💡 New in Waves 2.0: Metacognition model is not configured.
   Currently using default (opus).
   Add it? (Yes/No)
```
If Yes, ask:
```
📌 Metacognition Model
   When objectives complete, blueprints change, or phases finish,
   Waves delegates a strategic analysis to a background subagent.

   • opus   — Strongest analysis. Recommended for complex products. (default)
   • sonnet — Faster, good for straightforward projects.
   • haiku  — Fastest, minimal cost. Basic checks only.

   Your choice (opus/sonnet/haiku):
```
Store as `agent_config.metacognition_model` in user_pref.json.

## Step 2: Choose Edit Method

```
How would you like to edit?

1. Edit inline — I'll guide you through each change
2. Open in editor — Opens the JSON file in your default editor

Choose 1 or 2:
```

### Option 1: Inline Editing

```
Type the name of the field to change:

Available fields:
  • communication_tone
  • emoji_usage
  • explanation_style
  • preferred_language
  • learning_style
  • explain_before_answering
  • ask_before_assuming
  • suggest_multiple_options
  • allow_self_correction
  • format_code_with_comments
  • highlight_gotchas
  • project_type
  • is_project_known_by_user
  • metacognition_model (opus/sonnet/haiku)
  • (or type 'done' to finish)
```

For each field the user selects:
```
Current value: [current_value]
[If enum field: show options]
[If boolean: true/false]
[If string: type new value]

New value:
```

After each change:
```
✅ [field_name] updated to '[new_value]'
Change another field? (Yes/No)
```

### Option 2: Editor

1. Detect operating system:
   - macOS → `open ai_files/user_pref.json`
   - Linux → `xdg-open ai_files/user_pref.json` or `$EDITOR ai_files/user_pref.json`

2. Display:
   ```
   📝 Opening preferences file in your editor...

   Save the file when done, then press Enter here to validate.
   ```

3. Wait for user to press Enter.

## Step 3: Validate Changes

After editing (either method):

1. Re-read `ai_files/user_pref.json`.
2. Validate JSON syntax.
   - IF invalid → Show error and offer to re-edit.
3. Validate against `ai_files/schemas/user_pref_schema.json`.
   - IF schema violation → Show what's wrong, offer to fix.

## Step 4: Success Message

```
✅ Preferences updated!

📁 File: ai_files/user_pref.json

Changes made:
  [List changed fields with old → new values]

⚠️ Restart your Claude Code session to apply the changes.
```

END OF COMMAND
