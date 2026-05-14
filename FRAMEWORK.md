# Waves™ Framework

**Version:** 2.4.0
**Last updated:** 2026-05-14
**Status:** Active

---

## 1. What is Waves

Waves is a product development framework designed for teams working with AI agents. It replaces fixed-cadence methodologies (Scrum sprints, SAFe PIs) with organic, variable-length delivery cycles called **waves**.

Each wave is a complete unit of delivery: from validation through implementation to production. A wave lasts as long as it needs — sometimes 3 days, sometimes 3 weeks — adapting to the actual rhythm of the work rather than forcing work into arbitrary time boxes.

### 1.1 Why not Scrum

Scrum's 2-week sprints assume development velocity is constant and predictable. With AI agents that implement features in hours, the sprint becomes a container with too much empty space or artificial boundaries. Ceremonies designed for human coordination overhead (standups, sprint planning, retrospectives) lose their purpose when AI agents execute, track, and report in real-time through structured artifacts.

### 1.2 Why not Kanban

Kanban optimizes for the flow of individual items but lacks the strategic framing of a complete delivery cycle. Waves inherits Kanban's pull-based flexibility but adds what Kanban lacks: a bounded, coherent unit of product evolution with built-in feasibility analysis, architectural blueprinting, and progressive refinement from idea to production.

### 1.3 Core insight

AI agents have compressed what used to take 6 months of development into days or weeks. The bottleneck is no longer coding — it's human validation, QA, and decision-making. Waves adapts the process to this new reality.

### 1.4 What changed across the 2.x line

Waves 1.x was a framework of **structure and traceability** — it defined artifacts, order, and hierarchy. But it depended on CLAUDE.md instructions that degrade in long sessions.

Waves 2.x transforms the framework into a **Product Consciousness Framework** — the agent is no longer just an informed executor, it is a strategic advisor with graduated autonomy and mechanical guardrails. The 2.x line is cumulative: each minor release adds a defense layer that the previous one could not enforce.

#### 2.0 — Product Consciousness Foundation (2026-04-15)

| Capability | Mechanism | Platform |
|-----------|-----------|----------|
| **Perception** — agent starts every session knowing the full product state | SessionStart hook reads the artifact graph and injects state | Claude Code (hooks), all platforms (prompt-based) |
| **Mechanical enforcement** — rules that cannot be ignored | PreToolUse hook blocks actions (exit 2) when artifacts are missing | Claude Code only |
| **Decision classification** — 5 levels of graduated autonomy | Classification reminder injected on every PreToolUse + re-injected after compaction | Claude Code (hooks), all platforms (CLAUDE.md) |
| **Proactive metacognition** — 3 automatic triggers for strategic reflection | PostToolUse hooks detect delta in objectives, blueprint changes, and phase completion | Claude Code only |
| **Context survival** — rules survive long sessions | SessionStart re-fires after context compaction, re-injecting state and classification rules | Claude Code only |
| **Graduated governance** — enforcement proportional to project maturity | No blueprint → allow all. Blueprint without roadmap → block. Full artifacts → allow + classify | Claude Code only |

#### 2.1 — Background subagents, governance, and product memory (2026-04-16 → 2026-05-04)

The 2.1 line moved metacognition from a synchronous step that paused the main agent to a **background subagent** spawned in parallel. It also introduced governance primitives and product-level memory.

| Capability | Where it lives |
|-----------|---------------|
| **Background metacognition** — fresh subagent with full Opus context, runs in parallel | `waves-metacognition.sh` spawns `Agent(run_in_background=true)` with adversarial framing |
| **Throttled triggers** — fires at `floor(N/2)` intervals, not every objective | Marker counter per logbook hash, cooldown 60s to prevent loops |
| **Mechanical roadmap progress** — `[AUTO]` notes appended on every objective completion | Hook writes to `roadmap.decisions[]` directly via jq |
| **Rule scope governance** — `scope: "ecosystem" \| "local"` on every rule | Ecosystem rules immutable from individual projects; local rules are project-owned |
| **Blueprint living memory** — `recent_context[]` (20 entries) + `history_summary[]` (10 entries) | Captures capability changes, market discoveries, metacognition findings; survives across sessions |
| **Cross-vertical serendipity** — metacognition explicitly asks "does this solve another vertical's problem?" | Prompt enhancement in `waves-metacognition.sh` |
| **Incremental `/waves:upgrade`** — version-aware migration registry | Reads `.claude/waves-version`, applies only migrations newer than local version |
| **Layer A — inline rule text in completion_guide** | Logbook secondaries carry `Apply rule #N: <full rule text>` lines verbatim |
| **Layer B — rules-in-scope banner** at start of every implementation | `objectives-implement` prints expanded rule text before any code is written |
| **Layer C — post-implementation rules audit subagent** + companion injector hook | Background Opus auditor with structural citation requirement; non-blocking injection of findings classified by trust contract level |

#### 2.2 — Logbook integrity and decomposition gates (2026-05-04)

The 2.2 line closed the loop by adding two adversarial subagents that validate the inputs to implementation (the logbook itself) before code is written.

| Capability | Where it lives |
|-----------|---------------|
| **Orthogonality reviewer (Step A2.5)** — adversarial subagent decides single_focus vs multi_focus before primary objectives are generated | `logbook-create` Step A2.5 spawns blocking Opus subagent biased toward multi_focus |
| **Sibling primaries banner** — implementer sees DONE/THIS/DEFERRED siblings to scope attention | `objectives-implement` reconstructs from `logbook.objectives.main` when N>1 |
| **Layer D — logbook integrity audit (Step A6)** | Post-persist adversarial subagent reads logbook from disk, flags critical/warning findings (missing rules, empty scope.files, decomposition mismatch, duplicate primary content) |
| **`audit` field in logbook schema** | `is_already_audited` (bool) + `audit_file` (path). Survives across sessions; visible at SessionStart |
| **Schema migration soft on load** — older logbooks get missing required fields auto-added at `logbook-update` | Adds `audit: { is_already_audited: false }` to pre-2.2 logbooks |
| **Two-argument contract on `logbook-update`** — `<filename> [audit | instruction]` | Reserved token `audit` skips operations and runs the integrity reviewer; free-form instruction is interpreted with plan-before-execute confirmation |
| **STEP AUDIT unconditional** — every `logbook-update` ends with integrity audit | Escape hatch (option 6) for the rare case the audit is genuinely unnecessary |

#### 2.3 — Agentic project category (2026-05-14)

The 2.3 release adds a third project category — **agentic** — alongside `software` and `general`. An agentic project's value is an orchestration of agents/subagents with skills, hooks, tools, and configurations — not traditional software, not academic content. Ratified empirically with 1 production pilot (medical corpus pipeline) + 2 projected cases (customer operations hub, compliance operations center) before the schema was frozen.

| Capability | Where it lives |
|-----------|---------------|
| **`agentic_manifest_schema.json`** — 15 agnostic top-level sections + 8 reusable `$defs` | Models orchestration, roles (free array, NO fixed enum), subagents lifecycle (ephemeral/persistent/hybrid), skills, tools, data_sources, state_contracts, handoff_contracts, pipelines, integration_contracts, triggers, governance, observability, source_access_modes |
| **`user_pref` enum extended** to `["software", "general", "agentic"]` | Routing key for all commands; backward compatible |
| **`/waves:manifest-create` FLOW C: AGENTIC** | 6 elicitation groups (project identity, orchestration architecture, roles/skills/tools, data flow, pipelines/triggers, governance/observability) cover all 15 sections |
| **`/waves:blueprint-create` Step -0.5** — Agentic Terminology Adaptation | Conceptual mapping: capabilities → subagent_capabilities; views/flows → orchestration_patterns. NO schema change |
| **`/waves:rules-create` Flow C** — 7 default agentic categories | orchestration, prompt_engineering, tool_use, governance, data_handling, integration, observability. Project defines its own; `project_rules_schema` accepts any |
| **Core commands accept agentic** — `objectives-implement`, `logbook-create`, `logbook-update` reuse `logbook_software_schema` | scope.files for agentic points to skill .md / hook .json / prompt files instead of source code; the 4 defense layers + orthogonality reviewer apply identically |

The 4 defense layers (A inline rules + B banner + C rules audit + D logbook integrity audit) and the adversarial subagents (orthogonality reviewer, integrity reviewer, rules auditor) are agnostic by construction — they operate on diff vs rules and structural validation of logbooks, regardless of whether the diff is Dart source code or a skill markdown file.

---

