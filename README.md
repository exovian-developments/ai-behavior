<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*The Product Consciousness Framework for the AI agent era*

</div>

## Why Waves

Product development as we knew it has changed. AI agents (Claude Code, Codex, Gemini CLI) compress what used to take 6 months of development into days or weeks. 2-week sprints no longer reflect the actual rhythm of work — development is no longer the bottleneck.

But there's a deeper problem: **your AI agent has no judgment.** It treats renaming a variable the same as changing your business model. It doesn't know when to proceed and when to stop. Without classification, there's no trust — and without trust, you can't truly delegate.

Waves replaces fixed-cadence sprints with **waves**: organic, variable-length delivery cycles where each wave carries a product increment from validation to production. And with **Waves 2.0**, the agent becomes a strategic advisor with graduated autonomy — it knows your business, enforces your rules mechanically, classifies every decision by impact level, and alerts you to what you can't see because you're focused on the immediate task.

## What is it?

Waves is a Product Consciousness Framework that gives the **human + AI team**:

1. **Structure** — what artifacts exist and how they relate
2. **Order** — in what sequence value is produced
3. **Memory** — structured persistence across sessions and agents
4. **Governance** — mechanical enforcement that doesn't degrade
5. **Trust** — graduated autonomy by decision level
6. **Extended perception** — the agent sees the whole board while you focus on the piece

It works with `Claude Code` (full 2.0 features), `Claude Desktop` (plugin), `Codex`, and `Gemini CLI` through interactive slash commands and structured JSON schemas.

### The Product Lifecycle

waves organizes work into five levels, where each level builds on the previous one:

**1. Feasibility** → *Can we build this? Should we?*
You describe your idea in plain language. The agent acts as a business consultant: it analyzes the market, identifies competitors, builds revenue projections with Monte Carlo simulations, and gives you honest numbers on whether this can work. The output is a feasibility analysis with real data — not opinions.

**2. Foundation** → *What did we learn?*
The feasibility might produce thousands of simulations across multiple scenarios. The foundation compacts all of that into a clean executive summary: the validated problem, who your users are, your revenue model with unit economics, a SWOT analysis, the essential capabilities needed, timeline constraints, and a clear go/no-go signal. This is the bridge between research and product definition.

**3. Blueprint** → *What are we building, and why?*
Using the foundation as input, you define the product: its capabilities (what users can do), the user flows (how they do it), design principles, product rules, success metrics, and tech stack. Every section connects back to the business case. Nothing speculative — every capability traces to a revenue stream, every rule traces to a principle.

**4. Roadmap** → *When do we build it, and in what order?*
The roadmap takes the blueprint's capabilities and organizes them into phases with milestones, dependencies, and decision points. It answers questions like: what goes in the MVP? What can wait? What blocks what?

**5. Logbook** → *How do we implement this specific piece?*
For each ticket or task, a logbook breaks the work into main objectives and secondary objectives with completion guides. The agent implements them continuously, updates progress in real time, and preserves full context between sessions so no knowledge is lost.

```
feasibility → foundation → blueprint → roadmap → logbook
 CAN WE?    WHAT DID WE   WHAT/WHY?   WHEN?      HOW?
             LEARN?
```

Each level feeds the next. You can start at any level — if you already have a product and just need logbooks for day-to-day coding, start there. The full pipeline is for when you're building something from scratch.

### What's New in 2.0

Waves 1.x gave structure to chaos. **Waves 2.0 gives consciousness to structure.**

| Capability | What it does | How it works |
|-----------|-------------|-------------|
| **Perception** | Agent starts every session knowing the full product state | SessionStart hook reads artifacts, injects state summary + forces reading of blueprint, roadmap, logbook |
| **Mechanical Enforcement** | Rules that cannot be ignored | PreToolUse hook blocks actions (exit 2) when blueprint/roadmap/logbook are missing |
| **Decision Classification** | 5-level graduated autonomy | Classification reminder injected on every action, re-injected after compaction |
| **Proactive Metacognition** | Agent reflects at strategic moments | PostToolUse hooks trigger on objective completion, blueprint changes, phase completion |
| **Context Survival** | Rules survive long sessions | SessionStart re-fires after context compaction, re-injecting state and rules |
| **Graduated Governance** | Enforcement proportional to maturity | No blueprint → allow all; blueprint without roadmap → block; full artifacts → allow + classify |

