# Versioning Process

## Repository Structure

```
waves/
├── schemas/              # Source of truth (9 JSON schemas)
├── subagents/            # Canonical design (31 subagent specifications)
├── commands/             # Command design docs (numbered, detailed)
├── .claude/commands/     # Executable slash commands for Claude Code
├── plugin/               # Cowork plugin source (Claude desktop)
│   ├── .claude-plugin/   #   Plugin manifest (version here)
│   ├── agents/           #   16 specialized agents
│   ├── commands/         #   11 slash commands
│   ├── skills/           #   Protocol knowledge + schema references
│   └── hooks/            #   SessionStart auto-context hook
├── CHANGELOG.md          # Version history
└── VERSIONING_PROCESS.md # This file
```

## Source of Truth

- `schemas/` and `subagents/` are the canonical design
- `plugin/` is an adapted implementation for the Cowork plugin format
- When you modify a schema or subagent, propagate the change to `plugin/`
- See `CHANGELOG.md` for the mapping between subagents and plugin agents

## Build the Plugin

The `.plugin` file is a build artifact (a ZIP). It is NOT versioned in git (listed in `.gitignore`).

To generate it:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

This creates `waves.plugin` in the repo root, ready to install or distribute.

## Version Numbering

Uses [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0) — Breaking changes to schemas or command interfaces
- **MINOR** (0.2.0) — New agents, commands, or features (backwards compatible)
- **PATCH** (0.1.1) — Bug fixes, typos, minor improvements

Update the version in two places:

1. `plugin/.claude-plugin/plugin.json` → `"version": "X.Y.Z"`
2. `CHANGELOG.md` → New `## [X.Y.Z]` section

## Release Workflow

### 1. Make changes

Edit the canonical source (`schemas/`, `subagents/`, `commands/`) and propagate to `plugin/` as needed.

### 2. Update CHANGELOG

Add a new section to `CHANGELOG.md`:

```markdown
## [0.2.0] - 2026-MM-DD

### Added
- ...

### Changed
- ...

### Fixed
- ...
```

### 3. Update plugin version

Edit `plugin/.claude-plugin/plugin.json`:

```json
{
  "version": "0.2.0"
}
```

### 4. Commit and tag

```bash
git add .
git commit -m "Release v0.2.0"
git tag v0.2.0
git push origin main --tags
```

### 5. Build and publish

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
cd ..
gh release create v0.2.0 waves.plugin --title "v0.2.0" --notes "See CHANGELOG.md for details"
```

This uploads the `.plugin` file to GitHub Releases where anyone can download it.

## Change Propagation Checklist

When modifying the canonical design, check if the plugin needs updating:

| Changed | Plugin files to update |
|---|---|
| A schema in `schemas/` | `plugin/skills/waves-protocol/references/` (copy the updated schema) |
| A subagent in `subagents/` | The corresponding agent in `plugin/agents/` (see CHANGELOG mapping) |
| A command in `commands/` | The corresponding command in `plugin/commands/` |
| SKILL.md content | `plugin/skills/waves-protocol/SKILL.md` |
| Hook behavior | `plugin/hooks/hooks.json` |
