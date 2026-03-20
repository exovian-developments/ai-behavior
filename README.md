<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*The product development framework for the AI agent era*

</div>

## Why Waves

Product development as we knew it has changed. AI agents (Claude Code, Codex, Gemini CLI) compress what used to take 6 months of development into days or weeks. 2-week sprints no longer reflect the actual rhythm of work — development is no longer the bottleneck.

Waves replaces fixed-cadence sprints with **waves**: organic, variable-length delivery cycles where each wave carries a product increment from validation to production. A wave lasts as long as it needs — sometimes 3 days, sometimes 3 weeks. No artificial ceremonies, no arbitrary time boxes.

## What is it?

Waves is a structured protocol that guides AI agents through the **entire lifecycle of a product** — from the first idea to production code. It works with `Claude Code`, `Codex`, and `Gemini CLI` through interactive slash commands and structured JSON schemas.

Instead of giving your AI agent a blank prompt and hoping for the best, waves walks it through a clear process: first understand if the idea is viable, then define what to build, then plan in what order, and finally write the code — with full context at every step.

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
| **Global Context** | Project manifests, coding rules, user preferences |
| **Focused Context** | Development logbooks for tickets/tasks with objectives and progress tracking |
| **Multi-Agent** | Same files work across Claude Code, Codex, and Gemini CLI |
| **Multi-Session** | Logbooks preserve context between sessions |
| **Software + General** | Supports software projects AND academic, creative, business projects |

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
mkdir -p your-project/.claude/commands
cp -r waves/.claude/commands/* your-project/.claude/commands/
mkdir -p your-project/ai_files/schemas
cp waves/schemas/*.json your-project/ai_files/schemas/
mkdir -p your-project/ai_files/logbooks
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
│   └── commands/
│       ├── waves:project-init.md
│       ├── waves:manifest-create.md
│       ├── waves:logbook-create.md
│       └── waves:logbook-update.md
├── ai_files/
│   ├── schemas/                    # JSON schemas
│   │   ├── user_pref_schema.json
│   │   ├── software_manifest_schema.json
│   │   ├── logbook_software_schema.json
│   │   └── ...
│   ├── logbooks/                   # Your work logbooks
│   │   └── TICKET-123.json
│   ├── user_pref.json              # Your preferences
│   └── project_manifest.json       # Project analysis
└── CLAUDE.md                       # Updated with preferences reference
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
mkdir -p ai_files/{schemas,logbooks}
cp waves/schemas/*.json ai_files/schemas/
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
├── schemas/              # Source of truth: 10 JSON schemas
├── subagents/            # Canonical design: 33 subagent specifications
├── commands/             # Command design docs (numbered, detailed)
├── .claude/commands/     # Executable slash commands for Claude Code
├── plugin/               # Cowork plugin (Claude desktop)
│   ├── .claude-plugin/   #   Plugin manifest
│   ├── agents/           #   17 specialized agents
│   ├── commands/         #   13 slash commands
│   ├── skills/           #   Protocol knowledge + schema references
│   └── hooks/            #   SessionStart auto-context hook
├── example_flutter/      # Example: Flutter project
├── example_java/         # Example: Java project
├── example_web/          # Example: Web project
├── CHANGELOG.md          # Version history with subagent-to-agent mapping
├── IMPLEMENTATION_GUIDE.md
└── README.md
```

The `schemas/` and `subagents/` directories are the canonical design. The `plugin/` directory is an adapted implementation for the Cowork plugin format (17 agents consolidated from 33 subagents). See [CHANGELOG.md](CHANGELOG.md) for the mapping.

---

## Compatibility

| Platform | Plugin | Slash Commands | Manual Prompts | Notes |
|----------|--------|---------------|----------------|-------|
| Claude Desktop (Cowork) | ✅ | ✅ | ✅ | Full support via plugin |
| Claude Code | ❌ | ✅ | ✅ | Full support via .claude/commands/ |
| Codex | ❌ | ❌ | ✅ | Use prompts directly |
| Gemini CLI | ❌ | ❌ | ✅ | Better with .md output |

**Note:** Gemini CLI works better producing results in `.md` format. For JSON output, it sometimes has issues with anchors.

---

## License

- Code and schemas: Apache-2.0 (see `LICENSE`)
- Documentation: CC BY 4.0 (optional)

---

## Contributing

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for architecture details and [subagents/README.md](subagents/README.md) for implementation status.

**Current priorities:**
1. Test and refine all flows end-to-end
2. Gather user feedback on command usability
3. Keep plugin agents in sync with canonical subagent changes
