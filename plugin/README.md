# Waves™ Plugin

Product development framework for the AI agent era — from idea validation to production delivery.

## What it does

Waves gives Claude the complete product lifecycle: validate ideas with Monte Carlo simulations, define products with structured blueprints, plan delivery with roadmaps, and track implementation with logbooks. It supports software projects (any language/framework) and general projects (academic, creative, business).

**Product Lifecycle:**
- **Feasibility** → Validate your idea with Monte Carlo and Bayesian analysis before investing
- **Foundation** → Compact feasibility into validated facts and executive brief
- **Blueprint** → Define the product: capabilities, flows, rules, metrics
- **Roadmap** → Plan delivery in phases with milestones and dependencies
- **Logbook** → Track implementation with objectives, progress, and session continuity

**Context Types:**
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
| `/feasibility-analyze` | Pre-blueprint feasibility with Monte Carlo and Bayesian projections |
| `/foundation-create` | Compact feasibility into validated facts for blueprint |
| `/blueprint-create` | Create complete product blueprint from foundation |
| `/roadmap-create` | Create roadmap with phases, milestones, and dependencies |
| `/roadmap-update` | Update roadmap progress and decisions |
| `/logbook-create` | Start a development logbook for a ticket or task |
| `/logbook-update` | Track progress and add context entries |
| `/resolution-create` | Generate a resolution document from a completed logbook |
| `/objectives-implement` | Implement objectives with automatic code auditing |

## Getting Started

### New Product (from scratch)

1. Select your project folder in Cowork
2. Run `/project-init` to configure your preferences
3. Run `/feasibility-analyze` to validate your idea
4. Run `/foundation-create` to compact the analysis
5. Run `/blueprint-create` to define your product
6. Run `/roadmap-create` to plan your first wave
7. Run `/logbook-create` to start working on tickets

### Existing Project

1. Select your project folder in Cowork
2. Run `/project-init` to configure your preferences
3. Run `/manifest-create` to analyze your project
4. Run `/rules-create` to extract coding rules (software) or define standards (general)
5. Run `/logbook-create` to start working on a ticket

## Specialized Agents

The plugin uses 17 specialized agents that handle heavy analysis outside the main conversation thread, preserving context for long work sessions:

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
| `roadmap-orchestrator` | Orchestrate roadmap creation and updates |

## Project Types

| Type | Use case |
|------|----------|
| **Software** | Applications, APIs, systems — any language or framework |
| **Academic** | Research papers, theses, dissertations |
| **Creative** | Design, art, video, music projects |
| **Business** | Business plans, operations, strategy |
| **General** | Anything else with objectives and deliverables |

## Files Created

After full lifecycle setup, your project will have:
```
project/
├── ai_files/
│   ├── schemas/              # JSON schemas (reference)
│   ├── user_pref.json        # Your preferences
│   ├── project_manifest.json # Project analysis
│   ├── project_rules.json    # Coding rules
│   ├── feasibility.json      # Feasibility analysis
│   ├── foundation.json       # Product foundation
│   ├── blueprint.json        # Product blueprint
│   └── waves/
│       ├── sub-zero/         # Validation wave
│       ├── w0/               # Definition wave
│       └── w1/               # Business waves
│           ├── roadmap.json
│           ├── logbooks/
│           └── resolutions/
└── CLAUDE.md                 # Updated with preferences
```

## Session Continuity

The plugin automatically loads your preferences and project context at the start of each session via a SessionStart hook. No manual setup needed after the initial configuration.

## Remote Repos

You can provide a GitHub URL instead of a local folder. The plugin will clone the repo, run the analysis, and save the output files to your workspace.

## Version

v1.3.1 — Aligned with Waves Framework v1.3.1

## License

AGPL-3.0-or-later
