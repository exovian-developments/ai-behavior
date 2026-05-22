---
description: Apply incremental Waves artifact migrations after a plugin update
allowed-tools: Read, Write, Edit, Bash
---

# /waves:upgrade — Incremental artifact migrations (plugin-first)

In Waves 3.0+ the framework (commands, hooks, agents, skills, schemas) lives in the Claude Code plugin and is updated with `/plugin update`. **This command does NOT copy framework files** — that is the plugin's job. Its only responsibility is to migrate your PROJECT ARTIFACTS (blueprint, rules, roadmaps, logbooks, CLAUDE.md) to match the framework version you now have installed, by applying declarative migrations from `${CLAUDE_PLUGIN_ROOT}/migrations/`.

> One-time framework cleanup for projects coming from Waves 2.x (removing `.claude/commands/waves:*.md`, `.claude/hooks/waves-*.sh`, `ai_files/schemas/`) is a SEPARATE command: `/waves:migrate-from-v2-to-v3`. Do not perform that cleanup here.

## Step 1: Detect versions and language

1. Read the project's applied version from `ai_files/.waves-version`. If the file is missing, set `local_version = "0.0.0"`.
2. Read the installed plugin version from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` (the `.version` field). Store as `plugin_version`.
3. Read `ai_files/user_pref.json` (or `user_pref.json`). Extract `preferred_language`. If not found, use English.

**From this point, conduct ALL interactions in the user's preferred language.**

4. IF `local_version == plugin_version`:
   ```
   ✅ Already up to date (v[plugin_version]). No migrations needed.
   ```
   → EXIT

5. Display:
   ```
   Waves upgrade: v[local_version] → v[plugin_version]
   Scanning migrations...
   ```

## Step 2: Select and apply migrations

1. List the migration files in `${CLAUDE_PLUGIN_ROOT}/migrations/*.md`. Each file's frontmatter declares `from_version` and `to_version` (semver).
2. Select the migrations where `to_version` is greater than `local_version` (compare as semver, not string). Apply them in ascending `to_version` order. Skip any whose `to_version <= local_version` (already applied).
3. For each selected migration, read its body and execute the `## Steps` section as a checklist. Steps are artifact patches: add a missing field, move a file, configure a setting, update the CLAUDE.md protocol block, etc. Ask the user a question ONLY where the migration step explicitly instructs you to.
4. If a step's precondition is already satisfied (e.g., the field already exists), skip it idempotently — never duplicate.

## Step 3: Write the version marker

Write `plugin_version` to `ai_files/.waves-version` (single line, semver). This is a git-committable project artifact — it records which framework version this project's artifacts are aligned to.

## Step 4: Summary

```
=== Upgrade complete: v[local_version] → v[plugin_version] ===

Migrations applied:
  [for each: to_version — one-line description from frontmatter]

Artifacts patched:
  [for each file touched: path — what changed]

ai_files/.waves-version → [plugin_version]
===
```

No session restart is needed for artifact migrations (hooks/commands already updated by `/plugin update`).
