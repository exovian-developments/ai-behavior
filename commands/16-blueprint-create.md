# Command: `/waves:blueprint-create [product-name]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Create a complete product blueprint by consuming the product foundation and working section-by-section with the product owner. Transforms validated facts and capabilities into a concrete product design with hypothesis, flows, views, rules, and success metrics.

**Schema:** `ai_files/schemas/product_blueprint_schema.json`

**Input:** `ai_files/product_foundation.json` (primary), `ai_files/*_feasibility.json` (optional deep-dive)

**Output:** `ai_files/product_blueprint.json`

**Parameters:** `[product-name]` (optional — if not provided, taken from foundation)

**Key Features:** Foundation-driven generation, section-by-section owner validation, capability refinement with acceptance criteria, flow & view design, design principle → product rule tracing, success metric dual-signal (success + failure), autonomous entity identity support, tech stack documentation

---

## Flow Derivations

| Flow | Condition | Description |
|------|-----------|-------------|
| **Standard** | `blueprint_type = "standard"` | Full blueprint without autonomous entity identity section |
| **Autonomous Entity** | `blueprint_type = "autonomous_entity"` | Full blueprint WITH autonomous entity identity definition |

---

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

0. MAIN AGENT: Check if `ai_files/user_pref.json` exists

1. IF NOT EXISTS → EXIT with message:
   ```
   ⚠️ Missing configuration!
   Please run first: /waves:project-init
   ```

2. IF EXISTS:
   - Extract `preferred_language` for all user interactions
   - Continue to STEP 0

---

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Locate Foundation & Validate Readiness**
**═══════════════════════════════════════════════════════════════════**

3. Check if `ai_files/product_foundation.json` exists

4. IF NOT EXISTS:
   - Check for `ai_files/*_feasibility.json`
   - IF feasibility exists:
     ```
     ⚠️ Product foundation not found!

     A feasibility analysis exists, but the foundation has not been generated.
     The foundation compacts feasibility data into the format this command needs.

     Run first:
     /waves:foundation-create

     Then return here.
     ```
   - IF no feasibility either:
     ```
     ⚠️ No product foundation or feasibility found!

     The blueprint needs a foundation as input.
     Start with:
     /waves:feasibility-analyze [product-name]

     Then:
     /waves:foundation-create

     Then return here.
     ```
   → **EXIT COMMAND**

5. IF EXISTS: Read `product_foundation.json` completely into memory

6. Check `blueprint_readiness.ready`:
   - IF `false`:
     ```
     ⚠️ Foundation indicates the product is NOT ready for blueprint:

     Blocking issues:
     • [list foundation.blueprint_readiness.blocking_issues]

     Recommended: [foundation.blueprint_readiness.recommended_next_step]

     Options:
     1. Proceed anyway (blueprint will have gaps)
     2. Address issues first and return later

     Choose:
     ```
   - IF "2" → EXIT
   - IF "1" → Continue with warning flag

7. Extract product name from foundation.meta.product_name (or use parameter)

8. Check if `ai_files/product_blueprint.json` already exists:
   - IF EXISTS: Warn, ask overwrite/cancel

