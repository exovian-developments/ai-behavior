---
description: One-time migration from Waves 2.x to 3.0 plugin-first — removes legacy framework files, keeps artifacts
allowed-tools: Read, Bash, Edit, Write
deprecated_in: 3.2.0
---

# /waves:migrate-from-v2-to-v3 — One-time framework cleanup (TEMPORAL)

> ⚠️ **DEPRECATED — REMOVE IN v3.2.0.** This is a single-use transitional command that migrates a project from Waves 2.x (per-project framework copies) to 3.0 plugin-first (framework served by the Claude Code plugin). A migrated project never needs it again; it will be deleted in release 3.2.0. **Migration is ONE-WAY — there is no 2.5/3.0 coexistence.**

You are migrating THIS project to Waves 3.0 plugin-first. The framework (commands, hooks, schemas) now lives in the plugin. This command removes the project's legacy framework copies while keeping every project artifact in `ai_files/` intact.

## ⚠️ Critical sequencing — NEVER invert this order

The correctness of this command IS its order. Removing framework files before the plugin is confirmed working leaves the project with stale references and no schemas — a broken state, unrecoverable without git.

1. **Confirm the plugin is installed and functional** (Step 1).
2. **Confirm the git tree is clean** (Step 2) — git is the ONLY safety net; there is no automatic backup.
3. **ONLY THEN remove legacy framework files** (Step 4).

If Step 1 or Step 2 fails, ABORT immediately and remove NOTHING.

## Step 0: Language

Read `ai_files/user_pref.json` (or `user_pref.json`) → `preferred_language` (default English). Conduct all interactions in that language.

## Step 1: Pre-flight — plugin installed and functional

1. Verify `$CLAUDE_PLUGIN_ROOT` is set and points to a directory containing `commands/`, `hooks/`, and `skills/waves-protocol/references/` (the schemas the commands depend on).
2. IF `$CLAUDE_PLUGIN_ROOT` is unset or any of those is missing → **ABORT**:
   ```
   ❌ Waves plugin not detected (or incomplete). Install it first:
      /plugin marketplace add exovian-developments/waves-cowork-plugin
      /plugin install waves@waves-cowork-plugin
   Confirm /waves:* commands work, THEN re-run this migration.
   ```
   → EXIT (remove nothing)

## Step 2: Pre-flight — git tree clean

1. Run `git status --porcelain`.
2. IF the output is non-empty (uncommitted changes) → **ABORT**:
   ```
   ❌ Your git tree has uncommitted changes. git is the only safety net for this
      destructive migration — there is no automatic backup. Commit or stash first,
      then re-run /waves:migrate-from-v2-to-v3.
   ```
   → EXIT (remove nothing)
3. IF this is not a git repository → **ABORT** with a recommendation to `git init` and commit the current state first (so the migration is reversible). → EXIT (remove nothing)

## Step 3: Report and confirm

1. Enumerate the legacy framework files that WILL be removed:
   - `.claude/commands/waves:*.md`
   - `.claude/hooks/waves-*.sh`
   - `ai_files/schemas/` (entire directory)
   - waves hook entries in `.claude/settings.json` (entries whose `command` references `waves-*.sh`)
2. Display the exact list (counts + paths) to the user. State clearly: **artifacts in `ai_files/` (blueprint, project_rules, roadmaps, logbooks, user_pref, manifest) and any non-waves config will NOT be touched.**
3. Ask for explicit confirmation: `Remove these [N] legacy framework files/entries? (yes/no)`. IF the answer is not an explicit yes → EXIT (remove nothing).

## Step 4: Remove legacy framework + write the version marker

ONLY after Steps 1-3 have all passed:

1. Remove `.claude/commands/waves:*.md`.
2. Remove `.claude/hooks/waves-*.sh`.
3. Remove the `ai_files/schemas/` directory.
4. **Clean `.claude/settings.json` (if it exists):** remove every hook entry whose `command` references a `waves-*.sh` script (these now point to deleted files and would error on every tool call). If a hook-event array (`SessionStart`/`PreToolUse`/`PostToolUse`) becomes empty after removal, drop it; if the entire `hooks` object becomes empty, drop the `hooks` key. **Preserve all non-waves content** (permissions, other hooks, unrelated settings). The plugin now provides the hooks via its own `hooks.json`.
5. Do NOT touch any other file in `ai_files/` or `.claude/` (user-owned commands, other hooks, etc.).
6. Write the plugin version to `ai_files/.waves-version` (read from `$CLAUDE_PLUGIN_ROOT/.claude-plugin/plugin.json` → `.version`). This single-line semver artifact records the framework version the project's artifacts are aligned to.

## Step 5: Verify and summarize

1. Confirm 0 files remain matching `.claude/commands/waves:*.md`, `.claude/hooks/waves-*.sh`, or `ai_files/schemas/`.
2. Confirm `.claude/settings.json` (if present) has no remaining `waves-*.sh` references.
3. Confirm `ai_files/` artifacts are still present (blueprint, project_rules, roadmaps, logbooks).
4. Display the summary:
   ```
   === Migration complete: Waves 2.x → 3.0 plugin-first ===

   Removed:
     [N] .claude/commands/waves:*.md
     [M] .claude/hooks/waves-*.sh
     ai_files/schemas/
     [K] waves hook entries from .claude/settings.json

   Kept (untouched):
     ai_files/ artifacts (blueprint, rules, roadmaps, logbooks, user_pref, manifest)

   ai_files/.waves-version → [plugin_version]

   The framework is now served by the plugin. Run any /waves:* command to confirm.
   ===
   ```
