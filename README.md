<div align="center">

# ai-behavior

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

</div>

## What is it?

A working protocol for AI agents (`Claude Code`, `Codex`, `Gemini CLI`) that provides **interactive slash commands** and **structured JSON schemas** to manage project context, coding rules, and development logbooks.

**Two ways to use it:**
1. **Slash Commands (Recommended)** - Interactive commands that guide you through each process
2. **Manual Prompts** - Copy/paste prompts to generate files from schemas

**Pattern:** Each `json_schema` contains:
- `description` = What the field represents, so the LLM understands what content to generate
- `$comment` = How the LLM should operate on that field, improving precision

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

## Quick Start (Claude Code)

### 1. Install

```bash
# Clone the repository
git clone https://github.com/exovian-developments/ai-behavior.git

# Copy to your project
mkdir -p your-project/.claude/commands
cp -r ai-behavior/.claude/commands/* your-project/.claude/commands/
mkdir -p your-project/ai_files/schemas
cp ai-behavior/schemas/*.json your-project/ai_files/schemas/
mkdir -p your-project/ai_files/logbooks
```

### 2. Initialize

In Claude Code, run:
```
/ai-behavior:project-init
```

This will:
- Ask for your preferred language (English, Español, Português, etc.)
- Configure your interaction preferences
- Set up project context (software vs general, familiarity level)
- Create `ai_files/user_pref.json`

### 3. Create Project Manifest

```
/ai-behavior:manifest-create
```

This will analyze your project and create a comprehensive manifest with technologies, architecture, features, and recommendations.

### 4. Start Working with Logbooks

```
/ai-behavior:logbook-create TICKET-123.json
```

Creates a structured logbook with objectives and completion guides for your ticket/task.

```
/ai-behavior:logbook-update TICKET-123.json
```

Update progress, change objective statuses, add new objectives discovered during work.

---

## Available Commands

| Command | Description | Status |
|---------|-------------|--------|
| `/ai-behavior:project-init` | Initialize preferences and project context | 🟢 Ready |
| `/ai-behavior:manifest-create` | Analyze project and create manifest | 🟢 Ready |
| `/ai-behavior:manifest-update` | Update existing manifest with changes | 🔴 Coming Soon |
| `/ai-behavior:rules-create` | Extract coding rules from codebase | 🟡 Needs Command |
| `/ai-behavior:rules-update` | Update rules based on code changes | 🔴 Coming Soon |
| `/ai-behavior:user-pref-create` | Create detailed user preferences | 🟡 Needs Command |
| `/ai-behavior:user-pref-update` | Edit existing preferences | 🟡 Needs Command |
| `/ai-behavior:logbook-create` | Create new development logbook | 🟢 Ready |
| `/ai-behavior:logbook-update` | Update logbook with progress | 🟢 Ready |
| `/ai-behavior:resolution-create` | Generate ticket resolution comment | 🟡 Needs Command |

**Legend:** 🟢 Ready | 🟡 Command file needed | 🔴 Subagents needed

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

---

## Project Structure

After installation, your project will have:

```
your-project/
├── .claude/
│   └── commands/
│       ├── ai-behavior:project-init.md
│       ├── ai-behavior:manifest-create.md
│       ├── ai-behavior:logbook-create.md
│       └── ai-behavior:logbook-update.md
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

The commands use 29 specialized subagents (23 implemented):

| Category | Subagents | Status |
|----------|-----------|--------|
| **Core** | project-initializer, manifest-creator-new-software, secondary-objective-generator, context-summarizer | ✅ Complete |
| **Software Analysis** | entry-point-analyzer, navigation-mapper, flow-tracker, dependency-auditor, architecture-detective, feature-extractor | ✅ Complete |
| **General Projects** | manifest-creator-academic/creative/business/generic, general-project-scanner, directory-analyzer | ✅ Complete |
| **Rules** | pattern-extractor, convention-detector, antipattern-detector, criteria-validator, standards-structurer | ✅ Complete |
| **Updates** | git-history-analyzer, autogen-detector, manifest-change-analyzer, timestamp-analyzer, manifest-updater, rule-comparator | ⏳ Pending |

See [subagents/README.md](subagents/README.md) for full details.

---

## Manual Installation (Alternative)

If you prefer not to use slash commands, you can still use the schemas directly:

### 1. Setup

```bash
git clone https://github.com/exovian-developments/ai-behavior.git
cd your-project
mkdir -p ai_files/{schemas,logbooks}
cp ai-behavior/schemas/*.json ai_files/schemas/
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

## Compatibility

| Agent | Slash Commands | Manual Prompts | Notes |
|-------|---------------|----------------|-------|
| Claude Code | ✅ | ✅ | Full support |
| Codex | ❌ | ✅ | Use prompts directly |
| Gemini CLI | ❌ | ✅ | Better with .md output |

**Note:** Gemini CLI works better producing results in `.md` format. For JSON output, it sometimes has issues with anchors.

---

## License

- Code and schemas: Apache-2.0 (see `LICENSE`)
- Documentation: CC BY 4.0 (optional)

---

## Contributing

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for architecture details and [subagents/README.md](subagents/README.md) for implementation status.

**Current priorities:**
1. Complete 6 pending subagents for update commands
2. Create remaining 5 command files
3. Test and refine all flows
