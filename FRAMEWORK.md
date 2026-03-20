# Waves™ Framework

**Version:** 1.3.0
**Last updated:** 2026-03-20
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

---

## 11. Principles

1. **Organic over ceremonial.** Meetings happen when they're needed, not when the calendar says.
2. **Data over opinion.** Feasibility uses Monte Carlo simulations, not gut feelings. Decisions are recorded with reasons.
3. **Traceability over documentation.** Every piece of work traces to the blueprint. The structure enforces coherence without bureaucracy.
4. **AI as team member.** Agents are not tools — they have defined responsibilities within each role.
5. **Variable over fixed.** A wave lasts as long as it needs. No artificial boundaries, no wasted ceremony.
6. **Celebration over forensics.** Wave closures recognize achievement first, then note improvements constructively.
7. **Blueprint as living document.** The product evolves through controlled change, not frozen specs or uncontrolled drift.

---

## 12. Glossary

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

---

## References

- [Spotify Squad Health Check Model](https://engineering.atspotify.com/2014/09/squad-health-check-model/) — Henrik Kniberg & Kristian Lindwall, 2014. Adapted for the Health Check meeting dimensions.

---

*Waves™ Framework v1.3.0 — Created 2026-03-16, updated 2026-03-20 by Exovian™ Developments*
