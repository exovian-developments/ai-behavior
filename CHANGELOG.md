# Changelog

All notable changes to Waves are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## About this changelog

Waves did not begin as a framework. It began as a workaround. This changelog is intentionally complete — it documents the entire lineage from the original `ai_logbook` pattern (July 2025) through the formalization as `ai-behavior` (November 2025), the identity rebrand to Waves (March 2026), and the current 2.x line.

The history is presented in **four eras** for clarity:

1. **Waves Era** (2026-03-13 → present) — versions 1.2.0 onward, current framework identity
2. **Identity Rebrand** (2026-03-13) — the commit that renamed `ai-behavior` to Waves; zero breaking changes
3. **ai-behavior Era** (2025-11-11 → 2026-03-12) — versions 0.1.0 through 1.1.0; the framework formalized but under its original name
4. **Genesis Era** (2025-06-25 → 2025-11-10) — pre-framework; the first schemas (logbook, rules, manifest) designed in disk before any git versioning, later persisted in `givannia_desktop/ai_logbook/`
5. **Pre-history** (2024-11-29 → 2025-06-24) — the Exovian ecosystem (`networking_exovian`, `theme_exovian`, `permissions_exovian`) and the LLMs experimentation (`LLMs/RealState/whatsapp-poc`). The framework did not exist yet, but the need that would create it was being lived

Most recent versions appear first.

---

# Waves Era (2026-03-13 → present)

## [2.4.1] - 2026-05-14

### Corrected — Origin & Lineage with filesystem-verified dates

This is a documentation-only patch. No code changes, no schema changes, no behavior changes. Corrects the framework's documented origin to reflect filesystem birth times verified across multiple repositories.

- **FRAMEWORK.md §19 Origin & Lineage**: restructured to 6 sub-sections (was 5). New §19.1 "Pre-history" covers the Exovian ecosystem (2024-11-29) and LLMs experimentation (2025-04-11 → 2025-04-12, including the `whatsapp-poc` at `exovian_archived/Archived/LLMs/RealState/whatsapp-poc`). §19.2 "Genesis" now cites the actual first-schema date — **2025-06-25 16:02:31 UTC-6** — when `logbook_schema.json` was first written to disk, 15 days before the `git init` of `givannia_desktop` (2025-07-10).
- **CHANGELOG.md Genesis Era**: corrected date range to **2025-06-25 → 2025-11-10** (was 2025-07-10 → 2025-11-10). Added detailed pre-git phase showing the 15-day window when the three foundational schemas existed in disk before any git versioning. Added explicit table of filesystem birth times.
- **CHANGELOG.md Pre-history section**: new section documenting the Exovian ecosystem (`networking_exovian` 2024-11-29 12:29 UTC-6, `theme_exovian` 2024-11-29 12:49 UTC-6, `permissions_exovian` 2025-01-02), the LLMs directory creation (2025-04-11), and the `whatsapp-poc` prototype files (2025-04-12 17:09 → 17:12 UTC-6). The framework did not exist yet, but the verifiable record of the need that would create it does.

### Why this matters

The previous documentation cited 2025-07-10 as Day 1 — that is the `git init` date of `givannia_desktop`, not the date the first schema was written. The actual first artifact (`logbook_schema.json`) predates git versioning by 15 days. The corrected dates do not change anything about how the framework operates; they only make the public lineage truthful to what the filesystem and git can verify. Earlier internal thought certainly predated 2025-06-25, but the owner has stated no documented record survives, and this changelog does not invent dates it cannot cite.

---

## [2.4.0] - 2026-05-14

### Added — Documentation sync hook + complete framework lineage

This release closes a regression and formalizes the framework's complete history.

