# Changelog

All notable changes to waves will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.7] - 2026-04-15

### Fixed

- **Gate whitelist expanded** — CLAUDE.md, `.claude/*`, root-level `*.md` files, and common config files (package.json, pubspec.yaml, tsconfig.json, Dockerfile, .gitignore, etc.) are now always allowed. The gate only blocks source code edits without a logbook.
- **Consent-based bypass** — create `.claude/waves-gate-bypass` to disable blocking entirely. For projects in transition from 1.x or working without full artifacts. The block message now includes the bypass instruction.

---

## [2.0.6] - 2026-04-15

### Fixed

- **Upgrade bootstrap problem** — `waves upgrade` now re-executes itself with the newly installed binary after brew upgrade, so new logic (settings.json overwrite, post-upgrade message) takes effect immediately instead of requiring a second run.

---

## [2.0.5] - 2026-04-15

### Added

- **`/waves:upgrade` command** — updates the Agent Operating Protocol in CLAUDE.md to the latest version. Intelligently finds and replaces the Waves protocol block while preserving user-added content. Required after running `waves upgrade` in terminal.
- **Post-upgrade instruction** — `waves upgrade` now prints a clear message telling users to run `/waves:upgrade` in Claude Code to complete the update. Without this step, CLAUDE.md may be inconsistent with installed hooks.

### Changed

- **settings.json always overwrites on upgrade** — settings.json is framework infrastructure (like schemas and commands), not user configuration. The upgrade now always installs the latest version instead of preserving outdated configs.

---

## [2.0.4] - 2026-04-15

### Fixed

- **Gate deadlock resolved** — the gate no longer blocks the creation of its own prerequisites. Writes to `ai_files/` are always allowed (framework artifacts, not code), so logbooks, roadmaps, blueprints, and other Waves artifacts can be created even when a logbook doesn't exist yet.
- **Read-only Bash whitelisted** — commands like `git status`, `git log`, `git diff`, `ls`, `tree`, `grep`, `cat`, `dart analyze` are always allowed regardless of logbook state. The gate only blocks Bash commands that modify state (`git commit`, `git push`, `rm`, etc.).

---

## [2.0.3] - 2026-04-15

### Added

- **Active roadmaps and logbook loaded at session start** — the perceive hook now outputs a `CARGAR:` section with paths to all active roadmaps and the most recent logbook. The prompt hook reads them silently, giving the agent full strategic context AND implementation continuity from the first interaction.
- **Multi-roadmap support** — projects with multiple active waves (e.g., w0 and w1 both in_progress) get all roadmaps loaded, not just the first one found.
- **Logbook priority** — the most recent active logbook is found by scanning from the highest wave downward. Ensures the agent picks up where the last session left off.
- **Comprehensive artifact discovery** — the prompt hook now checks both `ai_files/` and project root for all artifact types, including `company_blueprint.json`, all manifest variants, and both naming conventions.

---

## [2.0.2] - 2026-04-15

### Added

- **Mandatory artifact loading at SessionStart** — a prompt-type hook now forces the agent to silently read blueprint, project rules, manifest, and user preferences at session start. The agent starts every session with full product context loaded, not just a summary.

### Changed

- **SessionStart now has 2 hooks**: (1) command hook injects state summary (ESTADO WAVES), (2) prompt hook forces reading of core artifacts. This ensures the agent has both the overview AND the full detail.

---

## [2.0.1] - 2026-04-15

### Fixed

- **SessionStart hook not firing** — the `"matcher": ""` field in settings.json caused SessionStart hooks to silently fail. Removed matcher (matching official Anthropic plugin format). PreToolUse and PostToolUse were unaffected.
- **`waves upgrade` now auto-fixes** — detects the v2.0.0 bug (`"matcher": ""`) in existing settings.json and replaces it with the corrected config. No manual intervention needed.
- **`waves init` also auto-fixes** — same detection for projects initialized with v2.0.0.

---

## [2.0.0] - 2026-04-15

### Added

- **Waves 2.0: Product Consciousness Framework** — transforms the agent from an informed executor into a strategic advisor with graduated autonomy

