# ai-behavior: Implementation Guide
**Version:** 1.0.0
**Date:** 2025-11-21
**Status:** ✅ DESIGN COMPLETE - Ready for Implementation Phase

---

## 📋 Table of Contents
1. [Overview](#overview)
2. [Why This Implementation](#why-this-implementation)
3. [Key Decisions](#key-decisions)
4. [Installation Design](#installation-design)
5. [Command Index](#command-index)
6. [Command Details](#command-details)
7. [Iterative Design Process](#iterative-design-process)

---

## 🎯 Overview

**What we're building:**
A protocol for AI agents (Claude Code, Codex, Gemini CLI) that provides structured JSON schemas to enable:
- **Global project context** - Project manifests, coding rules, user preferences
- **Focused task context** - Development logbooks that maintain context across sessions and agents

**Implementation approach:**
Transform existing JSON schemas into **interactive Claude Code slash commands** that guide users through structured conversations to generate and maintain these context files.

**Inspiration:**
Based on the [Agent OS framework](https://github.com/cased/agent-os) architecture, which provides:
- Multi-agent orchestration patterns
- Workflow composition and reusability
- Interactive command flows with user guidance
- Compilation system for template processing

---

## 💡 Why This Implementation

### **Problem Being Solved:**
Currently, users must:
1. Manually read schema files to understand structure
2. Memorize complex prompts to generate JSON files
3. Remember multi-step workflows for each task
4. Manually maintain consistency across files
5. Handle complex logic (e.g., compacting logbook history when it exceeds limits)

### **Solution:**
Interactive commands that:
- **Guide users** through questions based on schema requirements
- **Automate complex logic** (array compaction, objective management, validation)
- **Provide progressive disclosure** - show tips for faster usage as users learn
- **Work universally** - Same files can be used across Claude Code, Codex, Gemini CLI
- **Maintain context** - Logbooks preserve work across sessions and agent switches

### **Benefits:**
- ✅ Lower cognitive load - No need to memorize schemas
- ✅ Faster execution - Commands automate repetitive tasks
- ✅ Fewer errors - Built-in validation and schema compliance
- ✅ Better UX - Interactive, conversational, with progressive tips
- ✅ Scalable - Easy to add new commands as schemas evolve

---

## 🔑 Key Decisions

### **1. Dual-Mode Commands (With/Without Parameters)**
**Decision:** All commands that can accept parameters will support BOTH modes:
- **With parameter:** `/ai-behavior:update-logbook CALC-001.json` → Fast execution
- **Without parameter:** `/ai-behavior:update-logbook` → Interactive selection + Educational tip

**Rationale:**
- New users discover commands through exploration (no parameters needed)
- Experienced users can skip steps with parameters
- Tips educate users about faster workflows without being intrusive
- Maintains consistency with familiar CLI patterns (git, npm, etc.)

**Implementation:**
```markdown
```bash
if [ -z "$ARGUMENTS" ]; then
    echo "💡 TIP: Speed up with: /command-name [param]"
    echo ""
fi
```

{{IF $ARGUMENTS}}
  # Fast path - use parameter directly
{{ENDIF}}

{{UNLESS $ARGUMENTS}}
  # Interactive path - ask user
{{ENDUNLESS}}
```

### **2. Multi-Agent Architecture**
**Decision:** Use Claude Code subagents for specialized tasks

**Rationale:**
- Better context separation (each agent focuses on one task)
- Reusable agents across multiple commands
- Clearer responsibilities and easier debugging
- Follows Agent OS proven patterns

**Pattern:**
- **Main Agent** (orchestrator) - Handles user interaction, shows questions/results
- **Subagents** (workers) - Execute specialized tasks, return output to main agent
- **Workflows** (instructions) - Reusable instruction snippets injected into agents

### **3. Workflow Composition**
**Decision:** Break complex logic into reusable workflow files

**Rationale:**
- Single source of truth for each task
- Easy to update (change once, affects all commands using it)
- Prevents duplication across agents
- Clear separation of concerns

**Example:**
```
workflows/
  logbook/
    gather-ticket-info.md      → Ask ticket questions
    update-recent-context.md   → Add entries to logbook
    compact-history.md         → Handle 20-item limit logic
    manage-objectives.md       → Move objectives between arrays
```

### **4. Homebrew Installation + CLI Init**
**Decision:** Install via Homebrew + provide `ai-behavior init` command

**Rationale:**
- Familiar pattern for developers (`brew install` + `init`)
- Matches mental model of `git init`, `npm init`, etc.
- Professional, standard installation process
- Easy to update via `brew upgrade`

**User Journey:**
```bash
# Install (one time)
brew tap exovian-developments/tap
brew install ai-behavior

# Initialize in project (like git init)
cd /path/to/project
ai-behavior init

# Verify installation
ls .claude/commands/ai-behavior/
```

### **5. Schema-First Design**
**Decision:** Each command is designed by analyzing its schema first

**Rationale:**
- Schemas define the contract (what data is needed)
- Commands become interfaces to fulfill schemas
- Reduces risk of missing required fields
- Ensures validation alignment

**Process (Iterative):**
1. Read schema JSON → Understand structure
2. Read README.md → Understand intended usage
3. Design command flow → Map schema fields to questions
4. Get user approval → Iterate on flow
5. Document final flow → Ready for implementation

---

## 🏗️ Installation Design

### **Homebrew Formula Structure**

```ruby
# Formula: exovian-developments/tap/ai-behavior.rb
class AiBehavior < Formula
  desc "Interactive protocol for AI agents with structured context management"
  homepage "https://github.com/exovian-developments/ai-behavior"
  url "https://github.com/exovian-developments/ai-behavior/archive/v1.0.0.tar.gz"
  sha256 "..."

  def install
    # Install core files
    prefix.install "schemas", "profiles", "scripts", "config.yml"

    # Install CLI binary
    bin.install "scripts/ai-behavior-cli.sh" => "ai-behavior"
  end

  def caveats
    <<~EOS
      ai-behavior has been installed!

      To initialize in your project, run:
        cd /path/to/your/project
        ai-behavior init
    EOS
  end
end
```

### **CLI Commands**

```bash
# Install globally via Homebrew
brew tap exovian-developments/tap
brew install ai-behavior

# Available CLI commands:
ai-behavior init                    # Initialize in current project
ai-behavior update                  # Update existing installation
ai-behavior version                 # Show version
ai-behavior help                    # Show help
```

### **Project Initialization Flow**

When user runs `ai-behavior init`:

1. **Check prerequisites:**
   - Is this a git repository? (warn if not)
   - Does `.claude/` directory exist? (recommend installing Claude Code if not)
   - Already initialized? (ask to overwrite or skip)

2. **Create directory structure:**
   ```
   ai_files/
     schemas/           ← Copy from Homebrew installation
     logbooks/          ← Empty, user creates logbooks here
   ```

3. **Install Claude Code commands:**
   ```
   .claude/
     commands/
       ai-behavior/     ← Compiled command files
     agents/
       ai-behavior/     ← Subagent definitions
   ```

4. **Create config:**
   ```
   ai_files/config.yml  ← Project-specific configuration
   ```

5. **Update .gitignore:**
   ```
   # Add if not present:
   ai_files/logbooks/
   ```

6. **Show next steps:**
   ```
   ✅ ai-behavior initialized!

   Get started:
     /ai-behavior:create-user-pref       → Set your preferences
     /ai-behavior:create-project-manifest → Analyze your project

   Learn more: https://github.com/exovian-developments/ai-behavior
   ```

### **Update Flow**

When user runs `ai-behavior update`:

1. Compare installed version vs Homebrew version
2. Backup existing `ai_files/` (optional, ask user)
3. Update schemas (preserve user-created files)
4. Recompile commands with new templates
5. Show changelog of what changed

---

## 📑 Command Index

### **Initialization Command** (Run once per project)
1. `/ai-behavior:project-init` - **NEW** Interactive first-time setup (language, tone, essential prefs)

### **Global Context Commands** (Run once or occasionally)
2. `/ai-behavior:user-pref-create` - Create detailed user interaction preferences
3. `/ai-behavior:manifest-create` - Analyze project and generate manifest
4. `/ai-behavior:manifest-update` - Update existing manifest
5. `/ai-behavior:rules-create [layer]` - Create coding rules for layer
6. `/ai-behavior:rules-update [layer]` - Update rules for layer

### **Focused Context Commands** (Daily development work)
7. `/ai-behavior:logbook-create [filename]` - Create new ticket logbook
8. `/ai-behavior:logbook-update [filename]` - Update logbook with progress
9. `/ai-behavior:resolution-create [filename]` - Generate resolution comment

---

## 📖 Command Details

> **Note:** Detailed command designs have been moved to separate files in the `commands/` directory for better organization and maintainability.

### **1. `/ai-behavior:project-init`** ✅ DESIGNED

**Purpose:** Quick essential setup - Create `ai_files/user_pref.json` with interaction preferences AND project context

**📄 Full Design:** [`commands/01-project-init.md`](commands/01-project-init.md)

**Quick Summary:**
- **Questions:** 6 (Language, Name+Role, Project Type, Familiarity, Tone, Explanation)
- **Outputs:** `ai_files/user_pref.json` + Updated `CLAUDE.md`
- **Parameters:** None (always interactive)
- **Subagents:** 1 (project-initializer)
- **Workflows:** 6

---

### **2. `/ai-behavior:manifest-create`** ✅ DESIGNED

**Purpose:** Analyze project and create manifest file based on project type (software or general)

**📄 Full Design:** [`commands/02-manifest-create.md`](commands/02-manifest-create.md)

**Quick Summary:**
- **Flows:** 7 derivations (A1, A2.1, A2.2, B1, B2, B3, B4)
- **Outputs:** Multiple manifests depending on project type + `architecture_map.json` (for existing software)
- **Parameters:** None (uses context from `user_pref.json`)
- **Subagents:** 13 (7 orchestrators + 6 specialized analyzers)
- **Workflows:** 15

**Flow Derivations:**
- **A1:** Software Nuevo → 5 questions → Template manifest
- **A2.1:** Software Existente Conocido → 3 checkpoints → 6 subagents → Manifest + architecture map
- **A2.2:** Software Existente Desconocido → 0 questions → Progress prints → 6 subagents → Educational output
- **B1:** Académico → 5 questions → Research manifest
- **B2:** Creativo → 5 questions → Creative manifest
- **B3:** Negocio → 9 questions (Business Canvas) → Business manifest
- **B4:** Otro → 5 questions → General manifest

---

### **3. `/ai-behavior:manifest-update`** ✅ DESIGNED

**Purpose:** Detect changes since last manifest update and intelligently update the manifest

**📄 Full Design:** [`commands/03-manifest-update.md`](commands/03-manifest-update.md)

**Quick Summary:**
- **Flows:** 2 (Git-based for precise history, Timestamp-based for non-git projects)
- **Input:** Existing manifest + `last_updated` date as baseline
- **Output:** Updated manifest with refreshed `last_updated`
- **Parameters:** None (auto-detects changes)
- **Subagents:** 5 (git-history-analyzer, autogen-detector, manifest-change-analyzer, timestamp-analyzer, manifest-updater)
- **Workflows:** 6

**Flow Derivations:**
- **A:** Git-based → History analysis → Filter autogenerated → Deduplicate → Criteria check → Update
- **B:** Timestamp-based → File dates → Change detection → Criteria check → Update (also covers general projects)

**Update Criteria (inferred from schema):**
- New architectural layer (services, controllers, etc.)
- New feature module
- New business flow or API endpoint
- Tech stack changes (new dependencies)
- Entry point changes

---

### **4. `/ai-behavior:rules-create [layer]`** ✅ DESIGNED

**Purpose:** Create development rules/standards based on code analysis (software) or user definition (general)

**📄 Full Design:** [`commands/04-rules-create.md`](commands/04-rules-create.md)

**Quick Summary:**
- **Flows:** 2 (Software layer-based analysis, General user-guided)
- **Outputs:** `project_rules.json` (software), `*_standards.json` (general)
- **Parameters:** `[layer]` for software (optional)
- **Subagents:** 5 (pattern-extractor, convention-detector, antipattern-detector, criteria-validator, standards-structurer)
- **Workflows:** 6

**Flow Derivations:**
- **A:** Software → Layer analysis → Pattern extraction → Antipattern detection → Criteria validation → Rules file
- **B:** General → Show suggestions → User describes needs → Structure input → Standards file

**Key Features:**
- **Criteria from schema:** 5 mandatory criteria + YAGNI principle
- **Antipattern detector:** Educational agent that identifies bad practices with explanations and suggestions
- **Manifest-driven:** Uses project_manifest.json for context (layers, framework, language)
- **General projects:** Free-form, user-guided (not rigid questions)

---

### **5. `/ai-behavior:rules-update [layer]`** ✅ DESIGNED

**Purpose:** Detect code changes and propose rule updates/deprecations

**📄 Full Design:** [`commands/05-rules-update.md`](commands/05-rules-update.md)

**Quick Summary:**
- **Flows:** 3 (Git-based, Timestamp-based, General user-guided)
- **Input:** Existing rules + change detection
- **Output:** Updated rules with new/modified/deprecated entries
- **Key feature:** Only re-analyzes CHANGED files, not entire codebase

---

### **6. `/ai-behavior:user-pref-create`** ✅ DESIGNED

**Purpose:** Create complete user preferences file with ALL options from schema (advanced setup)

**📄 Full Design:** [`commands/06-user-pref-create.md`](commands/06-user-pref-create.md)

**Quick Summary:**
- **Input:** User answers to guided questions
- **Output:** `ai_files/user_pref.json` (complete)
- **Parameters:** None
- **Difference from project-init:** ALL preferences, detailed configuration (vs 5 essential questions)

---

### **7. `/ai-behavior:user-pref-update`** ✅ DESIGNED

**Purpose:** Allow user to update preferences by opening the file in system's default editor

**📄 Full Design:** [`commands/07-user-pref-update.md`](commands/07-user-pref-update.md)

**Quick Summary:**
- **Input:** Existing `ai_files/user_pref.json`
- **Output:** User-modified `ai_files/user_pref.json`
- **Parameters:** None
- **Key feature:** Opens in system editor (VS Code, TextEdit, nano, vim)

---

### **9. `/ai-behavior:logbook-create [filename]`** ✅ DESIGNED

**Purpose:** Create a new development logbook with structured objectives and actionable guidance

**📄 Full Design:** [`commands/09-logbook-create.md`](commands/09-logbook-create.md)

**Quick Summary:**
- **Flows:** 2 (Software with code analysis, General without)
- **Outputs:** `ai_files/logbooks/[filename].json`
- **Parameters:** `[filename]` (optional)
- **Subagents:** 1 (secondary-objective-generator)

**Key Features:**
- Interactive ticket/task clarification with validation
- Code tracing using project_manifest.json and project_rules.json
- Main objectives with `scope` (files + rules)
- Secondary objectives with `completion_guide` based on deep analysis
- User validation at key checkpoints (analysis, main objectives, secondary objectives)

**Schema Features:**
- Unified `objectives` object with status field
- Main objectives with `context`, `scope.files`, `scope.rules`
- Secondary objectives with `completion_guide`
- Status enum: `not_started`, `active`, `blocked`, `achieved`, `abandoned`

---

### **10. `/ai-behavior:logbook-update [filename]`** ✅ DESIGNED

**Purpose:** Update an existing logbook with progress, findings, and objective status changes

**📄 Full Design:** [`commands/10-logbook-update.md`](commands/10-logbook-update.md)

**Quick Summary:**
- **Operations:** 4 (Add progress, Update status, Add objective, Add reminder)
- **Input/Output:** `ai_files/logbooks/[filename].json`
- **Parameters:** `[filename]` (optional)
- **Subagents:** 1 (context-summarizer)

**Key Features:**
- Due reminder check at session start
- Current status display with objective tables
- Auto-compaction when `recent_context > 20`
- Auto-check main completion when all secondary achieved
- Quick update mode: detects session progress and proposes entries

**Operations:**
1. **Add progress** → New context entry with optional mood
2. **Update status** → Change objective state with auto-documentation
3. **Add objective** → New main (with scope) or secondary (with guide)
4. **Add reminder** → Schedule future notification

---

### **8. `/ai-behavior:resolution-create [logbook]`** ✅ DESIGNED

**Purpose:** Generate resolution comment from logbook

**📄 Full Design:** [`commands/08-resolution-create.md`](commands/08-resolution-create.md)

**Schema:** `ai_files/schemas/ticket_resolution_schema.json`

**Output:** Markdown comment (displayed on screen, not saved)

**Quick Summary:**
- **Input:** Logbook file (parameter or selection)
- **Output:** Resolution markdown in `ai_files/resolutions/`
- **Parameters:** `[logbook]` (optional)

**Key Features:**
- **Software projects only** (general projects use logbook as documentation)
- Extracts objectives, findings, decisions from logbook
- Generates structured resolution document

---

## 🔄 Iterative Design Process

### **Process Steps (Per Command):**

For each command listed above, we will follow this iterative cycle:

#### **Step 1: Schema Analysis**
- Read the JSON schema file thoroughly
- Identify all required vs optional fields
- Understand field constraints (maxItems, maxLength, etc.)
- Note special logic ($comment fields with instructions)
- Review README.md for intended usage patterns

#### **Step 2: Identify Optimal Flow**
- Determine if command needs parameters
- Map schema fields to user questions
- Identify which tasks can be automated
- Plan subagent responsibilities
- Design workflow breakdowns

#### **Step 3: Present Proposal**
- Document proposed flow in structured format
- Show user questions and interaction points
- Explain automation decisions
- Highlight any deviations from README prompts
- Present for review

#### **Step 4: Await User Feedback**
- 🛑 **STOP and wait for user response**
- User provides: ✅ Approval, 🔄 Adjustments, or ❌ Redesign
- Discuss any concerns or improvements
- Iterate on proposal as needed

#### **Step 5: Document Final Flow**
- Write approved flow in this document
- Update command status to: ✅ DESIGNED
- Move to next command

#### **Step 6: Repeat**
- Continue with next command in index
- When all commands are ✅ DESIGNED → Begin implementation

---

## 📊 Command Design Status Tracker

| # | Command | Status | Parameters | Notes |
|---|---------|--------|------------|-------|
| 1 | `project-init` | ✅ DESIGNED | None | Essential setup - 5 questions + language |
| 2 | `manifest-create` | ✅ DESIGNED | None | 8 flows (A1, A2.1, A2.2, BE, B1-B4) |
| 3 | `manifest-update` | ✅ DESIGNED | None | 2 flows (Git-based, Timestamp-based) |
| 4 | `rules-create` | ✅ DESIGNED | `[layer]` | 2 flows (Software analysis, General user-guided) + Antipattern detector |
| 5 | `rules-update` | ✅ DESIGNED | `[layer]` | 3 flows (Git, Timestamp, General) |
| 6 | `user-pref-create` | ✅ DESIGNED | None | All preferences with guided sections |
| 7 | `user-pref-update` | ✅ DESIGNED | None | Opens in system editor + validation |
| 8 | `resolution-create` | ✅ DESIGNED | `[logbook]` | Generates resolution from logbook |
| 9 | `logbook-create` | ✅ DESIGNED | `[filename]` | 2 flows (Software, General) + deep code analysis |
| 10 | `logbook-update` | ✅ DESIGNED | `[filename]` | 4 operations + auto-compaction + quick update mode |

**Legend:**
- ⏳ PENDING - Not yet designed
- 🔄 IN REVIEW - Awaiting user feedback
- ✅ DESIGNED - Approved and documented
- 🚧 IMPLEMENTING - Code being written
- ✅ COMPLETE - Implemented and tested

---

## 🎯 Next Steps

### **Current Phase:** Command Design (Iterative)

**✅ DESIGN PHASE COMPLETE!**

All 10 commands have been designed:
- 1-8: Core commands (project-init through resolution-create)
- 9-10: Logbook commands with improved schema (logbook-create, logbook-update)

**Schema Improvements (logbook_software_schema.json):**
- Unified `objectives` object (replaced `objectives_present/past`)
- Main objectives with `context`, `scope.files`, `scope.rules`
- Secondary objectives with `completion_guide`
- 5-state status enum: `not_started`, `active`, `blocked`, `achieved`, `abandoned`
- YAGNI principle integrated in `$comment` instructions

**Schemas Available:**

| Schema | Project Type | Used By |
|--------|--------------|---------|
| `user_pref_schema.json` | Both | project-init, user-pref-create/update |
| `software_manifest_schema.json` | Software | manifest-create/update |
| `general_manifest_schema.json` | General | manifest-create/update |
| `project_rules_schema.json` | Software | rules-create/update |
| `project_standards_schema.json` | General | rules-create/update |
| `logbook_software_schema.json` | Software | logbook-create/update |
| `logbook_general_schema.json` | General | logbook-create/update |
| `ticket_resolution_schema.json` | Software only | resolution-create |

**Next Phase: Implementation**
1. Create workflow files for each command
2. Create agent definitions (subagents)
3. Create command files (.md for Claude Code)
4. Create compilation scripts
5. Create Homebrew formula
6. Test installation flow
7. Document final usage
8. Update README.md with new logbook workflow

---

## ✅ Questions Answered - Design Decisions

### **1. Homebrew Tap Naming** ✅
**Decision:** Use `exovian-developments/tap`
```bash
brew tap exovian-developments/tap
brew install ai-behavior
```

### **2. Installation & Initialization Flow** ✅
**Decision:** Two-step process with enhanced onboarding

**Step 1: Install via Homebrew** (one-time, global)
```bash
brew tap exovian-developments/tap
brew install ai-behavior
```

**Step 2: Initialize in project** (per-project)
```bash
cd /path/to/project
ai-behavior init
```

This command will:
- Create `ai_files/` directory structure
- Copy schema files to `ai_files/schemas/`
- Install Claude Code commands to `.claude/commands/ai-behavior/`
- Install agents to `.claude/agents/ai-behavior/`
- Check for Claude Code installation (warn if not present)
- Update `.gitignore` with `ai_files/logbooks/`
- **Show next step:** Suggest running `/ai-behavior:project-init`

**Step 3: Interactive Project Setup** (NEW COMMAND)
```bash
# In Claude Code conversation:
/ai-behavior:project-init
```

This command will:
1. Ask for conversation language (English, Español, Português)
2. Ask for conversation tone (formal, neutral, friendly, friendly_with_sarcasm, funny, strict)
3. Ask other essential preferences for comfortable interaction
4. Create `ai_files/user_pref.json` with these settings
5. **All subsequent ai-behavior commands will use these language/tone preferences**

**Rationale:**
- Separates system setup (`ai-behavior init` - CLI) from user preferences (`/project-init` - interactive)
- Language/tone set once, used by all commands automatically
- More intuitive than running full `/user-pref-create` on first use
- Guides new users through essential setup before other commands

### **3. Multi-Language Support** ✅
**Decision:** Multi-language conversations, English commands

**Implementation:**
- Command names: **English only** (e.g., `/ai-behavior:logbook-create`)
- Command documentation: **Translated** (README.md, README.es.md, README.pt.md)
- Agent conversations: **Dynamic** based on `user_pref.json` → `preferred_language` field
- Agent outputs: **Dynamic** based on user preferences

**How it works:**
```json
// ai_files/user_pref.json
{
  "user_profile": {
    "preferred_language": "es",
    "communication_tone": "friendly"
  }
}
```

All agents will read this file and:
- Conduct conversations in Spanish
- Use friendly tone
- Generate outputs in Spanish (when applicable)

**Rationale:**
- English commands = universal, searchable, consistent with dev tools
- Localized interactions = comfortable, accessible, professional
- Best of both worlds

### **4. Versioning Strategy** ✅
**Decision:** Version schemas, provide migration guides, no auto-migration

**Implementation:**
```
ai_files/schemas/
  v1/
    logbook_software_schema.json
    software_manifest_schema.json
    ...
  v2/
    logbook_software_schema.json  (breaking changes)
    ...
```

Each schema file includes:
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "version": "1.0.0",
  ...
}
```

**Migration:**
- Commands detect schema version in generated files
- If old version detected, show warning with migration guide link
- Provide `MIGRATION_v1_to_v2.md` guides in documentation
- Users migrate manually (preserves data safety)

**Rationale:**
- Manual migration = safer (no data loss risk)
- Version detection = clear compatibility
- Migration guides = self-service support
- Developers understand version control

### **5. Command Naming Convention** ✅
**Decision:** Verb-last (like git) for familiarity

**Pattern:** `/ai-behavior:[noun]-[verb]`

**Updated Command List:**
```bash
# Initialization
/ai-behavior:project-init              # NEW - Interactive first-time setup

# Global Context Commands
/ai-behavior:user-pref-create          # Create user preferences
/ai-behavior:manifest-create           # Analyze and create project manifest
/ai-behavior:manifest-update           # Update existing manifest
/ai-behavior:rules-create [layer]      # Create rules for layer
/ai-behavior:rules-update [layer]      # Update rules for layer

# Focused Context Commands
/ai-behavior:logbook-create [filename] # Create new ticket logbook
/ai-behavior:logbook-update [filename] # Update logbook with progress
/ai-behavior:resolution-create [filename] # Generate ticket resolution

# Utility Commands (future consideration)
/ai-behavior:logbook-list              # List all logbooks
/ai-behavior:logbook-validate [filename] # Validate logbook against schema
/ai-behavior:manifest-validate         # Validate manifest against schema
```

**Rationale:**
- Matches git pattern: `git commit`, `git branch-create` (conceptually)
- Natural grouping by noun: all `logbook-*` commands together
- Tab completion friendly: type `/ai-behavior:logbook-` → see all logbook commands
- Consistent verb positioning aids memorization

**Comparison with git:**
```bash
# Git examples
git branch create feature-x
git remote add origin url
git stash pop

# ai-behavior equivalents (conceptual)
/ai-behavior:logbook-create FEATURE-X.json
/ai-behavior:manifest-update
/ai-behavior:resolution-create FEATURE-X.json
```

**Recommendation on familiarity:**
✅ **Yes, this achieves familiarity!**

The verb-last pattern is subtle but powerful because:
1. **Autocomplete grouping** - Type `/ai-behavior:logbook-` and see all logbook operations
2. **Noun-first thinking** - Developers think "I want to work with a logbook" → then "what do I want to do?"
3. **Git mental model** - Developers have strong git muscle memory
4. **Consistent structure** - No exceptions, every command follows same pattern

**Even better familiarity tip:**
Add aliases in documentation:
```bash
# Full command
/ai-behavior:logbook-create CALC-001.json

# Shorthand (if Claude Code supports aliases in future)
/aib:logbook-create CALC-001.json
```

---

**Ready to proceed with iterative command design!** 🚀
