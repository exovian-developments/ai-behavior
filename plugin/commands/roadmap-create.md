---
description: Create a product-level roadmap with phases and milestones
allowed-tools: Read, Grep, Glob, Bash(git:*), Task
---

# Plugin Command: roadmap-create

You are executing the waves plugin roadmap creation command. This is an interactive orchestrator that gathers project context and delegates heavy analysis to the roadmap-orchestrator agent.

## Your Role

You are the main orchestrator for roadmap creation. Keep this thread lean — collect user input, check prerequisites, detect context, then dispatch to the agent for analysis.

## Step 1: Check Prerequisites

Verify user preferences and project structure exist:

```bash
test -f ai_files/user_pref.json && echo "✓ User preferences found" || echo "✗ Missing ai_files/user_pref.json"
test -f ai_files/project_manifest.json && echo "✓ Project manifest found" || echo "⚠ No manifest (optional)"
```

If user_pref.json doesn't exist:
- Ask: "Would you like to run `project-init` first to set up your preferences?"
- If yes → Exit with message to run project-init
- If no → Continue with defaults

## Step 2: Detect Project Context

Scan for:
- `ai_files/project_manifest.json` (primary context)
- `ai_files/project_rules.json` (constraints)
- `ai_files/project_standards.json` (standards and conventions)

Read each file if present and summarize findings:
```
✓ Found project manifest
  - Project type: [type]
  - Technology: [stack]
  - Team size: [size]

⚠ No coding rules found
```

## Step 3: Gather Product Vision

Ask the user (in their preferred language from user_pref.json):

```
📋 Let's create your product roadmap.

1️⃣ What is your product name?
   Example: "MyApp", "Analytics Platform", "Mobile Game"

→ Awaiting input:
```

After each response, confirm and continue:

```
2️⃣ What does it do? (1-2 sentence description)

→ Awaiting input:
```

```
3️⃣ Who is the product owner? (person responsible for decisions)

→ Awaiting input:
```

```
4️⃣ What's the primary business goal for the next 6 months?
   Example: "Launch MVP", "Reach 10K users", "Migrate to new stack"

→ Awaiting input:
```

```
5️⃣ Any known constraints? (timeline, budget, team size, tech choices)
   Example: "2 engineers, 3 months, must use React"
   Or: "0. I don't know (auto-detect)"

→ Awaiting input:
```

Store responses as:
```json
{
  "product_name": "string",
  "product_description": "string",
  "product_owner": "string",
  "primary_goal": "string",
  "constraints": "string"
}
```

## Step 4: Dispatch to roadmap-orchestrator Agent

Create an analysis prompt:

```
You are the roadmap-orchestrator agent. Create a new product roadmap.

PROJECT CONTEXT:
- Product name: {product_name}
- Description: {product_description}
- Owner: {product_owner}
- Primary goal: {primary_goal}
- Constraints: {constraints}

PROJECT FILES:
{manifest content if exists}
{rules content if exists}
{standards content if exists}

TASK: Analyze this context and generate a roadmap with:
1. 3-5 phases (max 7) following YAGNI principle
2. Phase 1 always "Foundation"
3. 2-5 milestones per phase with acceptance criteria
4. Identified decisions and open questions
5. Phase durations and status

Output as JSON matching logbook_roadmap_schema.json format.
```

Use the Task tool to invoke the agent:

```
Task: roadmap-orchestrator
Input: [analysis prompt above]
```

Wait for the agent to return a JSON roadmap structure.

## Step 5: Present Proposed Roadmap

Display the roadmap to the user in a readable format:

```
📊 PROPOSED ROADMAP: {product_name}

Vision:
  Mission: {mission from roadmap}
  Key Outcomes:
    - {outcome 1}
    - {outcome 2}
    ...

PHASES:
─────────────────────────────────────────

Phase 1: {phase name}
  Duration: {duration_weeks} weeks
  Status: not_started

  Milestones:
    • {milestone_id}: {milestone_name}
      Acceptance: {first acceptance criterion}
    • {milestone_id}: {milestone_name}
      Acceptance: {first acceptance criterion}

[Repeat for each phase]

DECISIONS IDENTIFIED:
  - {decision 1}
  - {decision 2}

OPEN QUESTIONS:
  - {question 1}
  - {question 2}

─────────────────────────────────────────

Does this roadmap align with your vision? (yes/no/adjust)
```

## Step 6: User Validation

If user says "adjust":
- Ask: "What should change? (phases, milestones, timeline, goals)"
- Gather adjustments
- Call agent again with refined prompt

If user says "yes":
- Proceed to Step 7

If user says "no":
- Ask: "Would you like to start over or adjust specific areas?"
- Handle response appropriately

## Step 7: Generate Roadmap File

Read the schema from plugin references:

```bash
cat "${CLAUDE_PLUGIN_ROOT}/skills/waves-protocol/references/logbook_roadmap_schema.json"
```

Apply timestamps to the roadmap JSON:
- `created_at`: Current UTC timestamp (ISO 8601)
- `last_updated`: Current UTC timestamp (ISO 8601)

Construct filename using wave convention:
- Scan `ai_files/` for existing `roadmap_w*.json` files
- If none exist: use `w0` (foundation wave — agnostic capabilities)
- If some exist: use next sequential wave number
- Ask user to confirm wave number

```
ai_files/roadmap_w{N}.json
```

Example: `ai_files/roadmap_w0.json`, `ai_files/roadmap_w1.json`

Wave types:
- w0 = Foundation — agnostic capabilities not in any base project
- w1+ = Business waves — vertical-specific capabilities

Write the roadmap JSON to the file.

## Step 8: Confirm Success

Display:

```
✅ Roadmap created successfully!

📄 File: ai_files/{filename}

Next steps:
  • Use `roadmap-update` to track progress
  • Use `logbook-create` to start working on Phase 1 milestones
  • Reference this roadmap in your CLAUDE.md context

Happy building! 🚀
```

## Error Handling

### User Interrupts
If user cancels during any step:
```
✗ Roadmap creation cancelled.

To create a roadmap later, run: roadmap-create
```

### Agent Fails
If the roadmap-orchestrator agent returns errors:
```
⚠ Agent Analysis Failed

Error: {error message}

Try:
1. Simplify project constraints
2. Provide a clearer vision statement
3. Check that project files are valid JSON
```

### File Write Fails
If writing the roadmap file fails:
```
⚠ Could not save roadmap

Path: {path}
Error: {error}

Try:
1. Ensure ai_files/ directory exists
2. Check file permissions
3. Use a different filename
```

## Milestone ID Convention

The roadmap-orchestrator assigns milestone IDs in format: `{phase_id}.{sequence}`

Example:
- Phase 1 milestones: phase-1.1, phase-1.2, phase-1.3
- Phase 2 milestones: phase-2.1, phase-2.2
- Phase 3 milestones: phase-3.1, phase-3.2, phase-3.3, phase-3.4

These IDs are immutable and used for tracking and cross-referencing in logbooks.

## Notes

- Always respect the user's language preference from user_pref.json
- Be encouraging about the vision and goals
- Keep the roadmap realistic (not over-optimistic)
- Explain why phases are ordered as they are
- Emphasize that the roadmap is a living document — it will evolve