**Decision Classification — The Trust Contract:**

| Level | Type | Agent action |
|-------|------|-------------|
| 1 | Mechanical (naming, formatting) | Proceeds silently |
| 2 | Technical (pattern, structure) | Proceeds + documents in logbook |
| 3 | Scope (outside current objective) | **STOPS.** Informs. Waits. |
| 4 | Business (affects blueprint capability) | **STOPS.** Projects scenarios. Waits. |
| 5 | Discovery (independent market value) | **STOPS.** Documents. Projects. Advises. |

> When in doubt, the agent classifies **UP** (more caution), never down. Validated with 18 benchmark scenarios: 100% correct actions.

**Platform availability:** Full 2.0 features (hooks, enforcement, metacognition) require Claude Code. Schema-based features (artifacts, persistence, commands) work on all platforms.

### Three ways to use it

1. **Cowork Plugin (Recommended)** — Install the plugin in Claude desktop for full GUI experience
2. **Slash Commands** — Interactive commands for Claude Code CLI
3. **Manual Prompts** — Copy/paste prompts to generate files from schemas

### How the schemas work

Each JSON schema uses a dual-instruction pattern:

- `description` = What the field represents, so the LLM understands what content to generate
- `$comment` = How the LLM should operate on that field, improving precision and consistency

---

## Features

| Feature | Description |
|---------|-------------|
| **Perception** | Agent starts every session informed — product state, active wave, current phase, next objective |
| **Enforcement** | Mechanical hooks that block actions when artifacts are missing — not suggestions, code |
| **Classification** | 5-level decision autonomy — agent knows when to proceed and when to stop |
| **Metacognition** | Proactive reflection at objective completion, blueprint changes, and phase completion |
| **Multi-Agent** | Same files work across Claude Code, Claude Desktop, Codex, and Gemini CLI |
| **Multi-Session** | Logbooks + hooks preserve context between sessions and after compaction |
| **Software + General** | Supports software projects AND academic, creative, business projects |
| **Business Validation** | Feasibility analysis with Monte Carlo simulations before writing a line of code |

---

## Quick Start (Cowork Plugin)

### Install

