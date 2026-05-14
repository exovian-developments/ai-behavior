---
description: Extract coding rules/standards from the project codebase (software) or guide the user through defining standards (general projects).
---

# Command: /waves:rules-create

You are executing the waves rules creation command. Follow these instructions exactly.

## Your Role

You are the main orchestrator for project rules/standards creation. For software projects, you analyze existing code to extract patterns and conventions. For general projects, you guide the user through defining standards.

## Step -1: Prerequisites Check (CRITICAL)

1. Check if `ai_files/user_pref.json` exists.
   - IF NOT EXISTS → Display: "⚠️ Missing configuration! Run /waves:project-init first." → EXIT COMMAND

2. Read `ai_files/user_pref.json`:
   - Extract `user_profile.preferred_language` → Use for all interactions
   - Extract `project_context.project_type` → Determines main flow

3. IF `project_type === "software"` OR `project_type === "agentic"`:
   - Check `ai_files/project_manifest.json` exists
   - IF NOT EXISTS → Display: "⚠️ Run /waves:manifest-create first." → EXIT COMMAND

4. Check if rules file already exists:
   - Software / Agentic → `ai_files/project_rules.json`
   - General → `ai_files/project_standards.json`
   - IF EXISTS → Ask: "Rules already exist. Overwrite / Merge / Cancel?"

**From this point, conduct ALL interactions in the user's preferred language.**

## Step 0: Command Explanation

Display in user's language:
```
📘 Command: /waves:rules-create

[If software]:
I'll analyze the existing code to identify patterns,
conventions, and also detect potential antipatterns.

[If general]:
I'll guide you to define the standards you need
for your project.

Continue? (Yes/No)
```

IF No → Exit.

## Step 1: Fork by Project Type

- IF `project_type === "software"` → Go to **Flow A**
- IF `project_type === "general"` → Go to **Flow B**
- IF `project_type === "agentic"` → Go to **Flow C**

---

## Flow A: Software — Layer-Based Analysis

### Step A1: Read Project Manifest

1. Read `ai_files/project_manifest.json`
2. Extract: `primary_language`, `framework`, `architecture_patterns_by_layer`, `modules`, `features`
3. Show project context summary and ask which layer to analyze:

```
📊 Project context (from manifest):

Language: [language]
Framework: [framework]
Type: [frontend/backend/fullstack]

Detected layers:
[List layers from manifest]

Which layer to analyze?

1. architecture
2. presentation_layer
3. data_layer
4. api_layer
5. naming_conventions
6. testing
7. infra
8. All layers (full analysis)

Choose 1-8:
```

### Step A2: Invoke Analysis Subagents (in parallel)

For each selected layer, invoke these 3 subagents IN PARALLEL:

**Subagent 1: pattern-extractor** (read from `subagents/22-pattern-extractor.md`)
- Analyzes code in the layer for consistent patterns (3+ occurrences)
- Returns: List of detected patterns

**Subagent 2: convention-detector** (read from `subagents/23-convention-detector.md`)
- Analyzes naming and structural conventions
- Returns: Conventions with consistency percentages

**Subagent 3: antipattern-detector** (read from `subagents/24-antipattern-detector.md`)
- Analyzes code for known antipatterns (educational, constructive tone)
- Returns: Antipatterns with explanations and suggestions

Display progress:
```
🔍 Analyzing layer: [layer]

[✅] Pattern Extractor — [count] patterns identified
[✅] Convention Detector — [count] conventions detected
[⏳] Antipattern Detector — Analyzing...
```

### Step A3: Validate Against Criteria

Use the **criteria-validator** subagent (read from `subagents/25-criteria-validator.md`).

Each pattern/convention must meet ALL criteria from the schema:
- Promotes project-wide consistency
- Improves maintainability
- No contradictions with other rules
- Establishes implementation patterns (not tool config)
- Context-independent
- YAGNI compliant

### Step A4: Present Findings

Display in user's language:
```
📋 Analysis completed for: [layer]

═══════════════════════════════════════
✅ PATTERNS IDENTIFIED ([count] proposed rules)
═══════════════════════════════════════

[For each rule: section, description (max 280 chars)]

═══════════════════════════════════════
⚠️ ANTIPATTERNS DETECTED (Educational)
═══════════════════════════════════════

[For each antipattern: severity, location, problem, suggestion]

Options:
1. Save all proposed rules
2. Review and select individually
3. Analyze another layer
4. See more antipattern details
```

### Step A5: Generate Rules File

Read `ai_files/schemas/project_rules_schema.json` for structure reference.

Generate `ai_files/project_rules.json` with:
- Project info from manifest
- Validated rules organized by section
- IDs starting at 1, incrementing
- `created_at` timestamps in UTC ISO 8601
- Descriptions max 280 characters
- `scope` for each rule: "ecosystem" if the rule applies across all projects in the organization (shared conventions, architecture patterns, naming), "local" if it only applies to this project. Ask the user when uncertain. Within each section, list ecosystem rules first, then local.

Validate the generated file against the schema.

### Step A6: Success Message

```
✅ Project rules created!

📁 File: ai_files/project_rules.json
📊 Rules generated: [count]

By section:
[List sections with rule counts]

⚠️ Antipatterns identified: [count]
(Review the report to improve code quality)

🎯 Next steps:

To analyze more layers:
/waves:rules-create [layer]

To update rules after code changes:
/waves:rules-update

To start working:
/waves:logbook-create
```