- **`FRAMEWORK.md` brought up to date with all 2.x shipped features.** From Waves 2.0.0 (2026-04-15) through 2.3.0, FRAMEWORK.md remained frozen at the 2.0 narrative while 17 releases shipped substantial defense layers, adversarial subagents, and the agentic project category. The document now reflects the actual 2.x line via expanded Sections 1.4 (cumulative narrative), 13 (9-hook inventory), and new Sections 14 (Defense Layers A+B+C+D), 15 (Adversarial Subagents), 16 (Project Types), 17 (Background Metacognition), 18 (Upgrade Discipline), and 19 (Origin & Lineage). Glossary expanded with 12 new terms.
- **`waves-doc-sync.sh` hook (`PreToolUse`, matcher `Bash`).** Triggers when `git tag vN.N.N` is executed. Blocks (exit 2) when the tagged commit does not modify BOTH `FRAMEWORK.md` and `CHANGELOG.md`. Single-use bypass via `.claude/waves-doc-sync-bypass` for documented exceptions; usage logged to `/tmp/waves-doc-sync-bypass.log`. Prevents the very regression this release closes.
- **`VERSIONING_PROCESS.md` Step 5: Doc-sync check** added between schema pre-flight (Step 4) and tag/commit (Step 6, renumbered from 5). The release procedure now explicitly enumerates the doc-sync requirement and the bypass mechanism.
- **Complete CHANGELOG lineage**. The changelog now displays the four eras of the framework with explicit headers: Waves Era (current), Identity Rebrand (commit `2cda84d`, 2026-03-13), ai-behavior Era (2025-11-11 → 2026-03-12), and Genesis Era (2025-07-10 → 2025-11-10 — the `ai_logbook` pattern in `givannia_desktop`, predecessor of `ai_files/`). The Agent OS framework (Cased) is acknowledged as conceptual heritage under v0.1.0.
- **Retroactive tags**. `v0.3.0` (commit `5bd6b7f`), `v1.1.1` (commit `4b914ab`) created. Existing tags `1.0.0` and `1.1.0` renormalized to `v1.0.0` and `v1.1.0` for consistency with all subsequent versions.
- **`WAVES_SITE_UPDATE_PROMPT.md`** at repo root: a self-contained handoff prompt for the `exovian_web_v1` agent to update the public Waves site to 2.4.0, including a new `changelog.html` (visible full lineage) and `agentic.html` (hub for the agentic category).

### Why this is the right shape of release

Bumped to 2.4.0 (minor) rather than 2.3.1 (patch) because the doc-sync hook is a new mechanism, not a fix. The hook is backward-compatible — existing projects do not need it; new releases that propagate it will enforce the discipline from that point forward. No artifact migrations are required.

### Backward compatibility

The hook itself is opt-in per repository (lives in `.claude/hooks/` and `settings.json` of the consuming project). Existing tags and existing CHANGELOG entries are unchanged. The renormalized tags `1.0.0` → `v1.0.0` and `1.1.0` → `v1.1.0` were removed from the remote and re-pushed under the new names; no Homebrew formula or consumer depends on the legacy tag names.

---

## [2.3.0] - 2026-05-14

### Added — Agentic project category

Waves now supports a third project category — `agentic` — alongside the existing `software` and `general`. An agentic project is one whose value is an orchestration of agents/subagents with skills, hooks, tools, and configurations — not traditional software, not academic/creative content. Examples: a corpus ingestion pipeline orchestrated by Claude Code + Claude Browser + Claude Desktop; a customer operations hub coordinating triage/drafter/escalation subagents; a compliance center monitoring regulatory feeds. The category was empirically ratified with 1 production pilot (`exobase_med_corpus`) + 2 projected cases (Customer Operations Hub, Compliance Operations Center) before the schema was frozen.

- **`schemas/agentic_manifest_schema.json` (new)** — 15 agnostic top-level sections (project, orchestration, roles, subagents, skills, tools, data_sources, state_contracts, handoff_contracts, pipelines, integration_contracts, triggers, governance, observability, source_access_modes) + 8 reusable `$defs` (role, tool, data_source, state_contract, handoff_contract, pipeline_stage, trigger, approval_gate). Roles are declared as a free array — **no fixed enum** — because the 3 cases declared 8, 5, and 6 different roles respectively. The schema models structural concepts that recur across agentic projects without imposing domain-specific values. `additionalProperties: false` at root forces consistency; sub-objects with operational metadata allow extensions.
- **`schemas/user_pref_schema.json`** — `project_context.project_type` enum extended from `["software", "general"]` to `["software", "general", "agentic"]`. Description and `$comment` enriched to explain when each category applies and which schemas/flows route from it. Backward compatible (existing projects with `project_type: "software"` or `"general"` continue to validate unchanged).
- **`/waves:manifest-create` FLOW C: AGENTIC PROJECTS** — Step 2 routing extended with `IF project_type === "agentic" → FLOW C`. Two sub-flows (C1 NEW, C2 EXISTING with disk scan that pre-populates from `skills/`, `.claude/hooks/`, `.claude/settings.json` MCP servers). 6 elicitation groups (project identity, orchestration architecture, roles+skills+tools, data flow, pipelines+triggers, governance+observability) cover all 15 schema sections with concrete prompts and real examples from the 3 cases. FLOW A and FLOW B left literally unchanged.
- **`/waves:blueprint-create` Step -0.5: Agentic Terminology Adaptation** — When `project_type === "agentic"`, the rest of the command applies a conceptual mapping (`essential_capabilities` → subagent_capabilities, `user_flows` → orchestration_patterns, `system_flows` → internal pipelines, `views` → interaction surfaces). **No schema change** — `product_blueprint_schema.json` is structurally agnostic and accepts the same fields with new semantic interpretation. Software/general flows untouched.
- **`/waves:rules-create` Flow C: Agentic Default Categories** — When `project_type === "agentic"`, proposes 7 default rule categories (orchestration, prompt_engineering, tool_use, governance, data_handling, integration, observability) with concrete example rules per category. Project can accept/edit/extend. `project_rules_schema.json` accepts any category name as free string — no schema change. Flow A (software) and Flow B (general) unchanged.
- **Core commands gated on `agentic`** — `/waves:objectives-implement`, `/waves:logbook-create`, `/waves:logbook-update` now accept `project_type === "agentic"`. They reuse `logbook_software_schema.json` because the structural model (objectives with scope.files + scope.rules) is identical — agentic logbooks point scope.files to skill markdown / hook JSON / prompt files instead of source code, but the rest is the same. The 4 defense layers (A inline rules in completion_guide + B rules-in-scope banner + C post-impl rules audit + D logbook integrity audit) and the orthogonality reviewer apply identically to agentic projects — they operate on diff vs rules, agnostic to file type.

