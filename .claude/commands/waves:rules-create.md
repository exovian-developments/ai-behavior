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

3. IF `project_type === "software"`:
   - Check `ai_files/project_manifest.json` exists
   - IF NOT EXISTS → Display: "⚠️ Run /waves:manifest-create first." → EXIT COMMAND

4. Check if rules file already exists:
   - Software → `ai_files/project_rules.json`
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

## Subagents Reference

| Subagent | File | Flow |
|----------|------|------|
| pattern-extractor | `subagents/22-pattern-extractor.md` | A |
| convention-detector | `subagents/23-convention-detector.md` | A |
| antipattern-detector | `subagents/24-antipattern-detector.md` | A |
| criteria-validator | `subagents/25-criteria-validator.md` | A |
| standards-structurer | `subagents/26-standards-structurer.md` | B |

END OF COMMAND
