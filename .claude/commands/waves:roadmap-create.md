---
description: Create a product-level roadmap with phases, milestones, decisions, and rolling context for strategic development orchestration.
---

# Command: /waves:roadmap-create

You are executing the waves roadmap creation command. Follow these instructions exactly.

## Your Role

You are the main orchestrator for roadmap creation. You will gather product vision, analyze project context, propose development phases with milestones, and create a structured roadmap file.

## Step -1: Prerequisites Check (CRITICAL)

Check if `ai_files/user_pref.json` exists.
- If found: Extract `preferred_language` and `project_type` from the JSON
- If not found: EXIT with message: "user_pref.json not found. Please initialize preferences first."

## Step 0: Parameter Check and Wave Number

- If product-name parameter is provided: Use it as the product name for the roadmap metadata
- If not provided: Show tip: "Tip: Run `/waves:roadmap-create my-product` to name the roadmap. Running without a name will prompt you."

**Wave number detection:**
- Scan `ai_files/` for existing `roadmap_w*.json` files
- If none exist: Default to `w0` (foundation wave — agnostic capabilities)
- If some exist: Suggest next wave number (e.g., if `roadmap_w0.json` and `roadmap_w1.json` exist, suggest `w2`)
- Ask user to confirm or override:
  ```
  📋 Wave number for this roadmap:

  Existing waves found: [list or "none"]
  Suggested: w[N]

  Wave types:
  • w0 = Foundation — agnostic capabilities not in any base project
    (e.g., phone auth with SMS/WhatsApp, new payment processor)
  • w1+ = Business waves — vertical-specific capabilities

  Use w[N]? (Enter to confirm, or type different number)
  ```
- Store as `wave_number`
- Continue with user interaction in preferred_language

## Step 1: Detect Context

Check for existing files in `ai_files/`:
- `product_blueprint.json` (product blueprint — richest context)
- `product_foundation.json` (product foundation — validated facts)
- `*_feasibility.json` (feasibility analysis — raw research)
- `project_manifest.json` (project manifest — technical context)
- `project_rules.json` (project rules)

Based on findings:
- If product_blueprint.json exists → Flow A (richest context: blueprint has capabilities, flows, design principles, success metrics)
- If product_foundation.json exists (no blueprint) → Flow A (good context: foundation has validated capabilities, financial benchmarks, SWOT)
- If manifest exists (no blueprint/foundation) → Flow A (basic context: technical stack and architecture)
- If none of the above → Flow B (from scratch)

**Context priority:** blueprint > foundation > feasibility > manifest. Use the richest available source. If multiple exist, read all for cross-referencing but prioritize the highest-level artifact.

## Step 2: Gather Vision

**Flow A (Manifest Exists):**
- Extract vision, features, and description from `project_manifest.json`
- Present extracted vision to user
- Ask: "Does this accurately represent your product vision? (1) Yes, confirmed (2) Refine it (3) Start fresh"

**Flow B (No Manifest):**
- Ask 4 vision-gathering questions (in preferred_language):
  1. "What problem does your product solve?"
  2. "What is your product's core mission?"
  3. "Who are your target users?"
  4. "What defines success for this product?"
- For each question, provide option: "0. I don't know (auto-detect)"
- If user selects 0 for any question, note it for subagent to infer

## Step 3: Dispatch Analysis

DISPATCH TO SUBAGENT (via Task tool):
- Subagent: roadmap-creator (subagent 32)
- Send parameters:
  - `project_root`: current directory
  - `product_name`: name from Step 0 or inferred from manifest
  - `product_vision`: consolidated vision from Step 2
  - `manifest_path`: path to project_manifest.json if exists
  - `rules_path`: path to project_rules.json if exists
  - `preferred_language`: from user_pref.json
- Receive:
  - `proposed_phases`: list of development phases with names and descriptions
  - `proposed_decisions`: key decisions for each phase
  - `open_questions`: unresolved questions identified
  - `analysis_summary`: brief summary of analysis

## Step 4: User Validation

Present proposed roadmap structure as a clear table:

| Phase | Name | Milestones | Key Decision |
|-------|------|-----------|--------------|
| 1 | [name] | [M1, M2, M3] | [decision] |
| 2 | [name] | [M4, M5] | [decision] |

Ask user to:
1. "Confirm as-is? (yes/no)"
2. "Modify phases? (add/remove/reorder/rename)"
3. "Modify milestones? (add/remove/reorder within phases)"
4. "Start over? (yes/no)"

Iterate until user confirms.

## Step 5: Generate Roadmap

- Read schema from `ai_files/schemas/logbook_roadmap_schema.json`
- Build roadmap JSON object following schema exactly:
  - `metadata.product_name`: from Step 0
  - `metadata.created_at`: current UTC timestamp (ISO 8601)
  - `metadata.last_updated`: current UTC timestamp (ISO 8601)
  - `metadata.language`: from user_pref.json
  - `product.status`: set to "planning"
  - `phases`: confirmed phases with milestones from Step 4
  - `decisions`: key decisions for each phase
  - `recent_context`: initial entry: "Roadmap created with [X] phases and [Y] milestones. Vision: [summary]"
  - `history_summary`: empty array

- Write JSON to `ai_files/roadmap_w[N].json` (where N is the wave_number from Step 0)
  - Example: `ai_files/roadmap_w0.json`, `ai_files/roadmap_w1.json`

## Step 6: Summary

- Confirm file creation with path: `ai_files/roadmap_w[N].json`
- Show overview: "[X] phases, [Y] total milestones, status: planning, wave: w[N]"
- Explain wave context:
  - If w0: "This is a foundation wave — agnostic capabilities not tied to any specific business vertical."
  - If w1+: "This is business wave [N] — vertical-specific capabilities."
- Suggest next step: "Ready to start? Run `/waves:logbook-create [product-name]` to create your first milestone logbook."
- Suggest future waves: "When you're ready for the next wave, run `/waves:roadmap-create [product-name]` again — it will auto-detect the next wave number."