### Why this is additive, not breaking

Every existing project with `project_type: "software"` or `"general"` continues to behave exactly as in 2.2.x. The only changes are: (a) one new value added to an enum, (b) one new schema file, (c) new branches in 5 commands. No flow path for software/general was modified semantically — only routing prerequisites in 3 commands were extended (`IF X` became `IF X OR agentic`). `git diff` on this release shows additions vastly outnumber modifications; the modifications themselves are routing extensions, never logic changes to existing flows.

### Empirical basis

Three cases analyzed before the schema was frozen:

1. **exobase_med_corpus** (real pilot): 8 roles, 4 state_contracts with by_specialty/by_subagent partitioning, 9-stage pipeline, integration with facts_core + conversational_engine_ba + llm_core, observability errors_and_outputs.
2. **Customer Operations Hub** (projected): 5 roles, hybrid subagent lifecycle (escalation-detector is persistent listener, others ephemeral), Zendesk/Slack/Notion/GitHub MCP tools, mixed binary + graduated approval gates.
3. **Compliance Operations Center** (projected): 6 roles, decisions_full observability with audit_critical_decisions (regulated domain), budget_controls + scope_boundaries enforced, by_jurisdiction partitioning.

All three fit the 15 sections without inventing top-level fields. The schema was sized minimally — if a fourth or fifth case emerges that needs structure outside these 15, we revisit. Until then, `agentic` is frozen at this surface.

### Migrated

- The pilot `exobase_med_corpus` had its manifest moved from `general` (with custom sections) to `agentic` at `ai_files/project_manifest.json` (validates against `agentic_manifest_schema.json`). Its `user_pref.project_context.project_type` updated to `"agentic"`.

---

## [2.2.1] - 2026-05-04

### Changed — `waves:logbook-update` is now the universal logbook entry point

Three coordinated changes turn `waves:logbook-update` into the single command for any operation on an existing logbook (modify, audit on demand, migrate from older schemas):

- **Two-argument contract**: `waves:logbook-update [filename] [instruction]`. Both optional. The first argument is the logbook filename (current behavior). The second argument is either a reserved token (`audit` skips operations and goes straight to integrity audit) or a free-form natural-language instruction interpreted by the agent (e.g. `"marca objetivo 3 completado"`, `"agrega objetivo primario sobre validación de inputs"`). Free-form instructions go through a mandatory **plan-before-execute** confirmation: the agent shows the interpreted operations and waits for `Yes/No/Adjust` before applying. This is the safety net against parsing optimism — the user always sees what the agent intends to do.
- **Soft schema migration on load (Step 0.5)**: when a logbook is loaded, the command checks for required fields missing in the JSON and adds them with their schema defaults. For 2.2.x the only field added is `audit: { is_already_audited: false }` for logbooks created before 2.2.0. The migration only adds, never modifies existing values, so user content is preserved verbatim.
- **STEP AUDIT is now unconditional** (with one explicit escape). Every `logbook-update` invocation ends with the integrity reviewer subagent running on the persisted logbook, regardless of which operations were performed. The previous "only audit on structural changes" heuristic missed the case of "audit a logbook without modifying it", which is exactly what the user needs after creating a logbook with the old version of the framework or after `project_rules.json` evolved. Step 3 now offers two terminal options: `5. None (just audit and exit)` and `6. Save and exit (skip audit)` — the latter is the rare escape hatch when the audit is genuinely unnecessary.