Download `waves.plugin` from [Releases](https://github.com/exovian-developments/waves/releases) and double-click to install in Claude desktop. Or build from source:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

### Usage

Once installed, the plugin auto-loads your project context on session start. Use slash commands:

```
/project-init          # Initialize preferences and project context
/manifest-create       # Analyze project and create manifest
/logbook-create        # Create work logbook with objectives
/logbook-update        # Track progress on objectives
```

The plugin dispatches analysis work to 16 specialized agents, keeping the main thread lean for long work sessions.

See [`plugin/README.md`](plugin/README.md) for full plugin documentation.

---

## Quick Start (Claude Code)

### 1. Install

**Option A: Homebrew (recommended)**

```bash
brew tap exovian-developments/waves
brew install waves

# Initialize in your project
cd your-project
waves init claude
```

**Option B: Manual**

```bash
# Clone the repository
git clone https://github.com/exovian-developments/waves.git

# Copy to your project
mkdir -p your-project/.claude/{commands,hooks}
cp -r waves/.claude/commands/* your-project/.claude/commands/
cp waves/.claude/hooks/*.sh your-project/.claude/hooks/
chmod +x your-project/.claude/hooks/*.sh
cp waves/.claude/settings.json your-project/.claude/settings.json
mkdir -p your-project/ai_files/schemas
cp waves/schemas/*.json your-project/ai_files/schemas/
```

**Updating an existing project:**

```bash
# With Homebrew:
brew upgrade waves
cd your-project && waves update

# Or from local clone:
cd your-project
/path/to/waves/bin/waves update
```

### 2. Initialize

In Claude Code, run:
```
/waves:project-init
```

This will:
- Ask for your preferred language (English, Español, Português, etc.)
- Configure your interaction preferences
- Set up project context (software vs general, familiarity level)
- Create `ai_files/user_pref.json`

### 3. Create Project Manifest

```
/waves:manifest-create
```

This will analyze your project and create a comprehensive manifest with technologies, architecture, features, and recommendations.

### 4. Start Working with Logbooks

```
/waves:logbook-create TICKET-123.json
```

Creates a structured logbook with objectives and completion guides for your ticket/task.

```
/waves:logbook-update TICKET-123.json
```

Update progress, change objective statuses, add new objectives discovered during work.

---

## Available Commands

| Command | Description | Status |
|---------|-------------|--------|
| `/waves:project-init` | Initialize preferences and project context | 🟢 Ready |
| `/waves:manifest-create` | Analyze project and create manifest | 🟢 Ready |
| `/waves:manifest-update` | Update existing manifest with changes | 🟢 Ready |
| `/waves:rules-create` | Extract coding rules from codebase | 🟢 Ready |
| `/waves:rules-update` | Update rules based on code changes | 🟢 Ready |
| `/waves:user-pref-create` | Create detailed user preferences | 🟢 Ready |
| `/waves:user-pref-update` | Edit existing preferences | 🟢 Ready |
| `/waves:logbook-create` | Create new development logbook | 🟢 Ready |
| `/waves:logbook-update` | Update logbook with progress | 🟢 Ready |
| `/waves:resolution-create` | Generate ticket resolution document | 🟢 Ready |
| `/waves:objectives-implement` | Implement logbook objectives with auditing | 🟢 Ready |
| `/waves:roadmap-create` | Create product-level roadmap with phases and milestones | 🟢 Ready |
| `/waves:roadmap-update` | Update roadmap progress, decisions, and phases | 🟢 Ready |
| `/waves:feasibility-analyze` | Pre-blueprint feasibility analysis with Monte Carlo and Bayesian projections | 🟢 Ready |
| `/waves:foundation-create` | Compact feasibility into validated facts, re-classified capabilities, and financial benchmarks | 🟢 Ready |
| `/waves:blueprint-create` | Create complete product blueprint from foundation with owner validation | 🟢 Ready |

**Legend:** 🟢 Ready

---

## Schemas

| Schema | Purpose | Project Type |
|--------|---------|--------------|
| `user_pref_schema.json` | User interaction preferences | Both |
| `software_manifest_schema.json` | Software project structure and tech | Software |
| `general_manifest_schema.json` | Non-software project structure | General |
| `project_rules_schema.json` | Coding rules and patterns | Software |
| `project_standards_schema.json` | Standards for general projects | General |
| `logbook_software_schema.json` | Development logbook with code refs | Software |
| `logbook_general_schema.json` | Task logbook with doc refs | General |
| `ticket_resolution_schema.json` | Ticket closure summary | Software |
| `logbook_roadmap_schema.json` | Product-level roadmap with phases and milestones | Both |
| `feasibility_analysis_schema.json` | Pre-blueprint feasibility analysis with projections | Both |
| `product_foundation_schema.json` | Compacted feasibility → blueprint bridge | Both |

---

## Project Structure

After installation, your project will have:

```
your-project/
├── .claude/
│   ├── settings.json               # Hooks configuration (Waves 2.0)
│   ├── commands/                    # Slash commands
│   │   ├── waves:project-init.md
│   │   ├── waves:blueprint-create.md
│   │   ├── waves:roadmap-create.md
│   │   ├── waves:logbook-create.md
│   │   └── ... (16 commands total)
│   └── hooks/                       # Executable hooks (Waves 2.0)
│       ├── waves-perceive.sh        # SessionStart: injects product state
│       ├── waves-gate.sh            # PreToolUse: graduated enforcement
│       ├── waves-doc-enforce.sh     # PostToolUse: documentation enforcement
│       ├── waves-metacognition.sh   # PostToolUse: reflection triggers
│       ├── waves-blueprint-impact.sh # PostToolUse: impact projection
│       ├── waves-phase-audit.sh     # PostToolUse: strategic audit
│       └── waves-dart-analyze.sh    # PostToolUse: dart analysis
├── ai_files/
│   ├── schemas/                     # JSON schemas
│   ├── user_pref.json               # Your preferences
│   ├── project_manifest.json        # Project analysis
│   ├── project_rules.json           # Coding rules
│   ├── blueprint.json               # Product definition (WHAT/WHY)
│   └── waves/
│       └── wN/
│           ├── roadmap.json         # Wave plan (WHEN/ORDER)
│           └── logbooks/            # Implementation (HOW/DETAIL)
└── CLAUDE.md                        # Agent Operating Protocol
```

---

## Workflow

### For Software Projects

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │  rules-create   │
│  (preferences)  │     │ (analyze project)│     │ (extract rules) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                          │
         ┌────────────────────────────────────────────────┘
         ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ logbook-create  │ ──▶ │  logbook-update  │ ──▶ │resolution-create│
│  (new ticket)   │     │   (track work)   │     │ (close ticket)  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

### For General Projects (Academic, Creative, Business)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │ logbook-create  │
│  (preferences)  │     │ (define project) │     │  (track tasks)  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

---

## Manifest Creation Flows

The `manifest-create` command adapts to your project:

### Software Projects
- **A1: New Project** - 5 questions to define stack and features
- **A2.1: Existing (Known)** - 2 checkpoints + 6 parallel analyzers
- **A2.2: Existing (Unknown)** - Zero questions, full analysis with progress prints

### General Projects
- **B1: Academic** - Research topic, methodology, milestones, citations
- **B2: Creative** - Concept, style, assets, deliverables
- **B3: Business** - 9-question Business Model Canvas
- **B4: Other** - Generic objectives and deliverables
- **BE: Existing** - Directory discovery and content analysis

---

## Specialized Subagents

The commands use 33 specialized subagents:

| Category | Subagents | Status |
|----------|-----------|--------|
| **Core** | project-initializer, manifest-creator-new-software, secondary-objective-generator, context-summarizer | ✅ Complete |
| **Software Analysis** | entry-point-analyzer, navigation-mapper, flow-tracker, dependency-auditor, architecture-detective, feature-extractor | ✅ Complete |
| **General Projects** | manifest-creator-academic/creative/business/generic, general-project-scanner, directory-analyzer | ✅ Complete |
| **Rules** | pattern-extractor, convention-detector, antipattern-detector, criteria-validator, standards-structurer | ✅ Complete |
| **Updates** | git-history-analyzer, autogen-detector, manifest-change-analyzer, timestamp-analyzer, manifest-updater, rule-comparator | ✅ Complete |
| **Implementation** | code-implementer, code-auditor | ✅ Complete |
| **Roadmap** | roadmap-creator, roadmap-updater | ✅ Complete |

See [subagents/README.md](subagents/README.md) for full details.

---

## Manual Installation (Alternative)

If you prefer not to use slash commands, you can still use the schemas directly:

### 1. Setup

```bash
git clone https://github.com/exovian-developments/waves.git
cd your-project
mkdir -p ai_files/schemas .claude/{commands,hooks}
cp waves/schemas/*.json ai_files/schemas/
cp waves/.claude/commands/*.md .claude/commands/
cp waves/.claude/hooks/*.sh .claude/hooks/ && chmod +x .claude/hooks/*.sh
cp waves/.claude/settings.json .claude/settings.json
```

### 2. Add to CLAUDE.md

```markdown
# Key files to review on session start:
required_reading:
  - path: "ai_files/project_manifest.json"
    description: "Project structure, technologies, architecture"
    when: "always"

  - path: "ai_files/project_rules.json"
    description: "Coding rules and conventions to follow"
    when: "always"

  - path: "ai_files/user_pref.json"
    description: "User interaction preferences"
    when: "always"

  - path: "ai_files/logbooks/"
    description: "Development logbooks for tickets"
    when: "always"
```

### 3. Use Prompts

**Create User Preferences:**
```
Analyze ai_files/schemas/user_pref_schema.json and ask me questions to generate ai_files/user_pref.json. Be concise and follow the schema structure.
```

**Create Project Manifest:**
```
Analyze ai_files/schemas/software_manifest_schema.json, then analyze this project thoroughly (all directories and files). Generate ai_files/project_manifest.json following the schema.
```

**Create Logbook:**
```
Analyze ai_files/schemas/logbook_software_schema.json. Based on the ticket I'll describe, create a logbook with objectives and completion guides.
```

---

## Logbook Structure

Each logbook contains:

```json
{
  "ticket": {
    "title": "Implement GET /products/:id endpoint",
    "url": "https://jira.company.com/PROJ-123",
    "description": "Full ticket details..."
  },
  "objectives": {
    "main": [
      {
        "id": 1,
        "content": "Endpoint returns product with specifications",
        "context": "Frontend needs complete data for detail page",
        "scope": {
          "files": ["src/controllers/ProductController.ts"],
          "rules": [3, 7]
        },
        "status": "active"
      }
    ],
    "secondary": [
      {
        "id": 1,
        "content": "ProductDetailDTO includes specifications array",
        "completion_guide": [
          "Use pattern from src/dtos/BaseDTO.ts:12",
          "Apply rule #3: @Expose() decorators"
        ],
        "status": "not_started"
      }
    ]
  },
  "recent_context": [
    {
      "id": 1,
      "created_at": "2025-12-11T10:00:00Z",
      "content": "Logbook created. Ready to start."
    }
  ],
  "history_summary": [],
  "future_reminders": []
}
```

**Status values:** `not_started`, `active`, `blocked`, `achieved`, `abandoned`

---

## Conventions

- **IDs:** Integer starting at 1, immutable once created
- **Timestamps:** UTC ISO 8601, `created_at` immutable
- **Context limit:** 20 recent entries, auto-compacts to history_summary
- **History limit:** 10 summaries max
- **YAGNI:** All completion guides apply the YAGNI principle

---

## Validation

```bash
# Node (AJV)
npx ajv validate -s ai_files/schemas/logbook_software_schema.json -d ai_files/logbooks/TICKET-123.json

# Python
python -c "import json,jsonschema; jsonschema.validate(json.load(open('data.json')), json.load(open('schema.json')))"
```

---

## Repository Structure

```
waves/
├── bin/waves             # CLI installer (brew install waves)
├── schemas/              # Source of truth: JSON schemas
├── .claude/
│   ├── commands/         # 16 executable slash commands
│   ├── hooks/            # 7 Waves 2.0 hooks (perceive, gate, enforce, metacognition, ...)
│   └── settings.json     # Hook configuration (SessionStart, PreToolUse, PostToolUse)
├── plugin/               # Cowork plugin (Claude Desktop)
│   ├── agents/           # Specialized agents
│   ├── commands/         # Slash commands
│   ├── skills/           # Protocol knowledge + schema references
│   └── hooks/            # SessionStart prompt-based hook
├── subagents/            # Canonical design: subagent specifications
├── commands/             # Command design docs (numbered, detailed)
├── FRAMEWORK.md          # Complete framework documentation (v2.0)
├── CHANGELOG.md          # Version history
└── README.md
```

---

## Compatibility

| Platform | Hooks (2.0) | Plugin | Slash Commands | Manual Prompts |
|----------|-------------|--------|---------------|----------------|
| Claude Code | ✅ Full (enforcement, metacognition, classification) | ❌ | ✅ | ✅ |
| Claude Desktop | ❌ | ✅ (prompt-based perception) | ✅ | ✅ |
| Codex | ❌ | ❌ | ❌ | ✅ |
| Gemini CLI | ❌ | ❌ | ❌ | ✅ |

**Note:** Hooks-based features (mechanical enforcement, metacognition, decision classification) are currently exclusive to Claude Code. Schema-based features (artifacts, persistence, commands) work on all platforms.

---

## License

- Code and schemas: AGPL-3.0-or-later (see `LICENSE`)
- Documentation: CC BY 4.0 (optional)

---

## Contributing

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for architecture details and [subagents/README.md](subagents/README.md) for implementation status.

**Current priorities:**
1. Community feedback on decision classification levels
2. Hooks support for additional platforms (Codex, Gemini CLI) if requested
3. Keep plugin agents in sync with canonical subagent changes
