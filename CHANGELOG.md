# Changelog

All notable changes to ai-behavior will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-03-08

### Added

- **Feasibility Analysis Command** (`/ai-behavior:feasibility-analyze`)
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
  - `/ai-behavior:roadmap-create` — Create product-level roadmap with phases and milestones
  - `/ai-behavior:roadmap-update` — Update progress, decisions, questions, phase transitions

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
  - 1 skill (`ai-behavior-protocol`) with 9 schema references
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