### Why this is an addition, not a refactor

The original 2.2.0 design proposed a separate command `/waves:logbook-audit` for audit-on-demand. This release retires that idea: `logbook-update` already exists, already loads logbooks, already validates against the schema. Extending it to cover audit-on-demand and soft schema migration avoids growing the command surface (still 17 slash commands) and concentrates the integrity workflow in one place.

The latency cost (~30-60s of subagent per `logbook-update` invocation) is paid once per call. `logbook-update` is not a hot-path command — it is invoked deliberately by the user when they want to act on a logbook, not as part of an inner loop. The trade is acceptable: every logbook that passes through `update` exits with verified integrity.

---

## [2.2.0] - 2026-05-04

### Added — Multi-focus decomposition + logbook integrity audit

Two complementary subagent-based mechanisms that close the rule-drift loop opened in 2.1.9. The diagnosis: rule violations in frontend code persist not because rules are missing, but because (a) work with multiple orthogonal dimensions saturates the main agent's attention and (b) the logbook itself is sometimes generated with empty `scope.rules` or completion_guides missing the inline rule references, so the implementer never sees the constraints in the first place. Both failures happen silently.

- **Orthogonality reviewer subagent** in `waves:logbook-create` Step A2.5. Before generating main objectives, an adversarial subagent (Opus by default, configurable via `agent_config.metacognition_model`) evaluates whether the ticket has 2+ orthogonal dimensions. The subagent is briefed to prefer multi_focus when in doubt — the main agent is biased toward single_focus because it is faster, and a fresh adversarial reviewer catches that bias. If multi_focus, Step A3 generates one main objective per dimension with distinctive non-overlapping content. The decision and full reasoning are persisted in `resolved_decisions` with `method: "orthogonality_review"`. No schema change — the decomposition is observable from the number of main objectives and their content; siblings are reconstructed at implementation time.
- **Sibling primaries banner** in `waves:objectives-implement`. When a logbook has 2+ main objectives, the implementer prints a banner showing which primary is current and which siblings are DONE / DEFERRED. Tells the LLM explicitly what NOT to attend in the current objective — as valuable as telling it what to attend.
- **Logbook integrity audit subagent** in `waves:logbook-create` Step A6 (post-persist) and `waves:logbook-update` (when objectives or scope.rules change). After the logbook is persisted, an adversarial subagent reads the artifact from disk and surfaces critical/warning findings: empty `scope.rules` on primaries that touch layers with rules, completion_guide missing the inline `Apply rule #N: ...` entries, rule_id references that don't exist, decomposition mismatch with the orthogonality_review decision, duplicate primary content, scope.files paths not found. Findings are textual suggestions only — the main agent applies fixes with full context. Output is persisted to `ai_files/waves/wN/audits/logbook-<basename>.json`.
- **Sibling context for the rules audit hook (Layer C)**. `waves-rules-audit.sh` now passes the list of sibling primaries to the auditor subagent so it audits scope-by-elimination. If primary 1 is "structure" and primary 3 is "behavior" (deferred), the auditor of primary 2 ("positioning") does not flag absence of structure or behavior — those are correct separation, not violations.

### Changed

- `logbook_software_schema.json` adds a required `audit` object at root: `is_already_audited` (boolean, defaults to `false`) and `audit_file` (optional string, populated after the integrity reviewer runs). New logbooks initialize the field at Save File; the integrity reviewer flips it to `true`. Logbooks created before 2.2.0 won't have the field — this is intentional and accepted: the framework does not retro-validate old logbooks, and any old logbook reopened via `logbook-update` will have the field added on first material edit.

### Why this targets where it hurts

Backend implementation typically has 1-3 design decisions per function with fast feedback loops (tests fail loudly). Frontend has 10+ decisions per widget across orthogonal dimensions (structure, positioning, behavior, a11y, i18n) where convention violations are syntactically valid and tests don't catch them. The orthogonality reviewer prevents one primary from absorbing all dimensions and saturating the implementer's attention; the integrity audit prevents the logbook from shipping with the omissions that make Layer A and B (rule inlining + banner) decorative instead of operative. With Layers A+B+C+D plus the orthogonality reviewer in place, the framework now has four independent defenses against rule drift, calibrated for where drift actually happens.

---

## [2.1.9] - 2026-05-04

### Added — Rules Enforcement (Layer A + B + C)

Three coordinated changes target a recurring problem: agents ignored project rules, especially in frontend code. Even with a strong rule set, drift was silent because (1) rules lived in a separate file the agent had to remember to consult, (2) the audit step in `objectives-implement` was self-audit with optimistic bias, and (3) frontend rule violations are convention-based and not caught by AST or tests.

