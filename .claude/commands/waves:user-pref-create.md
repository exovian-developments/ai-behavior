---
description: Create complete user preferences with ALL options from schema. Advanced setup with full control over every setting.
---

# Command: /waves:user-pref-create

You are executing the waves advanced user preferences creation command. Follow these instructions exactly.

## Your Role

You are the main orchestrator for detailed user preference configuration. Unlike `/waves:project-init` which asks 5 essential questions, this command walks the user through ALL available preferences.

## Step 0: Language and Existing Check

1. Display welcome in English first:
   ```
   📘 Command: /waves:user-pref-create

   🌍 What language do you prefer?
   Examples: English, Español, Português, Français, Deutsch, 日本語
   ```

2. Wait for response. Store as `preferred_language`.

3. Check if `ai_files/user_pref.json` exists.
   - IF EXISTS → Ask in user's language: "⚠️ Preferences already exist. Overwrite? (Yes/No)"
   - IF No → Exit with: "Use /waves:user-pref-update to modify existing preferences."

**From this point, conduct ALL interactions in the user's chosen language.**

## Step 1: Section 1 — LLM Guidance

Read `ai_files/schemas/user_pref_schema.json` for field definitions.

Display:
```
📋 SECTION 1: LLM Behavior

These settings control how the AI assistant behaves:
```

For each field in `llm_guidance`, show:
```
📌 [field_name]
   Description: [from schema description]
   Default: [default value]

   Keep default or change? (Enter to keep, or type new value):
```

Fields: `explain_before_answering`, `ask_before_assuming`, `suggest_multiple_options`, `allow_self_correction`, `persistent_personality`, `feedback_loop_enabled`

## Step 2: Section 2 — User Profile

```
📋 SECTION 2: User Profile
```

Ask for:
- `name` — free text
- `communication_tone` — show enum options: formal, neutral, friendly, friendly_with_sarcasm, funny, strict
- `emoji_usage` — true/false
- `preferred_language` — already captured
- `technical_background` — free text describing role/expertise
- `explanation_style` — show enum options from schema
- `learning_style` — show enum options from schema

## Step 3: Section 3 — Output Preferences

```
📋 SECTION 3: Output Preferences
```

Ask for:
- `format_code_with_comments` — true/false
- `block_comment_tags` — start/end tags (show defaults)
- `code_language` — primary language for code examples
- `use_inline_explanations` — true/false
- `highlight_gotchas` — true/false
- `response_structure` — array of sections (show example)

## Step 4: Section 4 — Project Context

```
📋 SECTION 4: Project Context
```

Ask for:
- `project_type` — software / general
- `is_project_known_by_user` — true/false

## Step 4.5: Section 5 — Agent Configuration (Waves 2.0+)

```
📋 SECTION 5: Agent Configuration

These settings control how Waves 2.0 hooks operate:
```

Ask:

```
📌 Metacognition Model
   When a primary objective completes, a blueprint changes, or a roadmap phase
   finishes, Waves delegates a strategic analysis to a background subagent.
   This subagent reads your blueprint, roadmaps, and logbooks to detect
   blockers, design improvements, and effort-saving opportunities.

   Which model should the metacognition subagent use?

   • opus   — Strongest analysis. Recommended for complex products. (default)
   • sonnet — Faster, good for straightforward projects.
   • haiku  — Fastest, minimal cost. Basic checks only.

   Your choice (opus/sonnet/haiku):
```

Store as `agent_config.metacognition_model`.

```
💡 TIP: In early stages (before blueprint or with minimal artifacts),
   metacognition has little to analyze. You can request it on-demand
   by asking the agent: "Run a metacognition analysis on the current state."
   The automatic triggers activate once you have blueprint + roadmap + logbooks.
```

## Step 5: Show Summary

Display all selected values in a formatted summary:
```
📋 Your complete configuration:

LLM Behavior:
  [list all settings with values]

User Profile:
  [list all settings with values]

Output Preferences:
  [list all settings with values]

Project Context:
  [list all settings with values]

Agent Configuration:
  [list all settings with values]

Save this configuration? (Yes/No/Edit [section])
```

IF "Edit [section]" → return to that section.

## Step 6: Generate user_pref.json

1. Read schema from `ai_files/schemas/user_pref_schema.json`.
2. Create `ai_files/user_pref.json` with all values.
3. Validate against schema.

## Step 7: Update CLAUDE.md

Same logic as `/waves:project-init`:
- IF `CLAUDE.md` exists → Check if the Waves framework training block already exists (look for "Waves Framework — Agent Operating Protocol"). If not present, prepend the full Waves training block (Agent Operating Protocol, directory structure, artifact hierarchy, required agent behaviors, wave lifecycle, and available commands). If only the old "User Preferences" header exists, replace it with the full block.
- IF NOT → Create `CLAUDE.md` with the full Waves framework training block as defined in `/waves:project-init`.

## Step 8: Success Message

```
✅ Complete preferences created!

📁 Files updated:
  • ai_files/user_pref.json (created)
  • CLAUDE.md (updated)

[Show summary of non-default values]

💡 To modify later: /waves:user-pref-update

⚠️ Restart your Claude Code session to load the new preferences.
```

END OF COMMAND