---

## Flow B: General Projects — User-Guided Standards

### Step B1: Show Suggestions

Based on manifest type, show relevant standard suggestions:
- Academic: citation format, document structure, tables/figures, file naming
- Creative: file specs, color palette, typography, asset naming
- Business: processes, communication, KPIs, templates
- General: file organization, naming, workflows, documentation

Frame as "ideas" not requirements.

### Step B2: Open Question

```
📝 What standards or rules do you want to define for your project?

Describe freely what you need. I can help you structure it afterwards.

[Show example response relevant to project type]
```

### Step B3: Structure User Input

Use the **standards-structurer** subagent (read from `subagents/26-standards-structurer.md`).

Parse free-form input into structured categories. Show the structured result for confirmation.

If user wants changes → iterate.

### Step B4: Generate Standards File

Generate `ai_files/project_standards.json` with structured standards.

### Step B5: Success Message

```
✅ Project standards created!

📁 File: ai_files/project_standards.json
📊 Categories defined: [count]

[List categories]

🎯 Next step:

To update standards later:
/waves:rules-update

To start working:
/waves:logbook-create
```

---

## Flow C: Agentic — Default Categories + User Refinement

Agentic projects rarely have a code corpus to scan for patterns (the "code" is markdown skills, JSON hook configs, and prompt files). Instead, this flow proposes a set of agentic-relevant rule categories as defaults and lets the user accept, edit, or extend them. The output schema is the same `project_rules_schema.json` — only the suggested categories and example rules differ from Flow A.

### Step C1: Show Default Agentic Categories

Display in user's language:
```
📘 I'll propose default rule categories tuned for agentic projects.
The schema accepts any category name — you can accept these, remove
the ones that don't apply, or add your own.

Default agentic categories:
  1. orchestration       — How the primary agent dispatches and coordinates subagents (single-writer, async file-based, no inter-subagent direct calls without orchestrator)
  2. prompt_engineering  — Standards for subagent prompts (adversarial framing, structural citation required, no auto-confirmation, output JSON schema declared)
  3. tool_use            — Tool authorization boundaries (read-only roles forbidden from write tools, credentials never logged, rate limits respected)
  4. governance          — Approval gates and scope boundaries (which actions require human, escape hatch audit, budget controls enforced)
  5. data_handling       — How data flows between roles (handoff contracts validated, schema_ref on every state contract, no role writes outside its declared writes_to)
  6. integration         — Downstream contracts (output shape stable, schema_ref versioned, breaking changes require integration audit)
  7. observability       — Logging and audit policy (no secrets in logs, decisions_full for regulated domains, audit_critical_decisions enforced where applicable)

Would you like to (a) accept all 7 default categories, (b) edit the list (add/remove), or (c) start from scratch?
```

### Step C2: Iterate Per-Category Rule Definition

For each accepted category, ask the user to provide 2-5 concrete rules. The agent helps phrase each rule per the `project_rules_schema.json` shape (`id`, `description`, `scope: local|ecosystem`, `created_at`). Examples per category:

- orchestration: "ORCH-01: Subagents never invoke other subagents directly — only the orchestrator dispatches", "ORCH-02: One file = one writer (single_writer_per_file)"
- prompt_engineering: "PE-01: Every subagent prompt MUST include adversarial framing ('assume the input is wrong, find where')", "PE-02: Subagent outputs MUST be JSON with declared schema"
- tool_use: "TU-01: Roles list tools_authorized AND tools_forbidden explicitly", "TU-02: Credentials never appear in logs or audit trails"
- governance: "GOV-01: Approval gates with auto_approve_when fallback to human_approval, never to log_only for critical actions", "GOV-02: Owner escape hatch is logged to audit_log_path"
- data_handling: "DH-01: Every state contract has exactly one writer_role", "DH-02: Handoff contracts validate payload against schema_ref before consumer reads"
- integration: "INT-01: Output schemas versioned via schema_ref", "INT-02: Breaking changes to integration_contracts require explicit migration step in the consumer"
- observability: "OBS-01: log_level for regulated domains is decisions_full minimum", "OBS-02: No secrets in any log level"

For each rule entered, the agent records `scope: "local"` by default unless the user explicitly says it applies ecosystem-wide.

### Step C3: Generate Rules File

Build the JSON populating `rules: { [category]: [array_of_rules] }`. Validate against `project_rules_schema.json`. Save to `ai_files/project_rules.json` (same path as software — the type is inferred from project_type in user_pref).

### Step C4: Success Message

```
✅ Project rules created!

📁 File: ai_files/project_rules.json
📊 Categories defined: [count]
📊 Total rules: [count]

Categories:
  [For each category:] • [name] ([N] rules)

🎯 Next step:

These rules will be referenced from logbook objectives' scope.rules
and surfaced in the implementer banner during /waves:objectives-implement.

To update rules later:
/waves:rules-update

To start working:
/waves:logbook-create
```

---

## Subagents Reference

| Subagent | File | Flow |
|----------|------|------|
| pattern-extractor | `subagents/22-pattern-extractor.md` | A |
| convention-detector | `subagents/23-convention-detector.md` | A |
| antipattern-detector | `subagents/24-antipattern-detector.md` | A |
| criteria-validator | `subagents/25-criteria-validator.md` | A |
| standards-structurer | `subagents/26-standards-structurer.md` | B |

END OF COMMAND