- **A — Inline rule text in `completion_guide`** (`waves:logbook-create`). Step A4 now mandates that for every secondary objective, after the implementation steps, an entry per applicable rule is appended in the form `Apply rule #N: <full rule text from project_rules.json>`. Rule IDs alone forced the implementer to mentally jump to the rules file at every step — a context switch the agent silently skipped. Inline text makes the constraint physically present during implementation.
- **B — Rules-in-scope banner in `objectives-implement`**. Step 5 now opens with a mandatory banner that prints the full text of every rule in scope before any code is written. Sub-step 2 was rewritten from "read applicable project rules" to "treat every rule in the banner as a hard constraint." The banner ensures rules are present in the active context at the moment of writing, not in a separate file the agent has to remember to consult.
- **C — Background subagent audit, non-blocking** (`waves-rules-audit.sh` + `waves-rules-audit-injector.sh`). When a primary objective transitions to completed, a background subagent (Opus by default, configurable via `agent_config.metacognition_model`) audits the diff against the rules in scope and writes findings to `ai_files/waves/wN/audits/primary-N.json`. The injector hook surfaces violations at the agent's next Edit/Write via `additionalContext` (no gate exit 2 — auto-edits are not interrupted). The subagent classifies each violation by Waves trust contract level (1-5): levels 1-2 the main agent auto-fixes silently, levels 3+ surface to the user. If the agent edits a scope file after seeing violations, a re-audit is dispatched automatically. Iteration cap of 3 prevents loops; on cap, the audit escalates to the user with persistent-violation context.

### Changed

- `waves-perceive.sh` (SessionStart) now detects pending rules-audit findings and surfaces them so cross-session work doesn't lose context.
- `.claude/settings.json` registers both new PostToolUse hooks.

### Why this targets frontend specifically

Backend code drifts less because (a) tests fail loudly when contracts break, (b) rules typically align with the LLM's training defaults (clean architecture, freezed, Result types), and (c) decisions per line of code are sparse. Frontend (Flutter/React) has 10+ design decisions per widget, conventions vary by project, and convention violations (hardcoded colors, missing theme tokens, lifecycle misuse) are sintactically valid — neither AST nor tests catch them. Layer A puts the rules in the objective; Layer B puts them in front of the implementer; Layer C verifies mechanically with an independent reviewer. Defense in depth, calibrated for where the drift actually happens.

---

## [2.1.8] - 2026-04-21

### Fixed

- **`logbook_software_schema.json` was malformed** — the `recommendations` property added in an earlier commit left `properties` closed before the new field and a stray `},` after it, corrupting the root object. `jq` refused to parse the schema and any tooling validating logbooks against it would have failed. Moved `recommendations` inside `properties` where it semantically belongs and removed the extra closing brace. Schema now parses cleanly.

---

## [2.1.7] - 2026-04-21

### Fixed

- **`waves upgrade` no longer writes `.claude/waves-version` prematurely** — previously, the terminal command bumped the version marker before `/waves:upgrade` had a chance to run migrations. Projects upgrading from older versions (e.g. pre-2.1.2 → 2.1.6) would then see the marker already at the target version and skip all migrations (2.0.0 CLAUDE.md protocol, 2.1.0 metacognition_model question, 2.1.4 rule scope patch, 2.1.5 blueprint recent_context patch). The slash command `/waves:upgrade` now owns the marker exclusively — written only after all migrations complete.
- **`/waves:upgrade` target version is now auto-synced with the binary** — previously, `current_version` was hardcoded in the slash command markdown, requiring a manual bump on every release (and forgotten for 2.1.6, causing a false "already up to date" message). The slash command now uses a `{{CURRENT_VERSION}}` placeholder that `bin/waves` substitutes from its own `VERSION` at copy time, in both `waves init` and `waves upgrade`.

### Remediation

Projects whose `.claude/waves-version` was prematurely bumped to `2.1.6` (skipping migrations) can be remediated by deleting or downgrading the marker file, then running `/waves:upgrade` in Claude Code. The migrations are idempotent — already-applied patches are detected and skipped.

---

## [2.1.6] - 2026-04-21

### Changed

- **`/waves:upgrade` is now incremental and version-aware** — reads `.claude/waves-version` and executes only the migrations needed to go from the local version to the current version. Each migration has its own narrative (shown only when relevant), configuration questions (asked only if settings are missing), and artifact patches (applied only if fields are missing). Old projects (pre-2.1.2, no version file) get all migrations. Projects already up to date get "Already up to date." The Agent Operating Protocol in CLAUDE.md now includes rule scope governance and cross-vertical serendipity detection in metacognition.

