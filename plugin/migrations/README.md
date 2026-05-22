# Waves Migrations

Declarative **artifact** migrations applied by `/waves:upgrade`. The framework itself
(commands, hooks, agents, skills, schemas) is delivered by the Claude Code plugin and
updated with `/plugin update`. These files migrate a project's ARTIFACTS (blueprint,
project_rules, roadmaps, logbooks, CLAUDE.md, version marker) from one framework version
to the next.

This replaces the Waves 2.x model where migrations were hard-coded inline inside the
`/waves:upgrade` command. Declarative files keep migrations versioned, reviewable, and
decoupled from the command logic.

## File naming

```
v<from>-to-<to>.md      e.g.  v2.5-to-v3.0.md
```

## Frontmatter (required)

```yaml
---
from_version: "2.5.0"    # semver this migration expects as the starting point
to_version: "3.0.0"      # semver this migration brings the project's artifacts to
description: "one-line summary shown in the upgrade report"
---
```

## Body structure

```markdown
# Migration v<from> → v<to>

## Narrative
User-facing explanation: what changed at the artifact level and why.

## Steps
1. A concrete, idempotent artifact patch (add a field, move a file, configure a setting...).
2. Another step. Each step must be safe to re-run — if its precondition is already
   satisfied, skip it (never duplicate).
```

## How `/waves:upgrade` selects and applies migrations

1. Reads the project's applied version from `ai_files/.waves-version` (or `0.0.0` if absent).
2. Selects every migration whose `to_version` is greater (by semver) than the applied version.
3. Applies them in ascending `to_version` order, executing each `## Steps` section as an
   idempotent checklist.
4. Writes the installed plugin version to `ai_files/.waves-version` when done.

## Scope boundary

These migrations touch ARTIFACTS only. One-time removal of legacy 2.x framework files
(`.claude/commands/waves:*.md`, `.claude/hooks/waves-*.sh`, `ai_files/schemas/`) is handled
by the separate `/waves:migrate-from-v2-to-v3` command — never by a migration file here.
