# Prompt for the exovian_web_v1 agent — Waves 2.3.0 site update

Copy this entire prompt to the agent working on `/Users/avm/Repositories/exovian/exovian_web_v1`. It is self-contained: the agent does not need to ask Otto (Waves) any questions — all the content it needs is referenced here.

---

## Mission

Update the public Waves documentation site (`public/waves/` — 8 HTML pages) to reflect everything shipped between Waves 2.0.0 and 2.3.0. The site has been frozen at 2.0 narrative while the framework shipped 17 releases including a fundamental new project category (`agentic`) and four defense layers against rule drift. Also add a visible, complete CHANGELOG so the framework's full lineage (genesis → ai-behavior → Waves) is transparent.

## Authoritative sources you MUST read first

These two files in `/Users/avm/Repositories/exovian/waves/` are the source of truth. Derive site content from them — do not invent.

1. **`FRAMEWORK.md`** — Waves 2.3.0 reference document. ~1200 lines. The site agent reads this and translates it into HTML. Pay especially close attention to:
   - **Section 1.4** — "What changed across the 2.x line" — cumulative narrative 2.0 → 2.3
   - **Section 13** — Hooks Architecture (9 hooks, not the 7 from 2.0)
   - **Section 14** — Defense Layers (A + B + C + D) — NEW SECTION
   - **Section 15** — Adversarial Subagents — NEW SECTION
   - **Section 16** — Project Types (software, general, **agentic**) — NEW SECTION
   - **Section 17** — Background Metacognition (cooldown, throttling, cross-vertical serendipity) — NEW SECTION
   - **Section 18** — Upgrade Discipline (incremental migrations, doc-sync hook) — NEW SECTION
   - **Section 19** — Origin & Lineage (genesis → ai-behavior → Waves) — NEW SECTION
   - **Section 20** — Updated Glossary (~12 new terms)

2. **`CHANGELOG.md`** — Complete release log from v0.1.0 (2026-02-13) through v2.3.0 (2026-05-14), with explicit headers for the four eras (Waves / Identity Rebrand / ai-behavior / Genesis). The site agent reads this and creates a publicly visible changelog page.

3. **Read also (context)**: `VERSIONING_PROCESS.md` (release procedure including the new doc-sync hook), `README.md`, `bin/waves` (CLI behavior — `--version` should output `2.3.0`).

## What to deliver

### A — Minimal recognition updates to existing 8 pages

Pages: `public/waves/{index, start, concepts, commands, patterns, learn, compare, team}.html`

For each, find places where the page talks about project types (most mention only "software" or "academic/creative/business") and update to acknowledge the three categories. Specifically:

1. **`index.html`** — In the "Not just for software" block: add **"agentic"** as the third category with one-sentence description + a concrete example (pipeline orchestrated by Claude Code + Claude Browser + Claude Desktop). Update any visible version mention from 2.0 to 2.3.0.

2. **`start.html`** — Add a note in the daily workflow about how `/waves:objectives-implement` operates for agentic projects (objectives are "implement subagent X" or "configure hook Y"; scope.files points to skill markdown / hook JSON; same Layer A+B+C+D apply).

3. **`concepts.html`** — Add a "Project Types" sub-section listing the three categories with 2-3 lines each. Reference FRAMEWORK.md Section 16.

4. **`commands.html`** — Update descriptions of `/waves:manifest-create`, `/waves:blueprint-create`, `/waves:rules-create` to mention agentic flow. Add `/waves:upgrade` if not present. List the 7 default agentic rule categories (orchestration, prompt_engineering, tool_use, governance, data_handling, integration, observability) inside the `rules-create` row.

5. **`patterns.html`** — Add a link/teaser to "Pattern 4: Agentic Orchestration" → the hub page (see C below).

6. **`learn.html`** — Add agentic-flavored examples to the 4 pillars (what "enforcement" means when the "code" is skills .md + hooks).

7. **`compare.html`** — Add a subsection in "vs AI Frameworks" comparing Waves agentic vs LangChain / CrewAI / AutoGen (highlights: role-based `tools_authorized`/`tools_forbidden`, subagent lifecycle ephemeral/persistent/hybrid, state contract partitioning, approval gates with free-form `auto_approve_when` conditions, stuck_threshold_seconds per pipeline stage).

8. **`team.html`** — Note that in agentic projects the three roles (PO / Coordinator / Technical Manager) operate slightly differently: PO validates orchestration_patterns and state_contracts; Coordinator tracks stuck subagents; Technical Manager translates business capabilities into subagent_capabilities, prompts, and orchestration rules.

### B — New page: visible CHANGELOG

Create `public/waves/changelog.html` (or equivalent path) rendering the full content of `CHANGELOG.md` from the authoritative source. The page should:

- Display the four eras as distinct visual sections with their own headers and short narratives:
  - **Waves Era (2026-03-13 → present)** — 2.x and 1.2+ versions
  - **Identity Rebrand** — the 2cda84d commit with full quote and explanation
  - **ai-behavior Era (2025-11-11 → 2026-03-12)** — 0.x and 1.0/1.1 versions
  - **Genesis Era (2025-07-10 → 2025-11-10)** — `ai_logbook` pattern in `givannia_desktop`