---

## [2.1.5] - 2026-04-21

### Added

- **Product-level `recent_context` and `history_summary`** in `product_blueprint_schema.json` — rolling narrative of the product's evolution. Captures strategic events: capability changes, market discoveries, architectural pivots, metacognition findings. Compacts to history_summary when > 20 entries. Entries are 1600 chars max (longer than logbook's 1200) for richer product-level narrative. Summaries are 280 chars. Both arrays default to empty for backward compatibility.

---

## [2.1.4] - 2026-04-18

### Added

- **Rule scope field** (`scope`) in `project_rules_schema.json` — required field with values `"ecosystem"` (identical across all projects in the organization, not modifiable locally) or `"local"` (project-specific, agent can modify). Enables consistent governance across multi-project organizations while keeping project-specific rules isolated.
- **Scope protection in rules-update** — ecosystem rules cannot be modified, deleted, or rephrased from individual projects. The command flags attempts and requires explicit user override.
- **Scope assignment in rules-create** — new rules require scope classification. Ecosystem rules are listed first within each section, followed by local rules.

---

## [2.1.3] - 2026-04-18

### Fixed

- **Circular metacognition re-trigger** — writing "delegated" to a logbook would trigger the metacognition hook again, which detected a stale count mismatch (from absolute vs relative path hashing) and re-created the pending marker, causing an infinite block loop. Fixed with: (1) path normalization before hashing, (2) 60-second cooldown after gate clears a marker — during cooldown, metacognition skips without re-triggering.

---

## [2.1.2] - 2026-04-18

### Added

- **Local project version tracking** — `waves init` and `waves upgrade` now write `.claude/waves-version` with the installed version. On subsequent upgrades, the command shows the version transition: "Updating current project... (v2.0.4 → v2.1.2)". Projects without the marker show "(pre-2.1.2 → v2.1.2)".

---

## [2.1.1] - 2026-04-16

### Fixed

- **Gate clears marker on first ai_files/ write** — previously the marker required a logbook edit to clear, which failed when no logbook was active. Now ANY write to ai_files/ (roadmap, blueprint, logbook) clears the marker, so the agent can continue working immediately after delegating the subagent.
- **No logbook required for metacognition flow** — all three metacognition hooks now say "write to any ai_files/ artifact" instead of "update the logbook." Works in sessions without an active logbook (e.g., blueprint refinement).

---

## [2.1.0] - 2026-04-16

### Added

- **Background metacognition via subagents** — all three metacognition triggers (objective completed, blueprint changed, phase completed) now delegate analysis to a background subagent. The main thread pauses ~5 seconds (spawn + logbook note), then continues. The subagent analyzes in parallel and only interrupts if it finds critical findings (Level 4+).
- **Mechanical roadmap progress** — when a primary objective completes, the hook writes an [AUTO] progress note directly to the roadmap's decisions array with objective completion state (e.g., "main 1/2, secondary 3/5"). Ensures the roadmap always reflects reality even when logbooks are abandoned.
- **objectives-implement roadmap update** — the command now mandates updating the roadmap with a session progress entry before showing the final summary. Captures what was accomplished even when sessions end early.
- **Metacognition marker auto-expire** — pending markers expire after 5 minutes to prevent stuck states. `rm /tmp/waves-*` is also whitelisted in the gate.
- **Expert advisor subagent prompts** — all three metacognition subagents now receive full business context (blueprint + ALL roadmaps + ALL logbooks as readable paths) and analyze for blockers (missing prerequisites, info gaps), design improvements (undiscovered dependencies, misalignments), and effort savings (services, reordering, descoping).

### Changed

- **Debounce for cascading updates** — metacognition messages now tell the agent to finish all artifact updates (roadmap, logbooks) BEFORE delegating the subagent. ai_files/ writes are whitelisted during the pending state, so the agent updates the roadmap with fresh data before the subagent reads it.
- **Subagent model** — metacognition subagents use Sonnet for cost efficiency (analysis, not code generation).

---

## [2.0.9] - 2026-04-16

### Fixed

- **Gate now handles multiline Bash commands** — heredoc-style git commits (`git commit -m "$(cat <<'EOF'..."`) were blocked because the command parser read all lines instead of just the first. Now only the first line is parsed for the command prefix.

---

## [2.0.8] - 2026-04-15

### Fixed

- **SessionStart hook error resolved** — prompt-type hooks are not supported in SessionStart events (Claude Code limitation: "ToolUseContext is required for prompt hooks"). Removed the prompt hook and moved mandatory artifact reading instructions into the perceive script output. The agent now receives reading instructions via the same system-reminder as the state summary.