9. Optionally load `ai_files/*_feasibility.json` for deeper context during generation (don't require, but use if available)

---

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Set Blueprint Type**
**═══════════════════════════════════════════════════════════════════**

10. MAIN AGENT (in preferred_language):
    ```
    📘 Blueprint creation for: [product_name]

    Foundation loaded:
    • Evidence: [evidence_strength]
    • Confidence: [feasibility_confidence]
    • Essential capabilities: [N]
    • Readiness: [READY / PROCEED WITH GAPS]

    What type of product is this?
    1. Standard product (app, platform, tool, service)
    2. Autonomous entity (AI coach, conversational agent, autonomous companion)

    Choose:
    ```

11. Store as `blueprint_type`

12. Ask for product owner name:
    ```
    Who is the product owner (person validating decisions)?
    ```
    Store as `meta.owner`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Problem Section (from Foundation → Blueprint)**
**═══════════════════════════════════════════════════════════════════**

13. MAIN AGENT: The foundation already has `validated_problem`. Present it:
    ```
    📋 PROBLEM (from foundation)

    🔴 PAIN: [foundation.validated_problem.pain]
    📊 REALITY: [foundation.validated_problem.reality]
    ❓ UNSOLVED: [foundation.validated_problem.unsolved]

    Evidence: [evidence_strength]

    This becomes the blueprint's problem section.
    Confirm or refine for the blueprint context:
    (Yes / Refine)
    ```

14. IF Refine → Collect modifications. The blueprint version may be sharper or more specific than the foundation version — this is expected (progressive refinement).

15. Store as `blueprint.problem`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Target Users (from Foundation → Blueprint)**
**═══════════════════════════════════════════════════════════════════**

16. Present foundation target users:
    ```
    👥 TARGET USERS (from foundation)

    [For each foundation.target_users[]:]
    [id]. [description]
        (Source: [persona_source])
    ```

17. Transform to blueprint format:
    - Keep `id` and `description`
    - Drop `persona_source`, `willingness_to_pay`, `primary_acquisition_channel` (these stay in foundation for reference)
    - Ask: "Confirm? (Yes / Add user / Remove / Refine description)"

18. Store as `blueprint.target_users[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 4: Product Hypothesis, Mission & Vision**
**═══════════════════════════════════════════════════════════════════**

19. MAIN AGENT: Generate draft hypothesis from foundation data:
    - Format: "[Product] will [solve problem.pain] by [enabling essential capabilities]"
    - Base on: validated_problem + essential_capabilities + validated_revenue_model

20. Present:
    ```
    🎯 PRODUCT HYPOTHESIS (draft)

    "[Product] will [X] by [Y]"

    This is a testable hypothesis — success_metrics will validate it.
    Confirm or rewrite:
    ```

21. Generate draft mission:
    - Format: "With [Product], users [specific daily action/benefit]"
    - Base on: essential_capabilities + target_users

22. Generate draft vision:
    - Format: "When fully realized, [Product] [end state]"
    - Base on: validated_problem.unsolved + essential_capabilities + revenue_model

23. Present both:
    ```
    🌟 MISSION (daily commitment):
    "[draft mission]"

    🔭 VISION (end state):
    "[draft vision]"

    Confirm or rewrite each:
    ```

24. Store `product_hypothesis`, `mission`, `vision`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Out of Scope**
**═══════════════════════════════════════════════════════════════════**

25. MAIN AGENT: Generate out_of_scope suggestions from:
    - Foundation capabilities classified as `desired` → candidates for exclusion
    - Foundation SWOT threats → things to explicitly not compete on
    - Foundation remaining_unknowns with low impact → defer

26. Present:
    ```
    🚫 OUT OF SCOPE (suggested exclusions)

    Each exclusion should hurt a little — if it doesn't hurt, it's not a real boundary.

    Suggested:
    1. [exclusion] — [why tempting but excluded]
    2. [exclusion] — [why]

    Confirm / Add / Remove / Modify:
    ```

27. Store as `blueprint.out_of_scope[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Design Principles**
**═══════════════════════════════════════════════════════════════════**

28. MAIN AGENT: Generate design principles from:
    - Foundation SWOT strengths → principles that leverage them
    - Foundation SWOT threats → principles that defend against them
    - Foundation top sensitivity variables → principles that optimize them
    - Foundation unfair_advantages → principles that protect them
    - Foundation proactive_insights.positioning_recommendation → positioning principle

29. For each principle, generate a `rules_preview` (2-3 short rules it generates)

30. Present:
    ```
    📐 DESIGN PRINCIPLES

    1. [principle]
       Rules preview: [If X then Y], [If A then B]

    2. [principle]
       Rules preview: [If X then Y]

    Each principle must generate at least one rule.
    Confirm / Add / Remove / Modify:
    ```

31. Store as `blueprint.design_principles[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 7: Essential Capabilities (Foundation → Blueprint Refinement)**
**═══════════════════════════════════════════════════════════════════**

32. MAIN AGENT: Transform foundation essential capabilities to blueprint format:
    - Foundation has: id (CAP-XXX), content, classification, revenue_streams, depends_on, build_effort_days
    - Blueprint needs: id (integer), capability (string), depends_on (integer[])

    **Only include capabilities where foundation.classification = "essential"**

33. Present:
    ```
    🎯 ESSENTIAL CAPABILITIES (from foundation, essential only)

    [For each essential:]
    [new_id]. [capability text]
        [depends_on: #X, #Y if any]

    These are the minimum without which the product CANNOT exist.
    Confirm / Add / Remove / Reclassify:
    ```

34. Store as `blueprint.essential_capabilities[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 8: Non-Essential Capabilities**
**═══════════════════════════════════════════════════════════════════**

35. Transform foundation capabilities classified as `important` and `desired`:
    - `important[]` ← foundation capabilities with classification "important"
    - `desired[]` ← foundation capabilities with classification "desired"
    - Also consider: foundation.proactive_insights.differentiation_ideas as desired candidates

36. Present grouped. Ask for confirmation.

37. Store as `blueprint.non_essential_capabilities`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 9: Autonomous Entity Identity (Conditional)**
**═══════════════════════════════════════════════════════════════════**

38. IF `blueprint_type === "autonomous_entity"`:

    Work with the product owner to define:
    - `identity`: Who the entity is, self-presentation, personality, foundational discourse
    - `voice`: How it communicates — tone, style, specific phrases, context variations
    - `operation_modes`: Behavioral modes and transition triggers
    - `operational_limits`: Can do / needs rules / must NEVER
    - `relationship_evolution`: How entity-user relationship changes over time

    **For each subsection, ask the owner directly. Do NOT generate speculatively.**

    ```
    🤖 AUTONOMOUS ENTITY IDENTITY

    This product has an AI entity at its core. Let's define it.

    1/5: IDENTITY
    Who is this entity? How does it introduce itself?
    What is its core personality? What is its foundational statement?

    [Wait for owner input]
    ```

    Continue through all 5 subsections.

39. IF `blueprint_type === "standard"`: Skip this section entirely.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 10: Essential Flows, Views & System Flows**
**═══════════════════════════════════════════════════════════════════**

40. MAIN AGENT: Expand foundation's essential_flows_draft into full blueprint flows:

    **For each foundation flow:**
    - Keep name, entry_point, termination
    - EXPAND description: Add step-by-step detail from entry to termination (happy path only)
    - Map `capability_refs` to new blueprint capability IDs
    - Ask owner for `references` (wireframes, Figma links, screenshots)

41. **Generate views:** For each essential flow, identify which VIEWS the user sees:
    - Each view = a screen or state in `success` state (data populated, no errors)
    - Ask owner to confirm or describe each view

42. **Generate system flows:** Identify backend processes essential for capabilities:
    - For each essential capability, what invisible system operations are needed?
    - Define trigger → result → description

43. Present all three:
    ```
    🔄 ESSENTIAL FLOWS & VIEWS

    USER FLOWS:
    1. [flow_name]
       Entry: [entry_point] → End: [termination]
       Steps: [description]
       Capabilities: [refs]

    VIEWS:
    1. [view_name] (success state)
       [what the user sees, what actions available]

    SYSTEM FLOWS:
    1. [system_flow_name]
       Trigger: [event] → Result: [outcome]

    Confirm / Add / Modify / Remove:
    ```

44. Store as `blueprint.essential_flows_and_views`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 11: Secondary Flows, Views & System Flows**
**═══════════════════════════════════════════════════════════════════**

45. MAIN AGENT: Generate secondary flows from:
    - Error handling for each essential flow
    - Empty states for each essential view
    - Edge cases identified during capability analysis
    - Alternative success paths

46. Present. Ask owner to confirm/modify/add.

47. Store as `blueprint.secondary_flows_and_views`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 12: Product Rules (from Design Principles)**
**═══════════════════════════════════════════════════════════════════**

48. MAIN AGENT: For each design principle, generate concrete product rules:
    - Format: "If [condition], then [behavior]"
    - Each rule must reference `principle_refs` and `applies_to`
    - Rules must be unambiguous — a developer implements without asking

49. Present:
    ```
    📏 PRODUCT RULES

    From Principle #1: "[principle text]"
    Rule 1: If [condition], then [behavior]
            Applies to: [capability/flow/view]

    Rule 2: If [condition], then [behavior]
            Applies to: [capability/flow/view]

    From Principle #2: ...
    ```

50. Ask owner to confirm. Iterate.

51. Store as `blueprint.product_rules[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 13: Success Metrics (Dual-Signal)**
**═══════════════════════════════════════════════════════════════════**

52. MAIN AGENT: Generate success metrics from:
    - Foundation financial_benchmarks.revenue_targets → revenue metrics
    - Foundation monte_carlo_summary.top_sensitivity_variables → operational metrics
    - Foundation kill_criteria → failure thresholds
    - Product hypothesis → hypothesis validation metric

    **Each metric MUST have both `success_signal` AND `failure_signal`.**

53. Present:
    ```
    📊 SUCCESS METRICS

    1. [metric]
       ✅ Success: [success_signal]
       🔴 Failure: [failure_signal]

    2. [metric]
       ✅ Success: [success_signal]
       🔴 Failure: [failure_signal]

    Every metric has two sides. Confirm / Add / Modify:
    ```

54. Store as `blueprint.success_metrics[]`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 14: Tech Stack**
**═══════════════════════════════════════════════════════════════════**

55. MAIN AGENT: Check if project context exists:
    - `ai_files/project_manifest.json` → extract tech stack info
    - Foundation doesn't have tech stack — this is blueprint-specific

56. Ask owner:
    ```
    🛠️ TECH STACK

    [If manifest found:]
    From project manifest: [framework, language, infrastructure]

    [If not found:]
    What technologies will this product use?

    Include: languages, frameworks, infrastructure, cloud services,
    third-party integrations, deployment targets (web/mobile/desktop),
    and any hard technical constraints.
    ```

57. Store as `blueprint.tech_stack` (prose string)

---

**═══════════════════════════════════════════════════════════════════**
**STEP 15: Initial Decisions & Open Questions**
**═══════════════════════════════════════════════════════════════════**

58. MAIN AGENT: Generate initial product_decisions from:
    - Every decision made during blueprint creation (blueprint_type, tech stack, capability classifications, scope exclusions)
    - Each decision with id, created_at, decision, context, impact_on

59. Generate initial open_questions from:
    - Foundation remaining_unknowns with impact "high" → open questions
    - Any unresolved ambiguities from blueprint creation

60. Present both sections. Ask owner to add any additional decisions or questions.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 16: Generate & Save Blueprint**
**═══════════════════════════════════════════════════════════════════**

61. Read schema from `ai_files/schemas/product_blueprint_schema.json`

62. Build complete blueprint JSON with ALL sections from Steps 1-15:
    - `meta`: product_name, owner, timestamps, blueprint_type
    - All sections populated from user-validated content

63. Validate against schema

64. Write to `ai_files/product_blueprint.json`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 17: Post-Creation Summary**
**═══════════════════════════════════════════════════════════════════**

65. MAIN AGENT (in preferred_language):
    ```
    ✅ Product Blueprint created!

    📁 File: ai_files/product_blueprint.json

    📊 Summary:
    • Product: [name] ([blueprint_type])
    • Owner: [owner]
    • Essential capabilities: [N]
    • Non-essential: [N] important + [N] desired
    • Essential flows: [N] user + [N] views + [N] system
    • Secondary flows: [N] user + [N] views + [N] system
    • Design principles: [N] → Product rules: [N]
    • Success metrics: [N]
    • Decisions recorded: [N]
    • Open questions: [N]

    🎯 Next step:
      /waves:roadmap-create [product-name]

      The roadmap will use this blueprint to plan development phases.

    💡 Update the blueprint as the product evolves:
      Edit ai_files/product_blueprint.json directly or
      use /waves:roadmap-update to record decisions that affect the blueprint.
    ```

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS**
**═══════════════════════════════════════════════════════════════════**

This command does NOT use subagents. All steps (foundation consumption, section generation, flow/view design, rule derivation) are executed directly by the main agent to preserve full context and ensure consistent cross-referencing between all blueprint sections.

---

**Status:** ✅ DESIGNED
