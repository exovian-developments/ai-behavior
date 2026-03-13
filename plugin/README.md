# waves Plugin

Structured context protocol for AI agents — project manifests, coding rules, development logbooks, and multi-session continuity.

## What it does

waves gives Claude structured knowledge about your project so it can work with full context across sessions. It supports software projects (any language/framework) and general projects (academic, creative, business).

**Two types of context:**
- **Global Context** — Manifests describe your project, rules define how to work in it, preferences set how Claude communicates with you
- **Focused Context** — Logbooks track ticket/task progress with objectives, completion guides, and session history

## Commands

| Command | Description |
|---------|-------------|
| `/project-init` | Set up preferences and project context (start here) |
| `/manifest-create` | Analyze your project and create a comprehensive manifest |
| `/manifest-update` | Detect changes and update the manifest |
| `/rules-create` | Extract coding rules from your codebase (or define standards for general projects) |
| `/rules-update` | Update rules based on code changes |
| `/user-pref-create` | Advanced preferences setup (all options) |
| `/user-pref-update` | Modify existing preferences |
| `/logbook-create` | Start a development logbook for a ticket or task |
| `/logbook-update` | Track progress and add context entries |
| `/resolution-create` | Generate a resolution document from a completed logbook |
| `/objectives-implement` | Implement objectives with automatic code auditing |

## Getting Started

1. Select your project folder in Cowork (or provide a GitHub URL to clone)
2. Run `/project-init` to configure your preferences
3. Run `/manifest-create` to analyze your project
4. Run `/rules-create` to extract coding rules (software) or define standards (general)
5. Run `/logbook-create` to start working on a ticket

## Specialized Agents

The plugin uses 16 specialized agents that handle heavy analysis outside the main conversation thread, preserving context for long work sessions:

| Agent | Purpose |
|-------|---------|
| `entry-point-analyzer` | Find app entry points and startup flows |
| `navigation-mapper` | Map frontend routes and screens |
| `flow-tracker` | Track backend API flows and events |
| `dependency-auditor` | Audit dependencies and security |
| `architecture-detective` | Detect architectural patterns and layers |
| `feature-extractor` | Extract user-facing features |
| `pattern-extractor` | Find consistent code patterns |
| `convention-detector` | Detect naming and coding conventions |
| `antipattern-detector` | Identify bad practices (educational) |
| `git-history-analyzer` | Analyze git commit history |
| `change-analyzer` | Detect and analyze project changes |
| `rule-comparator` | Compare existing vs detected rules |
| `objective-generator` | Generate objectives with completion guides |
| `code-implementer` | Implement code following rules |
| `code-auditor` | Audit code against project rules |
| `general-scanner` | Analyze non-software projects |

## Project Types

| Type | Use case |
|------|----------|
| **Software** | Applications, APIs, systems — any language or framework |
| **Academic** | Research papers, theses, dissertations |
| **Creative** | Design, art, video, music projects |
| **Business** | Business plans, operations, strategy |
| **General** | Anything else with objectives and deliverables |

## Files Created

After setup, your project will have:
```
project/
├── ai_files/
│   ├── schemas/              # JSON schemas (reference)
│   ├── logbooks/             # Work logbooks
│   ├── resolutions/          # Ticket resolutions
│   ├── user_pref.json        # Your preferences
│   ├── project_manifest.json # Project analysis
│   └── project_rules.json    # Coding rules
└── CLAUDE.md                 # Updated with preferences
```

## Session Continuity

The plugin automatically loads your preferences and project context at the start of each session via a SessionStart hook. No manual setup needed after the initial configuration.

## Remote Repos

You can provide a GitHub URL instead of a local folder. The plugin will clone the repo, run the analysis, and save the output files to your workspace.