## 2. Roles

Each role in Waves operates as a **person (or team) + AI agents**. The AI agent is not a tool — it is a team member with defined responsibilities.

These are **process roles** — they define responsibilities within the Waves methodology. They are independent of access roles in tools like ECC (super-admin, staff, client). A Technical Manager may be a super-admin or staff in ECC depending on the project. A Product Owner could be any access role. The mapping between process roles and tool access roles is determined per team and per tool.

### 2.1 Product Owner (PO)

| Aspect | Description |
|--------|-------------|
| **Who** | Person or team responsible for the product's success |
| **AI agents** | Assist with market analysis, feasibility simulations, competitive research, and data-driven decision support |
| **Responsibilities** | Owns the product blueprint, validates wave outputs, gives go/no-go at gates, convenes Blueprint Refinement when the product direction needs to change |
| **Authority** | Final decision on what gets built and what goes to production |

### 2.2 Coordinator (Project Manager)

| Aspect | Description |
|--------|-------------|
| **Who** | Individual responsible for coordination and flow |
| **AI agents** | Assist with roadmap tracking, progress reporting, dependency detection, and meeting preparation |
| **Responsibilities** | Convenes Coordination Meetings, tracks roadmap progress, identifies blockers, ensures wave flow, organizes QA & Demo sessions |
| **Authority** | Decides when to convene meetings, manages wave cadence and team synchronization |

### 2.3 Technical Manager

| Aspect | Description |
|--------|-------------|
| **Who** | Individual with both business understanding and technical depth |
| **AI agents** | Implement features, write code, analyze architecture, audit quality, execute objectives from logbooks |
| **Responsibilities** | Translates business requirements into technical reality, manages AI agent output quality, ensures the product blueprint becomes a real product |
| **Authority** | Technical decisions on implementation, architecture, and quality standards |

---

## 3. Waves (Delivery Cycles)

### 3.1 Wave types

| Wave | Name | Purpose | Key question |
|------|------|---------|-------------|
| **Sub-Zero** | Validation Wave | Confirm the project is viable before investing in definition | *Can we? Should we?* |
| **W0** | Definition Wave | Define the product and prepare everything for execution | *What are we building?* |
| **W1+** | Business Waves | Deliver product increments to production | *How do we build and ship it?* |

### 3.2 Flow: From-scratch projects

For new products that don't exist yet.

```
┌─────────────────────────────────────────────────────┐
│  SUB-ZERO  (Validation Wave)                        │
│                                                     │
│  Activities:                                        │
│    • feasibility-analyze → feasibility.json         │
│    • foundation-create   → foundation.json          │
│                                                     │
│  Meetings: CM Sub-Zero                              │
│  Gate: Go/No-Go — PO decides with feasibility data  │
└──────────────────────┬──────────────────────────────┘
                       │ go
┌──────────────────────▼──────────────────────────────┐
│  W0  (Definition Wave)                              │
│                                                     │
│  Activities:                                        │
│    • blueprint-create  → blueprint.json             │
│    • roadmap-create    → waves/w1/roadmap.json      │
│    • project-init, manifest-create, rules-create    │
│                                                     │
│  Meetings: CM W0                                    │
│  Gate: QA W0 — PO approves the product definition   │
└──────────────────────┬──────────────────────────────┘
                       │ approved
┌──────────────────────▼──────────────────────────────┐
│  W1+  (Business Waves)                              │
│                                                     │
│  Activities:                                        │
│    • logbook-create / logbook-update (per ticket)   │
│    • objectives-implement (continuous execution)     │
│    • roadmap-update (progress and decisions)         │
│                                                     │
│  Meetings: CM W1, BR (if needed), QA W1             │
│  Gate: QA & Demo — PO approves for production       │
│  Closure: Wave Celebration → deploy to production   │
└─────────────────────────────────────────────────────┘
```

### 3.3 Flow: On-going projects

For existing products where a team is joining or adopting Waves.

```
┌─────────────────────────────────────────────────────┐
│  SUB-ZERO  (Knowledge Wave)                         │
│                                                     │
│  Activities:                                        │
│    • Study existing product, codebase, docs         │
│    • manifest-create (analyze what exists)           │
│    • foundation-create (document current state)      │
│    Has its own roadmap for knowledge acquisition     │
│                                                     │
│  Meetings: CM Sub-Zero                              │
│  Gate: Foundation complete, team understands product │
└──────────────────────┬──────────────────────────────┘
                       │ ready
┌──────────────────────▼──────────────────────────────┐
│  W0  (Foundations Wave)                             │
│                                                     │
│  Activities:                                        │
│    • blueprint-create (from acquired knowledge)     │
│    • roadmap-create (plan first business wave)      │
│    • rules-create, permissions, infrastructure      │
│                                                     │
│  Meetings: CM W0                                    │
│  Gate: QA W0 — PO validates blueprint reflects      │
│         the real product                            │
└──────────────────────┬──────────────────────────────┘
                       │ approved
┌──────────────────────▼──────────────────────────────┐
│  W1+  (Growth Waves)                                │
│                                                     │
│  Activities:                                        │
│    • New capabilities, improvements, evolution      │
│    • logbook-create / logbook-update (per ticket)   │
│    • roadmap-update (progress and decisions)         │
│                                                     │
│  Meetings: CM W1, BR (if needed), QA W1             │
│  Gate: QA & Demo — PO approves for production       │
│  Closure: Wave Celebration → deploy to production   │
└─────────────────────────────────────────────────────┘
```

---

## 4. Meetings

All meetings in Waves are **on-demand** — no fixed cadence, no calendar-driven ceremonies. Each meeting has a clear purpose, defined inputs, defined outputs, and a responsible convener.

### 4.1 Coordination Meeting (CM)

The working meeting. Frequent, lightweight, purpose-driven.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Plan, track progress, resolve doubts and blockers |
| **Naming** | CM + active wave: `CM Sub-Zero`, `CM W0`, `CM W1`, etc. |
| **Convenes** | Coordinator |
| **Frequency** | On-demand, as often as needed |
| **Participants** | Coordinator + relevant team members (Technical Manager, PO when needed) |

| Inputs | Outputs |
|--------|---------|
| Roadmap of the active wave | Tactical decisions documented |
| Logbooks in progress | Logbooks updated with assignments |
| Identified blockers or doubts | Blockers resolved or escalated |
| Objective for the meeting (required) | Clear next actions |

**Special cases by wave:**

| Meeting | Special output |
|---------|---------------|
| `CM Sub-Zero` (from-scratch) | `feasibility.json` + `foundation.json` |
| `CM Sub-Zero` (on-going) | `foundation.json` (from existing knowledge) |
| `CM W0` | `blueprint.json` + `waves/w1/roadmap.json` |

> Every CM must have a **stated objective** before it begins. Example: "CM W1 — Review authentication logbooks and unblock API dependency."

### 4.2 Blueprint Refinement (BR)

The change control meeting. Infrequent, high-impact.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Evaluate and approve changes to the product blueprint |
| **Convenes** | Any role (whoever identifies the need for change) |
| **Frequency** | On-demand — only when a product direction change is needed |
| **Participants** | Product Owner (required) + Coordinator + Technical Manager |

| Inputs | Outputs |
|--------|---------|
| Proposed change (what and why) | Decision: approved or rejected |
| Current `blueprint.json` | Updated `product_decisions[]` in blueprint |
| Active roadmaps and logbooks that may be affected | Impact assessment on active roadmaps |
| | Updated blueprint (if approved) |

**Why this meeting matters:** The blueprint is the source of truth for the entire product. A change here cascades to roadmaps, logbooks, and active work. This meeting ensures changes are deliberate, impact is understood, and the decision trail is preserved in `product_decisions[]`.

> A Blueprint Refinement can change capability priorities (essential ↔ non-essential), modify user flows, add or remove capabilities, or shift the product direction entirely. Every change must include the reason in the decision record.

### 4.3 QA & Demo

The wave gate. Quality validation and PO approval.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Validate completed work and get PO approval for production |
| **Naming** | QA + scope: `QA W1`, `QA W2`, or `QA W1-Phase2` |
| **Convenes** | Coordinator |
| **Frequency** | At the end of a roadmap or at the end of a group of phases |
| **Participants** | Product Owner (required) + Coordinator + Technical Manager + testers |

| Inputs | Outputs |
|--------|---------|
| Completed logbooks for the scope | PO approval or rejection |
| Acceptance criteria from the roadmap | List of observations/issues |
| **Planned test suite** (manual tests defined beforehand) | Decision: ready for production or iterate |
| List of confirmed participants | |