---

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

## Versions 1.1.1 → 1.3.4 (2026-03-11 → 2026-03-19)

Patch and tooling iterations during the rebrand period. The rebrand to Waves landed in v1.1.1; subsequent patches (1.2.0, 1.3.1 → 1.3.4) focused on Homebrew formula fixes, CLI banner restyling, and incremental schema tightening. Git tags exist for these versions but the CHANGELOG was not updated per-patch; see `git log v1.1.1..v1.3.4` for commit-level granularity. The hook added in 2.3.x (see Section 18.6 of FRAMEWORK.md) prevents this pattern from recurring.

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

---

# Identity Rebrand: ai-behavior → Waves

**Commit:** [`2cda84d`](https://github.com/exovian-developments/waves/commit/2cda84d) (2026-03-13, 10:22 UTC-6)
**Files changed:** 102

On March 13, 2026, the framework was rebranded from **ai-behavior** to **Waves**. The commit message:

> rebrand: rename ai-behavior to Waves
>
> Identity change reflecting AI-era product development philosophy:
> - All file references: ai-behavior → waves
> - CLI binary: bin/ai-behavior → bin/waves
> - Command prefix: /ai-behavior:* → /waves:*
> - Homebrew Formula: AiBehavior → Waves
> - Plugin skill: ai-behavior-protocol → waves-protocol
> - product_blueprint.json: Added philosophy section explaining
>   why wave-based delivery cycles replace fixed-cadence sprints
>   in AI-assisted development

**The change was identity-only — zero breaking changes for users.** Filesystem layout, schema structure, command behavior, artifact relationships: all unchanged. The name "Waves" was already the term used internally for delivery cycles since v0.1.0 — the rebrand promoted it from concept to identity.

The philosophy: *wave-based delivery cycles replace fixed-cadence sprints in AI-assisted development*. AI agents compress what used to take 6 months into days. Sprints designed for human coordination overhead lose their purpose when agents execute, track, and report through structured artifacts. Waves adapts the process to that reality.

---

# ai-behavior Era (2025-11-11 → 2026-03-12)

The framework existed under the name **ai-behavior** for 4 months before the rebrand. All artifacts, philosophy, and command structure of current Waves were established in this era — the rebrand changed identity, not substance.

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

### Conceptual heritage acknowledgement

The IMPLEMENTATION_GUIDE.md of this v0.1.0 era credited early conceptual inspiration to the **Agent OS framework** (Cased). That heritage is acknowledged here for historical accuracy. The current Waves implementation does not depend on Agent OS code or artifacts, but the framing "AI agent as team member" was part of the conversation that made the design thinkable at the time. The reference was dropped from the codebase during the rebrand.

---

# Genesis Era (2025-06-25 → 2025-11-10)

The framework as a structural artifact begins on **2025-06-25 at 16:02:31 UTC-6** — when the file `logbook_schema.json` was created in disk. There was no git versioning yet; the file existed alone on the filesystem, in a directory that would later become `givannia_desktop/ai_logbook/`. The filesystem (macOS APFS) preserved the birth time, which is the dated record we use.

For 15 days, the three foundational schemas were designed by hand without git. Then on 2025-07-10 the schemas were placed inside a new Flutter desktop project (`givannia_desktop`) and that project received its first `git init`. The schemas became the `ai_logbook/` directory of that project, and the pattern saw production use as the embedded WhatsApp business agent matured.

## Genesis - 2025-06-25 → 2025-07-09 (pre-git phase)

| File | Birth time (filesystem) |
|------|------------------------|
| `logbook_schema.json` | **2025-06-25 16:02:31** — **Day 1** of the framework |
| `project_rules_schema.json` | 2025-06-26 10:41:46 |
| `project_manifest_schema.json` | 2025-07-01 11:10:49 |

**The three schemas existed in disk for 15 days before any git history.** Designed by hand, validated mentally against the WhatsApp agent use case that was running in `LLMs/RealState/whatsapp-poc` since 2025-04-12 (see Pre-history below).

## Genesis - 2025-07-10 (first git commit)

On 2025-07-10:
- 09:27:16 — `git init` of `givannia_desktop`
- 09:29:07 — Commit `afb1bd6` "Initial commit" (Flutter scaffolding, Node.js + Baileys assets)
- 09:54:41 — Commit `af1c2a1` "Adding pending changes" (the `ai_logbook/` directory with the three schemas)

`givannia_desktop` has only 2 commits total in its git history, both on 2025-07-10. After that, the pattern emigrated to other workflows (no longer versioned in `givannia_desktop`).

## The three foundational schemas (still alive in Waves today)

- **`logbook_schema.json`** — Dynamic bitácora with:
  - `recent_context` — sliding window of 15 entries (the compaction algorithm Waves uses today)
  - `history_summary` — compacted older entries (still the algorithm today)
  - `objectives_present` / `objectives_past` (precursor of main/secondary objectives)
  - `future_reminders` (still present in Waves today)
  - `mood` (emotional state — useful for the WhatsApp use case, dropped during formalization)
- **`project_manifest_schema.json`** — Tech stack, modular structure, layered architecture descriptors
- **`project_rules_schema.json`** — Rules grouped by category (architecture, testing, naming, presentation_layer, data_layer, api_layer, infra). The 7 categories are still the defaults in current `project_rules_schema.json` for software projects.

**This was not a framework.** It was a working pattern, validated daily in production for 4 months (July 2025 → November 2025) before being formalized as `ai-behavior`.

### What this era contributed to current Waves

- The compaction algorithm in `recent_context` is unchanged from the day it was written (2025-06-25)
- The schema-validated JSON shape (description + $comment pattern) is the convention to this day
- The rule categories are the defaults for software projects
- The `future_reminders` concept survives in current logbook schemas
- The philosophy of structured-JSON-as-shared-memory is the load-bearing idea of Waves

### What did not survive

- The `mood` field (emotional calibration of the agent — useful for the WhatsApp use case, abandoned during generalization)
- The directory name `ai_logbook/` — replaced by `ai_files/` when the pattern was generalized in `ai-behavior` v0.1.0
- The coupling to a single application (the WhatsApp agent) — generalized to "any project"

---

# Pre-history (2024-11-29 → 2025-06-24)

The framework did not start the moment its first schema was written. It started in a need that was being lived, and that need had a context. This section documents the verifiable record before Waves' Day 1.

## Pre-history - 2024-11-29: Exovian ecosystem begins

The owner began the **Exovian** Flutter ecosystem in late November 2024 — seven months before the first schema of what would become Waves was written.

| Date | Repository | First commit |
|------|------------|--------------|
| **2024-11-29 12:29:02 UTC-6** | `networking_exovian` | `b3eadfa` "Create project" |
| 2024-11-29 12:49:10 UTC-6 | `theme_exovian` | `3370ea8` "Create project" |
| 2025-01-02 11:19:18 UTC-6 | `permissions_exovian/` | filesystem birth (git init follows) |

These packages are infrastructure libraries for Flutter applications. They are **not Waves**. They are the substrate on top of which the owner was working when the need for structured AI agent context emerged.

## Pre-history - 2025-04-11 → 2025-04-12: LLMs experimentation, the WhatsApp PoC

The pivot toward LLM agents has a dated entry point:

| Date | Event |
|------|-------|
| **2025-04-11 09:44:52 UTC-6** | Directory `LLMs/` created in `exovian_archived/Archived/` (no git versioning) |
| **2025-04-12 17:09:23 UTC-6** | `LLMs/RealState/whatsapp-poc/package.json` — first file of the first WhatsApp proof of concept |
| 2025-04-12 17:10:11 UTC-6 | `LLMs/RealState/whatsapp-poc/package-lock.json` |
| 2025-04-12 17:12:47 UTC-6 | `LLMs/RealState/whatsapp-poc/index.js` |

**`LLMs/RealState/whatsapp-poc` is where the need to preserve context between AI tools (Claude Code → Codex → Gemini CLI) was felt empirically.** The agent migrated across LLMs as token budgets ran out, and lost context every time. There is no git versioning for this prototype — only filesystem birth times mark the record.

Earlier prototypes may have existed in the owner's workflow before `whatsapp-poc` (the owner has stated as much), but they are not documented in a way that can be reconstructed from disk. Their existence is real but unverifiable, and this changelog does not invent dates it cannot cite.

The two months between the `whatsapp-poc` (2025-04-12) and the first schema (2025-06-25) were the gestation period: the problem was being lived; the solution was being intuited; the artifact was about to be written.

---

*This changelog documents the complete verifiable lineage of Waves: from the Exovian ecosystem packages (2024-11-29) through the LLMs experimentation (2025-04-11) to the first schema of the framework proper (2025-06-25), the formalization as `ai-behavior` (2025-11-11), the rebrand to Waves (2026-03-13), and the current 2.x line. The framework exists because a working pattern was used long enough to deserve formalization, and the dates above are the record the filesystem and git can verify. Earlier internal thought is real but not documented here, in keeping with the discipline of citing only what can be cited.*