- **7 Claude Code hooks** (`.claude/hooks/`)
  - `waves-perceive.sh` — SessionStart: injects full product state (wave, phase, objectives, decisions)
  - `waves-gate.sh` — PreToolUse: graduated enforcement (no blueprint → allow; blueprint without roadmap → block; full artifacts → allow + classification reminder)
  - `waves-doc-enforce.sh` — PostToolUse: enforces recent_context documentation when objectives complete
  - `waves-metacognition.sh` — PostToolUse: triggers holistic reflection when primary objectives complete
  - `waves-blueprint-impact.sh` — PostToolUse: projects cascading impacts when blueprint changes
  - `waves-phase-audit.sh` — PostToolUse: strategic audit when roadmap phases complete
  - `waves-dart-analyze.sh` — PostToolUse: runs dart analyze on .dart files after edits

- **Decision Classification** — 5-level system for graduated autonomy
  - Level 1-2 (technical): agent proceeds autonomously
  - Level 3 (scope): agent stops, informs, waits
  - Level 4 (business): agent stops, projects scenarios, waits
  - Level 5 (discovery): agent stops, documents, projects, advises
  - Conservative bias: when in doubt, classify UP

- **Hook settings** (`.claude/settings.json`) — SessionStart, PreToolUse, PostToolUse configuration with matchers and timeouts

- **Sections 12-13 in FRAMEWORK.md** — Decision Classification and Hooks Architecture with platform availability matrix

- **Principle #8** — "Enforcement over instruction. Rules that can be ignored will be ignored."

- **5 new rows in Scrum comparison** — enforcement, classification, awareness, context survival, metacognition

- **8 new glossary terms** — hook, perception, enforcement, classification, metacognition, marker file, graduated governance

### Changed

- **FRAMEWORK.md** bumped to v2.0.0
- **Agent Operating Protocol** (project-init) updated with decision classification table, metacognition checkpoints, and 2 new agent qualities
- **Plugin hooks.json** updated with expanded perception and classification prompt for Claude Desktop/Cowork
- **bin/waves** version bumped to 2.0.0

### Validated

- 29/29 automated tests passed: 11 hook dry-run tests + 18 classification benchmark scenarios
- Classification accuracy: 100% correct actions, 89% exact level match, 2 conservative deviations (classified UP)
- All 3 mixed-level escalation scenarios detected correctly

---

## [1.3.0] - 2026-03-19

### Added

- **Company Blueprint Schema** (`company_blueprint_schema.json`)
  - Top-level artifact for company identity, strategy, and operations
  - Sections: identity, market, hypothesis, strategic_capabilities, products, operational_areas, revenue_model, channels, partnerships, cost_structure, team, key_dates, company_roadmaps, company_decisions, open_questions
  - All field descriptions use clear, non-jargon language with guiding questions
  - Sits above product blueprints in the artifact hierarchy

- **`product_roadmaps` array** in `product_blueprint_schema.json`
  - Prepend-only array linking blueprint to its roadmaps
  - Managed exclusively by `roadmap-create` command
  - Completes the traceability chain: blueprint → roadmaps → logbooks

- **FRAMEWORK.md** updated to v1.2.0 with full documentation:
  - Directory structure (section 6.3) with physical layout
  - Progress metrics (section 7) with formulas for wave, product, velocity, ecosystem
  - Company blueprint section (section 9) with strategic layer documentation
  - Artifact linkage (section 6.5) with product_roadmaps chain
  - Role clarification: process roles vs tool access roles

### Changed

- **Directory restructure**: flat `ai_files/` → wave-based hierarchy
  - Product artifacts at root: `blueprint.json`, `foundation.json`, `feasibility.json`
  - Wave artifacts nested: `waves/sub-zero/`, `waves/w0/`, `waves/wN/`
  - Each wave contains: `roadmap.json`, `logbooks/`, `resolutions/`
  - Renamed: `product_blueprint.json` → `blueprint.json`, `product_foundation.json` → `foundation.json`