**Key rules:**

- The test plan must be **defined before the meeting**, not improvised during it.
- The scope can be a complete roadmap or a defined group of phases — what matters is that the scope is clear and agreed upon before the session.
- If the PO rejects, observations are converted into logbook entries for the next iteration.

### 4.4 Health Check (HC)

The team wellbeing assessment. Adapted from the [Spotify Squad Health Check](https://engineering.atspotify.com/2014/09/squad-health-check-model/) model created by Henrik Kniberg & Kristian Lindwall.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Assess team wellbeing, satisfaction with the product being built, and sense of participation |
| **Convenes** | Coordinator |
| **Frequency** | Recommended at wave closure; can also be requested by any team member |
| **Participants** | Entire team |

| Inputs | Outputs |
|--------|---------|
| Health Check dimensions (see below) | Health map with traffic-light scores |
| Previous Health Check results (for trend comparison) | Trend indicators (improving ↑, stable →, declining ↓) |
| | Concrete actions for red/yellow areas |

**Dimensions adapted for Waves:**

| Dimension | Awesome (green) | Needs attention (red) |
|-----------|----------------|----------------------|
| **Product quality** | "I'm proud of what we're building" | "The product feels rushed or incomplete" |
| **Participation** | "My input matters in product decisions" | "I feel like a task executor, not a team member" |
| **Work-life balance** | "Sustainable pace, I have time to recharge" | "Constant urgency, I feel burned out" |
| **Learning** | "I'm growing — new skills, new knowledge" | "I'm doing the same thing over and over" |
| **Clarity** | "I understand why we're building this" | "I'm coding without understanding the purpose" |
| **Tooling & AI** | "The AI agents help me deliver better work" | "I spend more time managing agents than building" |
| **Team support** | "I can ask for help and I get it" | "I feel isolated when I'm stuck" |
| **Delivery confidence** | "We'll ship something valuable this wave" | "I'm not sure this wave will produce results" |

**How it works:** For each dimension, every team member votes green (good), yellow (some concerns), or red (needs attention) and indicates the trend (improving, stable, declining). The value is in the conversation that follows the vote, not just the scores.

> The Spotify model recommends using physical or digital cards. In Waves, the Health Check results can be stored as a structured artifact for trend tracking across waves.

### 4.5 Wave Celebration (WC)

The positive closure. Recognition, learning, and launch.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Recognize achievements, document improvements, and confirm production launch |
| **Convenes** | Coordinator |
| **Frequency** | At the closure of each wave (after QA & Demo passes) |
| **Participants** | Entire team + Product Owner |

| Inputs | Outputs |
|--------|---------|
| Completed roadmap (satisfactory) | Recognition of team achievements |
| QA & Demo approval | Improvement notes for next wave |
| Verification that no roadmap items are pending | Production launch confirmed |

**Sequence:**

```
QA & Demo approves
  → Verify roadmap has no pending items
    → Wave Celebration
      → Deploy to production
```

**What happens in a Wave Celebration:**

1. **Recognize**: What went well? What are we proud of? Individual and team contributions.
2. **Learn**: What would we improve for the next wave? (Not blame — constructive notes.)
3. **Launch**: Confirm readiness and deploy to production.

> This is not a Scrum retrospective. The tone is celebratory, not forensic. Improvements are noted constructively, not as failures. The team has just delivered value — that deserves recognition.

---

## 5. Meeting summary

| Meeting | Code | Convenes | Frequency | PO required | Purpose |
|---------|------|----------|-----------|-------------|---------|
| Coordination Meeting | CM | Coordinator | On-demand, frequent | No (optional) | Planning and tactical tracking |
| Blueprint Refinement | BR | Any role | On-demand, infrequent | **Yes** | Controlled product changes |
| QA & Demo | QA | Coordinator | Per roadmap or phase group | **Yes** | Quality validation and approval |
| Health Check | HC | Coordinator | Per wave or on request | No | Team wellbeing and satisfaction |
| Wave Celebration | WC | Coordinator | Per wave closure | Yes | Recognition, learning, launch |

---

## 6. Artifacts and traceability

### 6.1 Artifact hierarchy

Waves supports two levels of blueprints. A **company blueprint** (optional) sits above product blueprints and represents the company as a whole — its vision, products, operations, and strategic capabilities. A **product blueprint** is the source of truth for a single product.

```
company_blueprint.json              ← WHO / WHY (Company identity and strategy)
  ├── products[]                    ← References to product blueprints
  │   └── blueprint.json            ← WHAT / WHY (Product definition)
  │        └── waves/wN/roadmap.json ← WHEN / ORDER (Wave plan)
  │             └── logbooks/*.json  ← HOW / DETAIL (Ticket implementation)
  ├── operational_areas[]           ← Non-product work (legal, admin, marketing)
  └── company_roadmaps[]           ← Operational/cross-product roadmaps
```

For most projects (single product, no company context), the hierarchy starts at the product blueprint:

```
blueprint.json                      ← WHAT / WHY (Product definition)
  └── waves/wN/roadmap.json         ← WHEN / ORDER (Wave plan)
       └── logbooks/*.json          ← HOW / DETAIL (Ticket implementation)
```

Information flows **downward**: the blueprint informs roadmaps, roadmaps spawn logbooks. Detail is never duplicated upward.

The `product_roadmaps` array in the blueprint links to all roadmaps. Each roadmap's milestones link to logbooks via `logbook_ref`. This creates a complete traceability chain: **blueprint → roadmaps → logbooks**.

### 6.2 The Golden Rule

> **Nothing exists in the project that is not supported in the product blueprint.**

Every roadmap references capabilities, flows, or views defined in the blueprint. Every logbook belongs to a roadmap. Every logbook entry must trace to its parent roadmap **and** the specific capability, flow, or view it supports.

If a logbook cannot trace to the blueprint, either the blueprint needs to be updated (via Blueprint Refinement) or the work should not exist.

### 6.3 Product scope and `ai_files/` placement

**Waves operates at the product level, not the repository level.** A product is a single coherent thing that gets delivered to users — it may live in one repository or span multiple repositories. Regardless of how many repos, packages, or services compose the product, there is **one** `ai_files/` directory that contains **one** blueprint, **one** set of roadmaps, and **one** set of logbooks for the entire product.

#### Single repository (most common)

One repo = one product = one `ai_files/` at the repo root.

```
my-product/
├── ai_files/           ← Waves artifacts for the product
├── lib/                ← Source code
└── ...
```

#### Monorepo (multiple packages, one product)

A product with frontend and backend packages in the same repo (e.g., using Melos, Nx, Turborepo). The `ai_files/` lives at the **monorepo root**, not inside individual packages. The blueprint describes the entire product. Roadmap phases can span multiple packages — a Wave 1 might have backend phases (1-3), frontend phases (4-7), and deployment (8) all under the same roadmap.

```
ecc/                         ← monorepo root
├── ai_files/                ← ONE set of artifacts for the entire product
│   ├── blueprint.json       ← describes the whole product (frontend + backend)
│   ├── project_manifest.json ← describes ALL packages
│   ├── project_rules.json   ← rules for ALL packages
│   └── waves/
│       └── w1/
│           ├── roadmap.json ← phases that span frontend and backend
│           └── logbooks/    ← logbooks that may touch any package
├── packages/
│   ├── ecc_app/             ← Frontend package
│   └── ecc_backend/         ← Backend package
└── melos.yaml
```

**Important:** AI agents working in a monorepo read `ai_files/` from the monorepo root. They do NOT look for `ai_files/` inside individual packages. The manifest should describe all packages as layers or components of the same product.

#### Multiple repositories, one product

Some products distribute their code across separate repos (e.g., frontend in one repo, backend in another, shared libraries in a third). In this case, choose **one** repo as the product's home — typically the one closest to the user-facing experience — and place `ai_files/` there. The other repos are referenced by their paths but don't maintain separate Waves artifacts.

```
org/product-app/             ← Product home
├── ai_files/                ← Waves artifacts live HERE
│   ├── blueprint.json
│   └── waves/
│       └── w1/
│           ├── roadmap.json ← milestones may reference other repos
│           └── logbooks/
├── lib/
└── ...

org/product-backend/         ← Supporting repo
├── lib/                     ← No ai_files/ here — the product is managed from product-app
└── ...
```

Roadmap milestones that involve work in other repos use `logbook_ref` with the portable cross-repo format: `org/repo::waves/wN/logbooks/file.json`. If a logbook must live in the other repo for practical reasons (the agent needs filesystem access to that codebase), the reference still traces back to the product's roadmap.

**The rule is simple: one product = one `ai_files/` = one blueprint. Always.**

### 6.4 Directory structure

All Waves artifacts live in the `ai_files/` directory at the product root:

```
ai_files/
├── user_pref.json                  ← User interaction preferences
├── project_manifest.json           ← Technical project analysis (software)
├── general_manifest.json           ← Project analysis (non-software)
├── project_rules.json              ← Coding rules and standards (software)
├── project_standards.json          ← Project standards (non-software)
├── architecture_map.json           ← Detailed architecture (software)
├── schemas/                        ← JSON schemas for artifact validation
│
├── feasibility.json                ← Sub-Zero output: market/technical feasibility
├── foundation.json                 ← Sub-Zero output: validated facts from feasibility
├── blueprint.json                  ← W0 output: complete product definition
│
└── waves/                          ← Delivery cycles
    ├── sub-zero/                   ← Validation / Knowledge acquisition
    │   ├── roadmap.json
    │   └── logbooks/
    ├── w0/                         ← Product definition
    │   ├── roadmap.json
    │   └── logbooks/
    ├── w1/                         ← Business wave 1
    │   ├── roadmap.json            ← Wave plan with phases and milestones
    │   ├── logbooks/               ← Implementation logbooks (per ticket)
    │   │   ├── TICKET-001.json
    │   │   └── TICKET-002.json
    │   └── resolutions/            ← Completion summaries
    │       └── TICKET-001-resolution.md
    └── wN/                         ← Subsequent business waves
        ├── roadmap.json
        ├── logbooks/
        └── resolutions/
```

**Key conventions:**

- **Product-level artifacts** (`blueprint.json`, `feasibility.json`, `foundation.json`) live at the `ai_files/` root because they describe the entire product, not a specific wave.
- **Wave-level artifacts** (`roadmap.json`, `logbooks/`, `resolutions/`) live inside their wave's directory. This makes association explicit — a logbook at `waves/w1/logbooks/TICKET.json` belongs to Wave 1.
- **Project-level artifacts** (`user_pref.json`, `project_manifest.json`, `project_rules.json`) live at the `ai_files/` root because they are shared across all waves.
- **Schemas** live in `ai_files/schemas/` for local validation reference.
- **Wave names** follow the convention: `sub-zero` for validation, `w0` for definition, `w1`, `w2`, ... `wN` for business waves.

**Cross-project references:** When a roadmap has milestones that reference logbooks in other repositories (e.g., a platform orchestration roadmap), the `logbook_ref` uses the portable format: `org/repo::waves/wN/logbooks/file.json`. Tools like ECC can resolve these via GitHub API.

### 6.5 Complete artifact map

| Artifact | Location | Created in | Updated in | Owner |
|----------|----------|-----------|------------|-------|
| `company_blueprint.json` | Company repo root | Once | As needed | CEO/Founder |
| `feasibility.json` | `ai_files/` | Sub-Zero | — | PO + AI |
| `foundation.json` | `ai_files/` | Sub-Zero | — | PO + AI |
| `blueprint.json` | `ai_files/` | W0 | Any wave (via BR) | PO |
| `waves/wN/roadmap.json` | `ai_files/waves/wN/` | W0 (for W1) / Wn-1 (for Wn) | Active wave | Coordinator |
| `waves/wN/logbooks/*.json` | `ai_files/waves/wN/logbooks/` | Active wave | Active wave | Technical Manager + AI |
| `waves/wN/resolutions/*.md` | `ai_files/waves/wN/resolutions/` | Wave closure | — | Technical Manager + AI |
| `project_manifest.json` | `ai_files/` | W0 | As needed | Technical Manager + AI |
| `project_rules.json` | `ai_files/` | W0 | As needed | Technical Manager + AI |
| `user_pref.json` | `ai_files/` | W0 | As needed | Individual |
| `schemas/` | `ai_files/schemas/` | W0 | As needed | Framework |

### 6.6 Artifact linkage

The traceability chain is maintained through explicit references:

```
blueprint.json
  └── product_roadmaps[]              ← Array of {wave, path} entries (prepend-only)
       └── waves/wN/roadmap.json
            └── milestones[].logbook_ref  ← Path to logbook file
                 └── waves/wN/logbooks/TICKET.json
                      └── parent_roadmap  ← Back-reference to roadmap
```

- `product_roadmaps` in the blueprint is managed exclusively by the `roadmap-create` command. New entries are always prepended (most recent first).
- `logbook_ref` in roadmap milestones points to the logbook implementing that milestone.
- `parent_roadmap` in each logbook points back to its parent roadmap.

### 6.7 Progressive refinement

The same concepts appear at multiple levels but evolve in detail:

| Concept | Blueprint level | Roadmap level | Logbook level |
|---------|----------------|---------------|---------------|
| Capability | "User can search products" | Phase 2, Milestone 3 | Objectives 1-4 with code refs |
| Quality | Design principles | Acceptance criteria | Completion guides |
| Decisions | `product_decisions[]` | Phase `decisions[]` | Context entries |

---

## 7. Progress metrics

### 7.1 Wave progress

Progress for each wave is calculated from its roadmap:

```
wave_progress = milestones_achieved / total_milestones
```

A milestone counts as achieved when its `status` is `achieved` or `completed`.

### 7.2 Product progress

Product-level progress aggregates ALL milestones across ALL waves:

```
product_progress = total_achieved_across_all_waves / total_milestones_across_all_waves
```

**Important:** Adding a new wave with new milestones increases the denominator, which can **lower** the product progress percentage. This is by design — it reflects the actual scope of the product.

### 7.3 Delivery velocity

When a milestone transitions to `achieved`, its completion date should be recorded. This enables calculating:

```
velocity = milestones_achieved / time_period
```

This is the relevant productivity metric for AI-assisted development, where the bottleneck is validation and QA, not coding speed.

### 7.4 Ecosystem progress (for companies)

When a `company_blueprint.json` exists with multiple products, ecosystem progress is the average of all active product progresses:

```
ecosystem_progress = average(product_progress for each active product)
```

Tools like ECC can display this alongside per-product and per-wave breakdowns.

---

## 8. Wave lifecycle

### 8.1 Opening a wave

1. A roadmap for the wave exists (created in the previous wave or in W0).
2. The roadmap is registered in `blueprint.json` → `product_roadmaps[]`.
3. The Coordinator convenes the first CM for the wave.
4. Logbooks are created from the roadmap milestones.
5. Work begins.

### 8.2 During a wave

1. CMs are convened as needed to track progress and resolve blockers.
2. Logbooks are updated continuously by Technical Managers + AI agents.
3. If the product direction needs to change, a BR is convened.
4. Roadmap is updated with progress and decisions.

### 8.3 Closing a wave

```
1. All roadmap items completed (or consciously deferred)
2. QA & Demo convened → PO approves
3. Verify no pending roadmap items
4. Wave Celebration → recognize, learn, launch
5. Deploy to production
6. Health Check (recommended)
7. Next wave roadmap prepared (waves/w[n+1]/roadmap.json)
```

### 8.4 Wave gate: Go/No-Go (Sub-Zero → W0)

This gate deserves special attention. It is the most critical decision point in the framework — where the Product Owner evaluates whether to invest in product definition or stop.

| Aspect | Detail |
|--------|--------|
| **Trigger** | Sub-Zero wave completes with feasibility + foundation |
| **Decision maker** | Product Owner |
| **Data** | `feasibility.json` (projections, Monte Carlo, kill criteria) + `foundation.json` (validated facts, SWOT, unit economics) |
| **Outcomes** | **Go**: proceed to W0 and invest in product definition. **No-go**: stop, pivot, or archive with documented reasons |

> The `kill_criteria` defined in the feasibility schema provide objective thresholds for the no-go decision. If the numbers don't work, the numbers don't work — no amount of optimism should override data.

---

## 9. Company blueprint (optional)

For organizations managing multiple products, a `company_blueprint.json` provides the strategic layer above individual product blueprints.

### 9.1 What it contains

| Section | Purpose |
|---------|---------|
| **identity** | Vision, mission, and values of the company |
| **market** | Problem the company solves, opportunity, target market, competitive advantage |
| **hypothesis** | The core bet — if this is true, the company succeeds |
| **strategic_capabilities** | What the company must be able to do (each maps to products) |
| **products** | Index of all products with references to their blueprints |
| **operational_areas** | Non-product functions (legal, finance, marketing, HR) |
| **revenue_model** | How the company makes money (or plans to) |
| **channels** | How products reach users (discovery, acquisition, retention) |
| **partnerships** | External dependencies with risk assessment |
| **cost_structure** | Recurring costs to keep the company alive |
| **team** | People and AI agents with their responsibilities |
| **key_dates** | Deadlines with real consequences (permits, contracts, launches) |
| **company_roadmaps** | Roadmaps for operational and cross-product work |
| **company_decisions** | Strategic decisions with full context |

### 9.2 How it connects

```
company_blueprint.json
  ├── strategic_capabilities[].product_refs  → products[].codename
  ├── products[].blueprint_path              → org/repo::ai_files/blueprint.json
  ├── company_roadmaps[].path               → waves/wN/roadmap.json
  └── key_dates[]                           → dates that tools can monitor and alert
```

### 9.3 Cross-project roadmaps

Some roadmaps orchestrate work across multiple repositories (e.g., extracting shared libraries from multiple projects). These roadmaps follow the same Waves structure but their milestones reference logbooks in other repos using the portable format:

```json
"logbook_ref": "org/repo::waves/wN/logbooks/file.json"
```

---

## 10. Comparison with Scrum

| Concept | Scrum | Waves |
|---------|-------|-------|
| Delivery cycle | Sprint (fixed 2-4 weeks) | Wave (variable, organic) |
| Product backlog | Backlog items | `blueprint.json` |
| Sprint backlog | Sprint items | `waves/wN/roadmap.json` |
| Task tracking | Tickets on board | `waves/wN/logbooks/*.json` |
| Roles | PO, Scrum Master, Developers | PO, Coordinator, Technical Manager (each + AI agents) |
| Sprint Planning | Fixed ceremony | CM (on-demand, with stated objective) |
| Daily Standup | Daily, 15 min | CM (on-demand, as needed) |
| Sprint Review | End of sprint | QA & Demo (per roadmap/phase group) |
| Sprint Retrospective | End of sprint | Wave Celebration + Health Check |
| Backlog Refinement | Regular ceremony | Blueprint Refinement (on-demand, impact-driven) |
| Definition of Done | Checklist | Roadmap acceptance criteria + logbook completion guides |
| Scaling | SAFe, LeSS, Nexus | Multiple overlapping waves per product area |
| Velocity metric | Story points per sprint | Wave throughput (capabilities delivered per wave) |
| Progress tracking | Burndown charts | Milestones achieved / total (per wave and global) |
| Rule enforcement | Social agreement (degrades over time) | Executable hooks (cannot be ignored) |
| Decision classification | None — all decisions treated equally | 5 levels with graduated autonomy |
| AI agent awareness | None — agents start every session blind | Full product state injected at session start |
| Context survival | N/A | Auto re-injection after compaction |
| Strategic metacognition | Retrospective (end of sprint, forensic) | Real-time: on objective completion, blueprint change, phase completion |

---

## 11. Principles

1. **Organic over ceremonial.** Meetings happen when they're needed, not when the calendar says.
2. **Data over opinion.** Feasibility uses Monte Carlo simulations, not gut feelings. Decisions are recorded with reasons.
3. **Traceability over documentation.** Every piece of work traces to the blueprint. The structure enforces coherence without bureaucracy.
4. **AI as team member.** Agents are not tools — they have defined responsibilities within each role.
5. **Variable over fixed.** A wave lasts as long as it needs. No artificial boundaries, no wasted ceremony.
6. **Celebration over forensics.** Wave closures recognize achievement first, then note improvements constructively.
7. **Blueprint as living document.** The product evolves through controlled change, not frozen specs or uncontrolled drift.
8. **Enforcement over instruction.** Rules that can be ignored will be ignored. Hooks enforce the framework with code, not prose.

---

## 12. Decision Classification (Waves 2.0)

The agent classifies its own decisions in real-time. Classification is reinforced by injection on every PreToolUse event (Claude Code) or via CLAUDE.md instructions (all platforms).

| Level | Type | Agent action |
|-------|------|-------------|
| **1** | Mechanical implementation (naming, formatting) | Full autonomy. Proceeds silently. |
| **2** | Technical implementation (pattern, module structure) | Autonomy with logbook documentation. |
| **3** | Scope decision (outside current objective's scope) | **STOPS.** Informs user. Waits for approval. |
| **4** | Business decision (affects a blueprint capability) | **STOPS.** Projects scenarios with tradeoffs. Waits. |
| **5** | Discovery (solution with independent market value) | **STOPS.** Documents. Projects value. Advises. |

**The trust contract:** When in doubt, the agent classifies **UP** (more caution), never down. This conservative bias is by design — it ensures the human retains authority over decisions that matter.

Classification was validated with 18 benchmark scenarios across all 5 levels: 100% correct actions, 89% exact level match, with the 2 deviations both classifying conservatively upward.

### 12.1 Mixed-level scenarios (escalation)

During execution, a task can escalate from one level to another. For example:
- A variable rename (level 1) may reveal cross-script dependencies (level 3)
- A bug fix (level 2) may uncover a schema ambiguity that contradicts a design principle (level 4)
- A helper function (level 2) may become a general-purpose tool with market value (level 5)

The agent must detect these escalations and re-classify. This was validated with 3 mixed scenarios — all escalations were detected correctly.

---

## 13. Hooks Architecture (Waves 2.x, Claude Code)

Waves 2.x uses Claude Code hooks — bash scripts that execute obligatorily at lifecycle events. These are not suggestions; they are code that runs before, during, or after every agent action. The hook set has grown across the 2.x line as new defense layers were added.

### 13.1 Current hook inventory (2.3.0)

| Hook | Event | Purpose | Introduced |
|------|-------|---------|------------|
| `waves-perceive.sh` | SessionStart | Read artifact graph, inject product state, surface pending audits and decisions | 2.0 |
| `waves-gate.sh` | PreToolUse (Edit\|Write\|Bash) | Graduated enforcement + classification reminder + metacognition pending check | 2.0 |
| `waves-doc-enforce.sh` | PostToolUse (Edit\|Write) | Ensure recent_context entries are written when objectives complete | 2.0 |
| `waves-metacognition.sh` | PostToolUse (Edit\|Write) | Spawn background advisor subagent when primary objective completes (throttled) | 2.0 → 2.1 |
| `waves-blueprint-impact.sh` | PostToolUse (Edit\|Write) | Project cascading impacts when blueprint changes | 2.0 |
| `waves-phase-audit.sh` | PostToolUse (Edit\|Write) | Strategic audit when roadmap phase completes | 2.0 |
| `waves-dart-analyze.sh` | PostToolUse (Edit\|Write) | Run `dart analyze` on .dart files | 2.0 |
| `waves-rules-audit.sh` | PostToolUse (Edit\|Write) | Dispatch background Opus auditor when primary completes (Layer C trigger) | 2.1.9 |
| `waves-rules-audit-injector.sh` | PostToolUse (Edit\|Write) | Surface audit findings at next Edit/Write; trigger re-audit on scope file edits (Layer C injector) | 2.1.9 |

### 13.2 Graduated enforcement logic (`waves-gate.sh`)

```
Does blueprint.json exist?
├── NO → Allow everything. Project is in shaping phase.
│
└── YES → Waves enforcement activates.
    │
    ├── Does an active roadmap exist?
    │   ├── NO → BLOCK. "Create a roadmap before implementing."
    │   └── YES →
    │       ├── Does a logbook exist?
    │       │   ├── NO → BLOCK. "Create a logbook for this task."
    │       │   └── YES → ALLOW + inject classification reminder
    │       └──
    └──
```

The gate also whitelists `ai_files/` writes (so the agent can create the missing artifacts), git workflow commands, framework-internal files, and read-only Bash commands. A consent bypass exists via `.claude/waves-gate-bypass` for one-off escapes that are logged.

### 13.3 Delta detection

PostToolUse hooks use marker files in `/tmp/waves-*/` to detect state changes:

1. On first run, the hook counts completed objectives (or phases) and stores the count in a marker file.
2. On subsequent runs, it compares the current count with the stored count.
3. If the count increased, a trigger fires.

Path normalization (`cd "$(dirname "$FILE")" && pwd`) prevents hash mismatches between absolute and relative paths — a bug that caused circular re-triggers in 2.0 and was fixed in 2.1.

This approach is stateless (no database), fast (<1ms for non-matching files), and resilient (marker files are per-session, automatically cleaned on reboot). A 60-second cooldown after marker clearance prevents the agent from re-triggering itself when writing the post-metacognition response.

### 13.4 Platform availability

| Feature | Claude Code | Claude Desktop (Plugin) | Codex / Gemini CLI |
|---------|-------------|------------------------|-------------------|
| Perception (state injection) | Hook (mechanical) | Prompt (degradable) | CLAUDE.md (degradable) |
| Enforcement (blocking) | Hook (exit 2, non-bypassable) | Not available | Not available |
| Classification reminder | Hook (re-injected every action) | Prompt (session start only) | CLAUDE.md (degradable) |
| Metacognition triggers | Hook (automatic on delta) | Not available | Not available |
| Adversarial subagents (Layers C, D, orthogonality) | Hook (background subagent spawn) | Not available | Not available |
| Context survival (post-compaction) | Hook (automatic re-injection) | Not available | Not available |
| Artifact structure | Schema-validated JSON | Schema-validated JSON | Schema-validated JSON |
| Commands | Slash commands | Slash commands | Manual prompts |

---

## 14. Defense Layers (Waves 2.1+)

Rule drift — the silent failure where an agent writes code that violates declared project rules — was the most common pattern observed in real-world Waves projects, especially in frontend code where convention violations are syntactically valid (`Color(0xFFFF0000)` compiles even when the rule says "use theme tokens"). The 2.1 and 2.2 releases introduced four coordinated defense layers, each closing a specific gap.

### 14.1 Layer A — Inline rule text in `completion_guide` (2.1.9)

The `completion_guide` of every secondary objective gets appended with one entry per applicable rule in the format:

```
Apply rule #N: <full rule text from project_rules.json>
```

**The gap this closes:** rule IDs alone (`scope.rules: [3, 7, 12]`) force the implementer to mentally jump to `project_rules.json` on every step. That context switch is silently skipped under cognitive load. Inline text makes the constraint physically present at the moment of writing code.

### 14.2 Layer B — Rules-in-scope banner (2.1.9)

Before any implementation work, `/waves:objectives-implement` prints the full rule text for every rule in the current objective's `scope.rules`:

```
═══ Rules in scope for this objective ═══
#3 [naming_conventions, local]: <full rule description>
#7 [presentation_layer, ecosystem]: <full rule description>
═══════════════════════════════════════════
```

When the logbook has 2+ main objectives, a **sibling primaries banner** also prints — showing DONE, THIS (current), and DEFERRED primaries so the agent knows what NOT to attend in the current objective.

**The gap this closes:** even with Layer A in place, a saturated context can lose the rules to scrollback. Reprinting them at the start of each objective re-anchors attention.

### 14.3 Layer C — Post-implementation rules audit subagent (2.1.9)

When a primary objective transitions to `completed`, the PostToolUse hook `waves-rules-audit.sh` dispatches a background Opus subagent that:

- Reads the diff for the primary's `scope.files`
- Loads the full text of rules in `scope.rules`
- Sibling-aware: receives the list of sibling primaries with DONE/DEFERRED state so it audits **scope-by-elimination** (it does not flag the absence of behavior in a primary that was scoped to structure only)
- Classifies each violation by trust contract level (1-5)
- Writes findings to `ai_files/waves/wN/audits/primary-N.json`

A companion hook `waves-rules-audit-injector.sh` surfaces findings at the agent's next Edit/Write via `additionalContext` (non-blocking — auto-edits continue). Level 1-2 violations are auto-fixed; level 3+ surface to the user with structural citation. Iteration cap of 3, then escalation.

**The gap this closes:** the original auto-audit was self-audit — the same agent that wrote the code was checking it. Optimism bias made false-negatives common. A fresh adversarial subagent with structural citation requirement catches what self-audit misses.

### 14.4 Layer D — Logbook integrity audit (2.2.0)

When `/waves:logbook-create` finishes persisting a new logbook, Step A6 spawns an adversarial Opus subagent that reads the persisted logbook from disk (not memory) and validates:

- Every primary's `scope.rules` is populated when applicable rules exist
- Every secondary's `completion_guide` contains the `Apply rule #N` lines for inherited rules (Layer A enforcement)
- Rule IDs reference rules that exist in `project_rules.json`
- Multi-focus declarations match the actual count of primaries
- Primary contents are distinctive (not duplicates with different verbs)
- `scope.files` paths exist or are marked `(new)`

Findings are written to `ai_files/waves/wN/audits/logbook-<basename>.json` with severities `critical` and `warning` only. The main agent applies fixes with full context (the subagent reports, never auto-edits).

`/waves:logbook-update` runs the same audit unconditionally at the end (with a documented escape hatch for the rare case it is unnecessary).

**The gap this closes:** if the logbook ships with empty `scope.rules` or missing `Apply rule` lines, Layers A/B/C have nothing to enforce. Layer D is the front-door check.

### 14.5 Layer interactions

The four layers operate as defense in depth, calibrated for the failure mode each one targets:

- **Layer D** catches logbook construction failures *before* implementation
- **Layer A** physically embeds rules in the unit of work
- **Layer B** re-presents them at the moment of writing
- **Layer C** verifies the final code against the rules *after* implementation

If any one layer fails, the others still operate. If all four fail, the architectural design (`scope.rules`, `completion_guide`, adversarial subagents) provides one last social safety net via the next session's metacognition.

---

## 15. Adversarial Subagents (Waves 2.1+)

Waves 2.x introduces several **adversarial subagents** — fresh Opus subagents spawned in background or blocking mode whose prompt explicitly instructs them to challenge the main agent's plan, not validate it.

### 15.1 Pattern: fresh context + adversarial framing + structural output

All adversarial subagents share three properties:

1. **Fresh context**: they do NOT inherit the main agent's saturated context. They receive only the files they need to read from disk + a focused prompt. This breaks the bias of "I just wrote this, it must be correct".
2. **Adversarial framing**: the prompt explicitly tells them to assume the main agent is biased toward speed/optimism and to look for what's missing or wrong. Without this framing, subagents tend to confirm.
3. **Structured output**: JSON to a known disk path. The main agent reads the output, the subagent does not edit logbooks or code directly. Separation of concerns.

### 15.2 Catalog

| Subagent | Trigger | Job | Blocking? |
|---|---|---|---|
| **Orthogonality reviewer** (Step A2.5 of `logbook-create`) | Before primary objectives are generated | Decide single_focus vs multi_focus. Biased toward multi_focus. Returns dimensions + suggested primaries | Yes (blocks generation) |
| **Logbook integrity reviewer** (Step A6) | After logbook is persisted | Audit logbook against schema and Layer A discipline. Returns critical/warning findings | Yes (blocks persist completion) |
| **Rules auditor** (Layer C, post-impl) | When primary objective completes | Audit diff vs rules with structural citation. Classifies violations by level | No (background, surfaces at next Edit) |
| **Background advisor** (metacognition) | Throttled at `floor(N/2)` primary completions, on blueprint change, on phase completion | Reads project snapshot, returns blockers, risks, opportunities, cross-vertical findings | No (background, interrupts only if critical) |

### 15.3 Why background-with-injection (not blocking)

The rules auditor and the background advisor are non-blocking. The main agent does not wait for them. Findings are surfaced at the next Edit/Write via `additionalContext` injection. This preserves auto-edit flow but still surfaces gaps the main agent missed.

The orthogonality reviewer and integrity reviewer are blocking because their output conditions the next step (decomposition decision, persistence completion) and the main agent has nothing valid to do without them.

---

## 16. Project Types

Waves 2.3 supports three project categories. The category is declared in `user_pref.json` → `project_context.project_type` and routes commands to the appropriate flow.

| Type | Manifest schema | When to use |
|---|---|---|
| **`software`** | `software_manifest_schema.json` | Traditional applications with source code, build systems, layered architectures (presentation, domain, data). Examples: Flutter apps, web services, libraries. |
| **`general`** | `general_manifest_schema.json` | Non-software projects: academic research, creative work, business operations. Open structure with custom sections. |
| **`agentic`** | `agentic_manifest_schema.json` | Projects whose value is an orchestration of agents/subagents with skills, hooks, tools, and configurations. The "code" is skill markdown files, hook JSON configs, and prompts. |

### 16.1 The agentic schema (15 sections)

The `agentic_manifest_schema.json` was empirically ratified with three cases before being frozen — a production pilot (medical corpus ingestion pipeline orchestrated by Claude Code + Claude Browser + Claude Desktop) and two projected cases (Customer Operations Hub, Compliance Operations Center). The schema models structural concepts that recur across agentic projects without imposing domain-specific values:

1. **`project`** — name, codename, description, kind (free string: pipeline, assistant, monitoring, orchestration, research)
2. **`orchestration`** — primary_agent, communication_protocol, write_ownership_policy, approval_gates
3. **`roles`** — array of declared roles (NO fixed enum; each project declares its own)
4. **`subagents`** — lifecycle (ephemeral | persistent | hybrid), logbooks_dir
5. **`skills`** — directory, format (markdown_with_frontmatter | json_definitions | code_modules), versioning_required
6. **`tools`** — array of capabilities (MCPs, APIs, browsers, filesystems, CLIs)
7. **`data_sources`** — origins of input data
8. **`state_contracts`** — persistent state structures with single-writer partitioning
9. **`handoff_contracts`** — file-based handoffs between roles
10. **`pipelines`** — stages with state transitions and stuck_threshold_seconds
11. **`integration_contracts`** — downstream system contracts
12. **`triggers`** — manual / event / schedule / agent_cascade
13. **`governance`** — owner_escape_hatch, scope_boundaries, budget_controls
14. **`observability`** — log_level (errors_only | errors_and_outputs | decisions_full | verbose)
15. **`source_access_modes`** — free-string array (api, scraping, manual_handoff, institutional_negotiation, etc.)

### 16.2 Why roles are NOT a fixed enum

The three empirical cases declared 8, 5, and 6 different roles respectively — none with full name overlap except for "orchestrator". Forcing an enum would have meant over-fitting to whichever case shipped first. Roles is a free array; each project declares its own with `tools_authorized` and `tools_forbidden` to encode the security boundary.

### 16.3 Single-writer-per-file as the concurrency primitive

The pilot demonstrated that with many parallel subagents writing state, the most resilient policy is **one file = one writer**. The orchestrator owns its own files; each subagent owns its own registry partition; the verifier role is strictly read-only. Locks are avoided by construction. State contracts declare their `partitioning` (by_subagent, by_specialty, by_jurisdiction, by_severity, etc.) — each partition is an independently writable file.

### 16.4 The 4 defense layers + adversarial subagents apply identically to agentic projects

`/waves:objectives-implement`, `/waves:logbook-create`, `/waves:logbook-update` accept `project_type === "agentic"` and reuse `logbook_software_schema.json`. The schema is structurally compatible — agentic logbooks point `scope.files` to skill markdown / hook JSON / prompt files instead of source code, but the rest is identical. Layer A still injects rule text; Layer B prints the banner; Layer C audits the diff against rules; Layer D validates the logbook integrity. The adversarial subagents operate on diffs and structural validation, agnostic to file type.

---

## 17. Background Metacognition (Waves 2.1)

The 2.0 metacognition was synchronous and disruptive — when a primary completed, the main agent paused, reflected, and consumed Opus tokens before continuing. The 2.1 redesign moved metacognition to **background subagent spawn** while keeping all the cognitive benefits.

### 17.1 Triggers (delta-detected)

| Trigger | When it fires |
|---|---|
| Primary objective completed | Every time main objective count transitions up. Throttled at `floor(total_main / 2)` intervals; fires when all done regardless. |
| Blueprint changed | Any edit to `blueprint.json` |
| Phase completed | Phase status transitions to `completed` in roadmap |

### 17.2 Lifecycle

1. PostToolUse hook detects the delta via marker file comparison.
2. Hook emits `additionalContext` instructing the main agent: "spawn subagent with this prompt".
3. Main agent spawns `Agent(run_in_background=true)` with the configured model (default Opus, configurable via `agent_config.metacognition_model` in user_pref).
4. Main agent continues with the next objective. **The metacognition does not block.**
5. Subagent reads blueprint + roadmaps + logbooks, returns observations.
6. Main agent surfaces findings to the user if critical; otherwise records to logbook.

### 17.3 Cooldown and circular-trigger prevention

A 60-second cooldown is written after the metacognition gate clears, preventing the agent from re-triggering itself when its post-metacognition write to the logbook itself fires the same hook. Path normalization (`cd + pwd`) prevents marker hash mismatches between absolute and relative paths — a subtle bug that caused infinite loops in 2.0.

### 17.4 Cross-vertical serendipity (2.1.x prompt enhancement)

The metacognition prompt explicitly asks: *"Does what is being built here directly solve an operational problem in another area or business vertical that the team hasn't considered — not speculatively, but with concrete and relevant impact?"* This was added after empirical observation that the same agentic pipeline pattern useful for medical corpus ingestion (pilot project) was also useful for customer operations and compliance monitoring (projected projects) — a serendipity worth surfacing automatically.

### 17.5 Mechanical roadmap progress notes

Independent of the throttled metacognition, every primary objective completion writes a mechanical `[AUTO]` note to the roadmap's `decisions[]` array:

```
[AUTO] Logbook <filename>: primary objective completed — <content>.
State: main 3/5, secondary 12/19
```

This guarantees visibility of progress even when logbooks are incomplete or sessions end abruptly. The note is a fact, not a reflection — it always fires.

---

## 18. Upgrade Discipline

Waves uses an incremental, version-aware migration system to keep deployed projects consistent with the framework.

### 18.1 Marker file

Each project carries `.claude/waves-version` with the version that last completed migrations. `/waves:upgrade` reads this marker, applies only migrations newer than the local version, and updates the marker only after all migrations succeed.

A subtle bug in 2.1.6 had `bin/waves upgrade` writing the marker *before* `/waves:upgrade` ran migrations — causing projects to skip pending migrations silently. Fixed in 2.1.7: the slash command owns the marker exclusively.

### 18.2 Migration registry

The `/waves:upgrade` command markdown contains a versioned migration registry. Each migration has:

- Narrative (shown only when relevant)
- Optional question (asked only if a setting is missing — e.g. `metacognition_model` was added in 2.1.0)
- Artifact patches (applied only if fields are missing — e.g. `recent_context` and `history_summary` were added to blueprint in 2.1.5; `audit` was added to logbook in 2.2.0)

### 18.3 Template substitution for `current_version`

The slash command markdown uses `{{CURRENT_VERSION}}` as a placeholder. `bin/waves` substitutes the placeholder with its own `$VERSION` at copy time. This means a release that bumps `bin/waves` propagates the new target version into the slash command automatically — no manual sync.

### 18.4 Schema soft migration on logbook load

`/waves:logbook-update` performs a soft schema migration when it loads a logbook: if required fields are missing (e.g. a pre-2.2 logbook lacks the `audit` object), they are added with their defaults before any operation. Pre-existing values are never modified.

### 18.5 Pre-flight schema validation in releases

After 2.1.7 shipped with a malformed `logbook_software_schema.json` (the `recommendations` field had been added with a stray brace that broke parsing), the release process now mandates `jq empty` validation on every schema before any tag can be created. This is enforced both in `VERSIONING_PROCESS.md` and in the doc-sync hook (see Section 18.6).

### 18.6 Doc-sync hook (release-time check, added in 2.3.x)

When `git tag v*` is executed, a PreToolUse hook validates that the tagged commit modified `FRAMEWORK.md` and `CHANGELOG.md` together — preventing the regression that left FRAMEWORK.md frozen at 2.0 while 17 releases shipped without it. A `.claude/waves-doc-sync-bypass` file allows documented exceptions (e.g. patch-only releases) to proceed.

---

## 19. Origin & Lineage

Waves did not begin as a framework. It began as a workaround.

### 19.1 Genesis (2025-07-10 → 2025-11-10): the WhatsApp agent and `ai_logbook`

In July 2025, the project that would become Waves did not exist by that name. The owner was building **givannia_desktop**, a Flutter desktop application that ran a Node.js + Baileys WhatsApp agent embedded in sandbox — a conversational AI agent for businesses. The technical problem was acute: the agent migrated between Claude Code, Codex, and Gemini CLI as token budgets ran out, and the agent needed to preserve context across those migrations.

The solution was structural. On 2025-07-10, the same day as the project's initial commit, the directory `ai_logbook/` was introduced containing three JSON schemas:

- `logbook_schema.json` — dynamic bitácora with `recent_context` (15-entry sliding window), `history_summary` (compacted history), `objectives_present/past`, `future_reminders`, and an emotional `mood` field
- `project_manifest_schema.json` — tech stack, modular structure, layered architecture
- `project_rules_schema.json` — project rules grouped by category (architecture, testing, naming, presentation, data, API, infra)

This was not a framework. It was a working pattern. The compaction algorithm (when `recent_context` filled, the oldest entry was summarized and archived to `history_summary`) and the schema-validated JSON shape are unchanged in Waves 2.3.0 four years later. **Every artifact in Waves today inherits its lineage from `ai_logbook`.**

### 19.2 Formalization as `ai-behavior` (2025-11-11 → 2026-03-12)

After 4 months of using the `ai_logbook` pattern in production, the owner generalized it into a standalone framework: **ai-behavior**. The first commit (`0c033b3` on 2025-11-11) was an "Initial commit". By 2026-02-13 the framework had structured releases:

- **v0.1.0** (2026-02-13) — Core protocol: 9 JSON schemas, 31 subagents, 11 slash commands, cowork plugin
- **v0.2.0** (2026-02-26) — Roadmap schema + commands
- **v0.2.1** (2026-03-08) — **Removed subagent delegation** from `objectives-implement` after empirical evidence that delegated subagents lost the accumulated context (project rules, manifest, resolved decisions). The main agent executes; subagents only audit. This decision is still load-bearing in Waves today.
- **v0.3.0** (2026-03-09) — Feasibility analysis with Monte Carlo + Bayesian, Homebrew formula, plugin package
- **v1.0.0** (2026-03-10) — First stable
- **v1.1.0** (2026-03-11) — Foundation + Blueprint commands, standardized wave naming (`roadmap_w0.json` ... `roadmap_wN.json`)

The IMPLEMENTATION_GUIDE.md of the ai-behavior era credited early conceptual inspiration to the **Agent OS framework** (Cased). That conceptual heritage was absorbed and does not appear in the current Waves implementation, but it deserves acknowledgement: ai-behavior was the first version to formalize "AI agent as team member" rather than "AI as tool", and Agent OS was part of the conversation that made the framing thinkable.

### 19.3 Rebrand to Waves (2026-03-13)

Commit `2cda84d` — "rebrand: rename ai-behavior to Waves". 102 files renamed. The identity changed; the philosophy did not. The commit message itself states the rationale: *"Identity change reflecting AI-era product development philosophy. Wave-based delivery cycles replace fixed-cadence sprints in AI-assisted development."* The name "Waves" was already the term used internally for delivery cycles since v0.1.0 — the rebrand promoted it from concept to identity.

### 19.4 Product Consciousness (2026-04-15 onward)

Waves 2.0 introduced what the framework now calls **Product Consciousness**: hooks that enforce rules mechanically instead of relying on social CLAUDE.md instructions; a 5-level decision classification (the trust contract); SessionStart perception of the artifact graph; proactive metacognition triggers. This was not a new framework. It was the moment the existing framework gained the property that distinguishes it from documentation systems: **rules that cannot be ignored**.

The 2.1 line moved metacognition to background subagents. The 2.2 line added orthogonality and integrity gates that catch logbook construction failures before code is written. The 2.3 line added the `agentic` project type, validated empirically with the medical corpus pipeline that was itself a descendant of the original WhatsApp agent.

### 19.5 What this lineage means

Waves is what happens when a working pattern is used in production long enough to be generalized, then formalized, then renamed, then hardened against its own failure modes. The result is not academic. Every defense layer, every adversarial subagent, every schema field exists because a real project failed without it. The compaction algorithm in `recent_context` predates the framework by months. The decision to remove subagent delegation predates Waves by a year. The trust contract (5-level decision classification) was named in 2026-04 but its essence — "agent stops on scope, business, and discovery decisions" — was in the schemas from day one.

The framework's authority comes from its origin: it was used before it was designed.

---

## 20. Glossary

| Term | Definition |
|------|-----------|
| **Wave** | An organic, variable-length delivery cycle. Complete unit from validation to production. |
| **Sub-Zero** | The first wave. Validation (from-scratch) or knowledge acquisition (on-going). |
| **W0** | Definition wave. Product blueprint, first roadmap, project setup. |
| **W1+** | Business waves. Feature implementation and delivery to production. |
| **Company Blueprint** | Strategic document for the company. Maps products, capabilities, operations, and finances. |
| **Blueprint** | The product backlog in Waves. Source of truth for what the product is and why. |
| **Roadmap** | Wave-level plan. What to build in what order, with milestones and phases. |
| **Logbook** | Ticket-level tracking. Objectives, progress, context, completion guides. |
| **Resolution** | Completion summary of a logbook. Documents what was done and learned. |
| **Foundation** | Compacted output of feasibility analysis. Bridge between research and definition. |
| **Gate** | Decision point between waves. Requires PO approval to proceed. |
| **Golden Rule** | Nothing exists in the project without being supported in the product blueprint. |
| **Product Roadmaps** | Array in blueprint linking to all wave roadmaps. Prepend-only, most recent first. |
| **CM** | Coordination Meeting. Tactical, frequent, on-demand. |
| **BR** | Blueprint Refinement. Change control for the product. |
| **QA** | QA & Demo. Validation gate for production approval. |
| **HC** | Health Check. Team wellbeing assessment based on Spotify model. |
| **WC** | Wave Celebration. Positive closure with recognition, learning, and launch. |
| **Hook** | Bash script that executes obligatorily at a Claude Code lifecycle event. Cannot be bypassed by the agent. |
| **Perception** | The act of reading the artifact graph and injecting product state at session start. |
| **Enforcement** | Mechanical blocking of actions when required artifacts are missing. Uses exit 2 in hooks. |
| **Classification** | The 5-level system for categorizing agent decisions by impact. Levels 1-2 proceed; 3+ stop. |
| **Trust contract** | The 5-level classification framed as an explicit contract: the agent retains autonomy on levels 1-2; the human retains authority on levels 3-5. When in doubt, classify up. |
| **Metacognition** | Proactive reflection triggered automatically when objectives complete, blueprints change, or phases finish. Runs as a background subagent in 2.1+. |
| **Marker file** | Temporary file in /tmp/ used by hooks to detect state changes (delta detection) between tool calls. |
| **Graduated governance** | Enforcement that scales with project maturity: no blueprint → permissive; blueprint → enforced. |
| **Layer A** | Inline rule text injection into completion_guide of every secondary objective. |
| **Layer B** | Rules-in-scope banner printed at the start of every objective implementation. |
| **Layer C** | Background post-implementation rules audit subagent. Surfaces violations classified by trust contract level. |
| **Layer D** | Logbook integrity audit subagent. Runs post-persist to validate Layer A discipline, scope.rules completeness, decomposition consistency. |
| **Orthogonality reviewer** | Adversarial subagent invoked in Step A2.5 of `logbook-create`. Decides single_focus vs multi_focus before primaries are generated. |
| **Adversarial subagent** | A fresh subagent whose prompt explicitly instructs it to challenge the main agent's plan, not validate it. Fresh context + adversarial framing + structured output. |
| **Project type** | `software`, `general`, or `agentic`. Declared in `user_pref.project_context.project_type`. Routes commands to the appropriate flow. |
| **Agentic project** | A project whose value is an orchestration of agents/subagents with skills, hooks, tools, and configurations. Validated empirically across 3 cases before the schema was frozen. |
| **State contract** | A persistent state structure governed by a JSON schema and owned by exactly one writer role. Enables single-writer-per-file concurrency without locks. |
| **Approval gate** | A decision that requires approval (human or graduated condition) before execution. Supports free-form `auto_approve_when` conditions and `fallback` semantics. |
| **Scope (rule)** | A rule's `scope` field is either `"ecosystem"` (shared across organization, immutable locally) or `"local"` (project-specific). The basis of organizational rule governance. |
| **ai_logbook** | The original pattern (2025-07-10) that became `ai_files/`. Predecessor of all current artifact directories. |
| **ai-behavior** | The framework's name from 2025-11-11 to 2026-03-13. Renamed to Waves on 2026-03-13. |

---

## References

- [Spotify Squad Health Check Model](https://engineering.atspotify.com/2014/09/squad-health-check-model/) — Henrik Kniberg & Kristian Lindwall, 2014. Adapted for the Health Check meeting dimensions.
- **Agent OS framework** (Cased) — Conceptual inspiration cited in ai-behavior's IMPLEMENTATION_GUIDE.md (v0.1.0 era). Acknowledged here for historical accuracy.

---

*Waves™ Framework v2.4.0 — Created from the ai_logbook pattern on 2025-07-10. Formalized as ai-behavior on 2025-11-11. Renamed to Waves on 2026-03-13. Current version published 2026-05-14 by Exovian™ Developments.*