- Link version headers to GitHub release tags where possible (e.g., `https://github.com/exovian-developments/waves/releases/tag/v2.3.0`)
- Cite the Agent OS framework (Cased) acknowledgement under v0.1.0 — see the "Conceptual heritage acknowledgement" block in `CHANGELOG.md`
- Be discoverable from `index.html` and from the nav of all other pages

The Genesis era's `ai_logbook` history is **publishable** — Andrius authorized it. Frame it honestly: the framework emerged from a working pattern in a WhatsApp business agent project (`givannia_desktop`), generalized 4 months later as `ai-behavior`, then renamed to Waves. This is an asset, not a liability.

### C — New page: agentic hub

Create `public/waves/agentic.html` as the dedicated entry for the new project category. Structure (derive content from FRAMEWORK.md Section 16):

1. **Hero** — what is an agentic project, when NOT to use it
2. **Anatomy diagram** — orchestration model: primary agent → roles (with tools_authorized) → subagents → state contracts → handoff contracts. Visual.
3. **Decision matrix** — when to choose agentic vs software vs general
4. **Tutorial walkthrough** — end-to-end using a generic "corpus ingestion pipeline" example (do NOT name `exobase_med_corpus` specifically — abstract it). Show `/waves:project-init` with `project_type=agentic`, `/waves:manifest-create` FLOW C with the 6 elicitation groups, `/waves:blueprint-create` mapping (capabilities → subagent_capabilities), `/waves:rules-create` with the 7 default categories.
5. **Pattern 4: Agentic Orchestration** — in the style of `patterns.html`, describe the timeline + distinctive characteristics + 3 case archetypes (without naming the real pilot):
   - Corpus/data ingestion pipelines (many parallel extractors, state partitioning by domain)
   - Customer/business operations hubs (mixed lifecycle: persistent listeners + ephemeral workers; mixed approval gates)
   - Monitoring/compliance centers (decisions_full observability; governance + budget controls heavy; agent_cascade triggers)
6. **Key concepts** — single-writer-per-file, partitioning (`by_subagent`, `by_specialty`, etc.), subagent lifecycle (ephemeral / persistent / hybrid), approval gates with `auto_approve_when`, stuck_threshold_seconds per pipeline stage, agentic rules categories.
7. **Schema overview** — reference FRAMEWORK.md Section 16.1 for the 15 sections. Optionally link to a future `agentic-schema.html` reference page (do NOT build it in this pass — it's planned for a later release).

### D — Recognition of the doc-sync hook (added in this release)

In a small "What's New" or "About" section, mention that release tag commits are now mechanically required to update FRAMEWORK.md and CHANGELOG.md together (via `waves-doc-sync.sh` hook). This is the mechanism that prevents the site from going stale again. Reference FRAMEWORK.md Section 18.6.

## Constraints

- **Do NOT invent**. If FRAMEWORK.md or CHANGELOG.md doesn't say something, do not put it on the site.
- **Do NOT name `exobase_med_corpus`** publicly. The pilot is real but the public framing is "corpus ingestion pipeline" abstracted.
- **Software and general project flows are unchanged**. The site should reflect that agentic is additive — existing pages about software workflows do not need rewriting, only additions.
- **Preserve the site's existing tone and visual style**. The 8 pages have a coherent voice; new content should match.
- **Cite the GitHub commit `2cda84d`** when explaining the rebrand. The commit message is verbatim in CHANGELOG.md.
- **Version**: every page that mentions a Waves version should now say `2.3.0`, not `2.0.0`.

## Out of scope for this update

- Schema reference page (`agentic-schema.html`) — planned for a later release.
- LinkedIn post / external marketing — not your concern; Andrius handles that.
- Translation to other languages — site is currently English-only; that's fine.

## Definition of done

- All 8 existing pages updated with agentic recognition
- New `changelog.html` page deployed with the 4 eras visible and linked from the nav
- New `agentic.html` page deployed with hub structure + Pattern 4 + key concepts
- Every page's version reference says 2.3.0
- `2.3.0`'s "Waves doc-sync hook" mentioned in a "What's New" block (any page)
- Nav menu of all pages includes links to the new pages
- A short copy-edit pass to ensure the new content's voice matches the existing site
- Update CLAUDE.md inside `exovian_web_v1` to note that the site was synced to Waves 2.3.0 on this date and references FRAMEWORK.md as the source of truth for future updates

## Estimated effort

- A (minimal recognition on 8 pages): 2-4 hours
- B (CHANGELOG page with 4 eras): 4-6 hours
- C (agentic hub page with Pattern 4): 8-12 hours
- D (small "What's New" block): 1 hour

Total: 15-23 hours, deliverable in 2-3 focused sessions.

---

**Authority of this prompt**: this is the official handoff from Otto (the Waves framework maintainer) to the exovian_web_v1 agent. If anything in `FRAMEWORK.md` or `CHANGELOG.md` is ambiguous, treat those files as authoritative and surface ambiguities to Andrius; do not improvise.