- **All 32 command files** updated across 3 locations (`.claude/commands/`, `plugin/commands/`, `commands/`)
  - Path references updated to wave-based structure
  - `logbook-create`: smart wave detection from active roadmap status
  - `roadmap-create`: auto-detect next wave, prepend to `product_roadmaps`
  - `resolution-create`: derive output path from logbook location
  - `project-init`: injects Waves Framework Agent Operating Protocol into CLAUDE.md

- **SKILL.md** updated with new directory structure

### Removed

- Obsolete pre-rebrand files: `CONTINUATION_PROMPT.md`, `IMPLEMENTATION_GUIDE.md`, `Prompt para continuar sesión de ai-behav.md`

## [1.1.0] - 2026-03-11

### Added

- **Foundation Create Command** (`/waves:foundation-create`)
  - Compacts feasibility analysis into validated facts for blueprint consumption
  - 13-step flow: enriched problem → target users → competitive landscape → revenue model → financial benchmarks → SWOT synthesis → capability re-classification → flow expansion → timeline constraints → proactive insights → blueprint readiness gate
  - Key transformation: re-classifies capabilities from revenue-impact (blocking/enabling/expansion) to operational criticality (essential/important/desired)
  - Scope feasibility check against runway and available hours
  - No subagent delegation — all steps executed directly by main agent

- **Blueprint Create Command** (`/waves:blueprint-create`)
  - Transforms foundation into complete product architecture
  - 17-step flow with product owner validation at every section
  - Progressive refinement: foundation fields evolve to higher specificity
  - New fields: product hypothesis, mission, vision (not in foundation)
  - Design principles → product rules traceability
  - Dual-signal success metrics (success_signal + failure_signal)
  - Supports standard and autonomous entity blueprint types
  - No subagent delegation — all steps executed directly by main agent

- **Design docs** for both commands (`commands/15-foundation-create.md`, `commands/16-blueprint-create.md`)

### Changed

- **Wave naming convention** for roadmap files
  - New pattern: `roadmap_w0.json` (foundation/agnostic), `roadmap_w1.json`+ (business waves)
  - Legacy pattern `*_roadmap.json` supported as fallback
  - Updated across all commands: roadmap-create, roadmap-update, logbook-create, objectives-implement
  - Updated plugin commands and SKILL.md
  - Updated `bin/waves` preserved files list

- **Roadmap Create** (`/waves:roadmap-create`)
  - Context priority order: blueprint > foundation > feasibility > manifest > rules
  - Wave number auto-detection with user confirmation
  - Output filename uses wave convention

- **SKILL.md** command flow updated with full lifecycle: feasibility → foundation → blueprint → roadmap → logbook

### Pipeline Update

Complete product lifecycle: feasibility (CAN WE?) → foundation (WHAT DID WE LEARN?) → **blueprint (WHAT/WHY)** → roadmap (WHEN/ORDER) → logbook (HOW)

## [1.0.0] - 2026-03-10

### Added

- **Feasibility Analysis Command** (`/waves:feasibility-analyze`)
  - Pre-blueprint feasibility and market analysis
  - Conversational discovery with expert consultant role
  - Monte Carlo simulation (10,000 scenarios) with interpretable graphics
  - Bayesian belief update with evidence tracking
  - Multi-stream revenue model with unit economics
  - Buyer persona definition from real observations
  - Essential capabilities draft for minimum time to revenue
  - Proactive suggestions (positioning, marketing, features, partnerships)
  - Iterable — pivot market, model, or assumptions and re-run projections
  - Universal — works for any project type, not just software
  - **No subagent delegation** — all steps executed directly by main agent

- **Feasibility Analysis Schema** (`feasibility_analysis_schema.json`)
  - Complete schema with `description` + `$comment` pattern
  - Sections: meta, idea_profile, user_resources, market_analysis, buyer_personas, revenue_model, revenue_targets, revenue_projections, essential_capabilities_draft, proactive_suggestions, iteration_history, next_steps
  - Projection scenarios with Monte Carlo variables, results, and Bayesian analysis
  - Kill criteria and critical assumptions per scenario

- **Product Foundation Schema** (`product_foundation_schema.json`)
  - Compaction point between feasibility analysis and product blueprint
  - Consolidates: validated problem, target users, competitive landscape, revenue model, financial benchmarks (Monte Carlo + Bayesian summaries), SWOT analysis, essential capabilities, flow drafts, timeline constraints, proactive insights, remaining unknowns, and blueprint readiness gate
  - 13 top-level sections with full `description` + `$comment` pattern
  - Artifact hierarchy updated: feasibility → **foundation** → blueprint → roadmap → logbook

- **Command design doc** (`commands/14-feasibility-analyze.md`)
  - 12-step flow from idea discovery to save
  - Interpretable graphics design (4 chart types for non-technical users)
  - Agent role specification as expert business consultant

### Changed

- **objectives-implement: Business-aware continuous implementation**
  - **Step 4**: Now loads `product_blueprint.json` and identifies the related capability, flow, or view for each objective. Extracts `is_essential` flag, acceptance_criteria, and design_principles for business-aligned coding
  - **Step 4**: Also loads `technical_guide.md`, `*_feasibility.json`, and `*_roadmap.json` as additional context
  - **Step 5**: Business context informs implementation — essential capabilities get extra thoroughness and edge case coverage
  - **Step 9**: Logbook updated immediately after EVERY objective completion (status first, save before findings processing). Main objectives auto-marked as achieved when all secondaries complete
  - **Step 9.3**: New business-impact recent_context entries — code changes affecting capabilities are recorded with `⚡ BUSINESS IMPACT` prefix for cross-session visibility
  - **Step 9.4**: New objectives suggested during implementation are added automatically (autonomy principle, no user approval needed)
  - **Step 10**: Removed "Continue?" approval checkpoint — agent now auto-continues to next objective. Stops only when: context window ≤ 7% remaining, all objectives done, or blocking impediment found
  - Updated both executable command and plugin command

- **logbook-create: Autonomous Design Resolution philosophy**
  - **Step A2 redesigned**: Agent now resolves ALL code/architecture design decisions autonomously using unified SRP+KISS+YAGNI+DRY+SOLID principles
  - **Escalation gate**: Only business-level contradictions are escalated to the user (ticket vs blueprint conflicts, mutually exclusive acceptance criteria, fundamental scope ambiguity about WHAT not HOW, conflicting product rules)
  - **Transparency reports**: Decisions are presented as declarations, not approval requests — user can see and intervene but flow does not stop
  - **Steps A3/A4**: Removed approval checkpoints for main and secondary objectives — objectives are declared, not proposed for approval
  - **Flow B (General)**: Same philosophy applied to Steps B2/B3
  - **No subagent delegation**: Removed secondary-objective-generator subagent reference — all steps executed directly by main agent
  - Step A1 now searches for `product_blueprint.json`, `technical_guide.md`, `*_feasibility.json`, and `*_roadmap.json` as additional context
  - New Step A1.5: Asks user for additional source files (open for extension, closed for modification)
  - Design doc `09-logbook-create.md` updated accordingly

### Hierarchy Update

New artifact hierarchy: feasibility (CAN WE?) → **foundation (WHAT DID WE LEARN?)** → blueprint (WHAT/WHY) → roadmap (WHEN/ORDER) → logbook (HOW)

## [0.2.1] - 2026-03-08

### Changed

- **objectives-implement: Removed subagent delegation**
  - Implementation (Step 5) now executed directly by main agent instead of dispatching to code-implementer subagent
  - Auditing (Step 7) now executed directly by main agent instead of dispatching to code-auditor subagent
  - Retry loop (Step 8B) now fixes directly instead of re-invoking subagent
  - **Reason:** Subagent delegation caused loss of accumulated context (project rules, manifest, resolved decisions, prior objectives), resulting in code that contradicted project conventions
  - Aligns with the same no-subagent pattern already applied to `logbook-create` in v0.1.0

- **Plugin command `objectives-implement`**
  - Removed `Task` from `allowed-tools`
  - Updated Steps 5, 7, 8B to execute directly
  - Updated role description to "orchestrator AND executor"

- **Command design doc `11-implement.md`**
  - Updated flow, subagents section, steps 5/7/8B to reflect direct execution
  - Removed subagent progress UI sections
  - Added explicit warning against subagent delegation

### Note

Plugin agents `code-implementer` and `code-auditor` remain in `plugin/agents/` as reference for standalone use, but are no longer invoked by the `objectives-implement` command.

## [0.2.0] - 2026-02-26

### Added

- **Roadmap Schema** (`logbook_roadmap_schema.json`)
  - Product-level roadmap with phases, milestones, decisions, open questions
  - Rolling context (recent_context/history_summary/future_reminders) reusing logbook patterns
  - Hierarchy: blueprint (WHAT/WHY) → roadmap (WHEN/ORDER) → logbook (HOW)
  - YAGNI/DRY/KISS design principles

- **Roadmap Subagents**
  - `32-roadmap-creator` — Proposes phases and milestones from project context or user vision
  - `33-roadmap-updater` — Analyzes roadmap state, proposes updates and phase transitions

- **Roadmap Commands**
  - `/waves:roadmap-create` — Create product-level roadmap with phases and milestones
  - `/waves:roadmap-update` — Update progress, decisions, questions, phase transitions

- **Plugin Updates**
  - New agent: `roadmap-orchestrator` (combines creation and update analysis)
  - New commands: `roadmap-create`, `roadmap-update`
  - Schema `logbook_roadmap_schema.json` added to plugin references
  - SKILL.md updated with roadmap hierarchy documentation

### Plugin Agent Mapping Update

| Plugin Agent | Source Subagents |
|---|---|
| roadmap-orchestrator | 32 (roadmap-creator) + 33 (roadmap-updater) |

## [0.1.0] - 2026-02-13

### Added

- **Core Protocol**
  - 9 JSON schemas with `description` + `$comment` pattern for LLM precision
  - Support for 5 project types: Software, Academic, Creative, Business, General
  - Global context (manifests, rules, preferences) and focused context (logbooks)

- **Subagents (31)**
  - Phase 1: Project initialization and manifest creation (subagents 01-10)
  - Phase 2: Software analysis — entry points, navigation, flows, dependencies, architecture, features (11-16)
  - Phase 3: Rules creation — patterns, conventions, antipatterns, criteria validation, standards (22-26)
  - Phase 4: Logbooks — objective generation, context summarization, code implementation, code auditing (28-31)
  - Phase 5: Updates — git history, autogen detection, manifest changes, timestamps, manifest updater, rule comparison (17-21, 27)

- **Commands (11)**
  - `project-init`, `manifest-create`, `manifest-update`
  - `rules-create`, `rules-update`
  - `user-pref-create`, `user-pref-update`
  - `logbook-create`, `logbook-update`
  - `resolution-create`, `objectives-implement`

- **Cowork Plugin (`plugin/`)**
  - 16 specialized agents adapted from 31 subagents for the Cowork plugin format
  - 11 slash commands as orchestrators dispatching to agents via Task tool
  - 1 skill (`waves-protocol`) with 9 schema references
  - SessionStart hook for automatic context loading
  - Packaged as `.plugin` for Claude desktop installation

- **Documentation**
  - README in English, Spanish, and Portuguese
  - Implementation guide with architecture details
  - Examples for Flutter, Java, and Web projects

### Mapping: Subagents to Plugin Agents

| Plugin Agent | Source Subagents |
|---|---|
| entry-point-analyzer | 11 |
| navigation-mapper | 12 |
| flow-tracker | 13 |
| dependency-auditor | 14 |
| architecture-detective | 15 |
| feature-extractor | 16 |
| git-history-analyzer | 17 |
| change-analyzer | 18 (autogen-detector) + 19 (manifest-change-analyzer) |
| pattern-extractor | 22 |
| convention-detector | 23 |
| antipattern-detector | 24 |
| rule-comparator | 27 |
| objective-generator | 28 |
| code-implementer | 30 |
| code-auditor | 31 |
| general-scanner | 09 |

Subagents not mapped as standalone plugin agents (used as pipeline steps within commands): 01-08, 10, 20, 21, 25, 26, 29.
