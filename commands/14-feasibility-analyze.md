# Command: `/waves:feasibility-analyze [name]`

**Status:** ✅ DESIGNED
**Version:** 2.0 (enhanced with research-based projections, go-to-market, operating costs, rigorous Bayesian, and local risk analysis)

---

## Overview

**Purpose:** Pre-blueprint feasibility and market analysis. Validates an idea before defining the product. Combines conversational discovery, research-based Monte Carlo simulation, rigorous Bayesian analysis, and go-to-market strategy to assess viability.

**Schema:** `schemas/feasibility_analysis_schema.json`

**Output:** `ai_files/[name]_feasibility.json`

**Parameters:** `[name]` (optional) - Short identifier for the analysis

**Key Features:**
- Conversational idea discovery with expert consultant role
- Market analysis with competitor gap identification and **local risk investigation**
- Buyer persona definition from real observations
- Multi-stream revenue model design with flywheel and **minimum viable operating costs**
- **Go-to-market strategy** researched from similar product launches
- Monte Carlo simulation (10,000 scenarios) with **research-based parameters** and source tags
- **Rigorous Bayesian** belief update with 6 granular beliefs, typed evidence, and predefined likelihood ratio ranges
- Essential capabilities draft for minimum time to revenue
- Proactive suggestions throughout (positioning, marketing, features, partnerships)
- Iterable — pivot and re-run projections within the same analysis
- Universal — works for any project type, not just software

**IMPORTANT: No subagent delegation.** All steps executed directly by the main agent. Simulations run via temporary Python scripts with numpy. Web research executed via WebSearch/WebFetch tools.

---

## Agent Role: Expert Business Consultant

The agent in this command is NOT a form or question bot. It is an **expert business consultant** hired by a non-technical person seeking advice.

1. **Listens in natural language** — the user describes their idea, pains, resources as they would to a friend. No technical parameters are requested.
2. **Researches actively** — the agent searches for real market data, benchmarks, competitor pricing, and regional context. Does NOT rely on inference when data exists.
3. **Translates internally** — the agent converts responses AND research into technical variables (statistical distributions, Bayesian priors, unit economics). The user NEVER sees "likelihood_ratio" or "triangular distribution".
4. **Executes simulations** — Monte Carlo and Bayesian analysis run behind the scenes via Python scripts.
5. **Explains with natural language + interpretable graphics** — results are presented as a consultant would explain: "Based on my calculations, there is a 72% probability you reach $6,000/month in 6 months. If you increase your price by 15%, that probability rises to 88%."

---

## Parameter Sourcing Hierarchy

**CRITICAL:** Monte Carlo parameters must be grounded in real data, not agent inference. When constructing any variable for simulation, the agent MUST follow this hierarchy:

| Priority | Source | Tag | Confidence | Description |
|:--------:|--------|:---:|:----------:|-------------|
| 1 | Published benchmarks | `[RESEARCH]` | High | Industry reports, published studies, government data |
| 2 | Regional real cases | `[REGIONAL]` | High | Documented cases from the target region |
| 3 | Cases outside region | `[PROXY]` | Medium | Similar markets adjusted for regional context |
| 4 | Similar products/services | `[ANALOG]` | Medium | Different industry but comparable dynamics |
| 5 | User-confirmed estimate | `[VALIDATED]` | Medium | Agent infers, user confirms from experience |
| 6 | Agent inference | `[INFERRED]` | Low | Last resort — clearly flagged |

**Rules:**
- The agent MUST use WebSearch to look for real data before falling back to inference.
- Every parameter presented to the user MUST carry its source tag.
- If >30% of parameters are `[INFERRED]`, the agent MUST flag: "Many parameters lack real-world data. Consider gathering evidence before trusting these projections."
- The user sees a parameter table with tags and can challenge or confirm each value.

---

## Interpretable Graphics Design

All graphics must be understandable by someone with zero background in statistics or economics.

### Graphic 1 — "Your Income Journey" (Net Revenue Journey)
- X-axis: months, Y-axis: monthly **NET** income (revenue minus operating costs)
- Colored confidence band (p10-p90) with median as center line
- Horizontal dashed lines with labels: "Survival ($X)", "Goal ($X)"
- **Operating costs shown as shaded area at the bottom** (so user sees gross vs net)
- Annotations in user's language: "Here there is a 72% probability of covering your expenses"
- Legend: "Green zone = favorable scenarios | Red zone = needs adjustment"

### Graphic 2 — "Where Does the Money Come From?" (Revenue Composition)
- Stacked bars by month showing % of each stream
- Consistent colors per stream with readable labels
- Annotation: "Your strongest income is [stream]. It represents X% of total."

### Graphic 3 — "What Affects Your Result Most?" (Sensitivity/Impact)
- Horizontal tornado bars
- Labels in natural language: "How many customers you acquire per month" instead of "monthly_acquisition_rate"
- Each bar tagged with its source: `[RESEARCH]`, `[VALIDATED]`, `[INFERRED]`
- Annotation: "If you improve [variable], your income rises up to X%"
- **Highlight:** Variables with `[INFERRED]` tag that have high sensitivity = research priorities

### Graphic 4 — "How Confident Should You Be?" (Bayesian Confidence)
- Horizontal bars for each of the **6 beliefs**
- Prior (gray) vs Posterior (color) side by side
- Evidence icons per belief (how many pieces of evidence support it)
- Annotation: "After analyzing your evidence, confidence in [belief] rose from X% to Y%"
- **Missing evidence callout:** "Your weakest belief is [X]. One pilot test could raise it from Y% to Z%."

### Graphic 5 — "Your Costs vs Revenue" (Break-even Analysis)
- X-axis: months, Y-axis: cumulative ($)
- Two lines: cumulative revenue vs cumulative costs (including savings burn)
- Break-even point annotated with month and probability
- Savings remaining shown as declining area
- Annotation: "At current projections, you break even in month X with Y% probability"

Each graphic includes an **interpretation paragraph in natural language** below, generated by the agent.

---

## Flow Derivations

| Flow | Condition | Description |
|------|-----------|-------------|
| **Flow A** | New analysis (no existing feasibility file) | Full discovery from idea to projections |
| **Flow B** | Existing `ai_files/[name]_feasibility.json` found | Load existing analysis, jump to iteration checkpoint |

---

**═══════════════════════════════════════════════════════════════════**
**FLOW - ENTRY POINT**
**═══════════════════════════════════════════════════════════════════**

## Step -1: Prerequisites Check

1. MAIN AGENT: Check if `ai_files/user_pref.json` exists

2. IF NOT EXISTS:
   ```
   ⚠️ Missing configuration!

   Please run first:
   /waves:project-init

   This command requires user preferences to be configured.
   ```
   → **EXIT COMMAND**

3. IF EXISTS → Read `preferred_language`, `explanation_style`

4. **NO project_type restriction** — this command is universal (software, general, any type)

**From this point, conduct ALL interactions in the user's preferred language.**

---

## Step 0: Parameter and Flow Detection

1. IF `[name]` parameter provided:
   - Check if `ai_files/[name]_feasibility.json` exists
   - IF EXISTS → Set `flow = B`, load existing analysis, go to Step 12 (Iteration Checkpoint)
   - IF NOT EXISTS → Set `flow = A`, store `analysis_name = [name]`, go to Step 1

2. IF no parameter:
   - Ask user for a short name for the analysis
   - Set `flow = A`, go to Step 1

---

## Step 1: Idea Discovery (Conversational, Proactive)

The agent interviews the user with open questions:

```
💡 Tell me about your idea. I'll help you evaluate whether it can become a viable business.

Let's start with the basics:
• What is your idea in one sentence?
```

Wait for response, then continue conversationally:
- "What specific problem does it solve?" → problem_statement (pain/reality/unsolved)
- "Why now? What changed in the market?" → why_now
- "What unique advantage do YOU have to solve this?" → founder_advantage

**Proactivity:**
- If the idea is vague → suggest concrete angles based on user skills
- If too broad → suggest niches
- If the problem is unclear → challenge with "How do you know this is a real problem?"

Store results in `idea_profile`.

---

## Step 2: User Resources

```
📋 Now let me understand your resources and constraints.
```

Ask conversationally:
- "How much time per week can you dedicate?" → time_weekly_hours
- "How long can you sustain this without income?" → runway_months
- "What are your savings specifically for living expenses?" → savings_for_living
- "What are your skills?" → skills[] (agent assesses level and relevance internally)
- "Do you have any budget to invest? Credit available? What are your monthly fixed costs?" → financial_capacity
- "Do you have contacts in this industry? Communities?" → network
- "Any hard constraints I should know about?" → constraints[]

Store results in `user_resources`.

---

## Step 3: Market Analysis + Local Risk Investigation

```
🔍 Let's analyze the market.
```

### 3.1: Market Sizing & Competition

- TAM/SAM/SOM (if user doesn't know, agent suggests ranges and explains)
- Competitors (name, positioning, pricing, gap)
- Market gap identified
- Unfair advantages

**Proactivity:** After each response, suggest alternative positioning:
- "I noticed no competitor covers X niche. Have you considered focusing there?"
- "Given your [skill], you could position as the [angle] in this market."

### 3.2: Local & Contextual Risk Investigation

**The agent MUST research and present risks specific to the target market:**

```
⚠️ Let me investigate the specific risks in your market...
```

Use WebSearch to research each category:

| Category | What to investigate | Example |
|----------|-------------------|---------|
| **Regulatory** | Labor laws, tax obligations, consumer protection, licenses | "Does your country require a license to operate a marketplace?" |
| **Payment infrastructure** | Available processors, real costs, local payment methods | "What payment methods do people actually use? What are the real processing fees?" |
| **Cultural** | Trust levels, digital adoption, habits, informal economy | "How do people in this market currently find and pay for these services?" |
| **Seasonal/Cyclical** | Weather, economic cycles, demand patterns | "Is there a season where demand drops significantly?" |
| **Competitive response** | Who could copy, barriers to entry, switching costs | "If this works, what stops a bigger player from copying you in 6 months?" |

**Present findings as a risk matrix:**

| Risk | Severity | Probability | Mitigation | Source |
|------|:--------:|:-----------:|------------|:------:|
| [risk] | High/Med/Low | High/Med/Low | [strategy] | [RESEARCH]/[REGIONAL] |

Store results in `market_analysis` (includes `local_risks[]`).

---

## Step 4: Buyer Personas

```
👥 Let's define who your customers are — specific people, not market segments.
```

For 1-3 concrete personas:
- "Tell me about someone you know who has this problem. What does their day look like?"
- Pain points in the persona's own words
- Current solution (how they survive today)
- Willingness to pay
- Acquisition channel (where they spend time)
- Decision triggers (what would make them buy)

**Proactivity:** Suggest additional personas if adjacent markets detected.

Store results in `buyer_personas[]`.

---

## Step 5: Revenue Model + Operating Costs

```
💰 How will this make money? And what will it cost to operate?
```

### 5.1: Revenue Streams

- Model type (subscription, marketplace, hybrid, transactional)
- Revenue streams (like exobase's 4 streams: marketplace fee, SaaS, payment processing, sponsorships)
- Pricing per tier
- Unit economics per stream
- Flywheel description

**Proactivity:** If user defines only 1 stream, suggest 2-3 complementary streams with justification.

### 5.2: Minimum Viable Operating Costs

**The agent MUST define the minimum cost to run the operation.** This is NOT optional — projections without costs are fantasies.

```
💸 Now let's figure out the minimum cost to keep this running.
```

Research real costs (WebSearch) and ask user to confirm:

| Category | What to estimate | How to research |
|----------|-----------------|-----------------|
| **Infrastructure** | Servers, domain, APIs, tools | Search real pricing for identified services |
| **Marketing/Acquisition** | Ads, content, outreach tools | From go-to-market strategy (Step 7) |
| **Payment processing** | Transaction fees, transfer costs | Research actual processor fees in target market |
| **Personnel** | Minimum staff needed (or founder-only) | Based on operations volume |
| **Legal/Fiscal** | Registration, taxes, compliance | Research local requirements |
| **Tools** | Analytics, email, communication | Search real pricing |

**Present as table for user confirmation:**

```
📋 MINIMUM MONTHLY OPERATING COSTS

| Item                    | Cost/month | Source        |
|-------------------------|:----------:|:-------------:|
| Servers + hosting       | $XX        | [RESEARCH]    |
| Marketing (ads)         | $XX        | [VALIDATED]   |
| Payment processing      | ~X%        | [RESEARCH]    |
| Tools (analytics, etc)  | $XX        | [RESEARCH]    |
| Personnel               | $0 (founder only) | [VALIDATED] |
| ─────────────────────── | ────────── | ───────────── |
| TOTAL                   | $XX/month  |               |

Does this look right? Anything I'm missing or overestimating?
```

**Wait for user confirmation before proceeding.**

Store results in `operating_costs`.

---

## Step 6: Revenue Targets

```
🎯 What do you need to earn from this?
```

- "What's the minimum monthly income you need to survive?" → survival_monthly
- "What covers all your expenses comfortably?" → intermediate_monthly
- "What's your target income?" → comfortable_monthly
- "How many months do you give yourself to reach that?" → timeline_months

**Reality check:** If timeline > runway, flag: "Your timeline exceeds your runway — this is a critical risk."

Store results in `revenue_targets`.

---

## Step 7: Go-to-Market Strategy

```
🚀 How will you get your first customers? Let me research what has worked for similar products.
```

### 7.1: Research Similar Launches

**The agent MUST research how similar products/services launched:**

Use WebSearch to find:
- How did comparable marketplaces/products acquire their first 100 customers?
- What channels worked best? (paid ads, organic, partnerships, field sales, referrals, outreach)
- What was the approximate CAC (customer acquisition cost)?
- What failed and why?

Present findings:
```
🔍 LAUNCH RESEARCH — Similar products

| Product/Service | Market | Launch strategy | What worked | What failed |
|-----------------|--------|----------------|-------------|-------------|
| [name]          | [mkt]  | [strategy]     | [result]    | [lesson]    |
```

### 7.2: User Budget and Constraints

Ask conversationally:
- "How much can you invest in launching? Per month? One-time?" → launch_budget
- "Can you do field work (visiting customers) or is this all digital?" → launch_constraints
- "Do you have any existing audience or network to leverage?" → existing_channels

### 7.3: Design Launch Strategy

Based on research + budget + constraints, propose 2-3 acquisition channels:

For each channel:
- **Mechanics:** How it works step by step
- **Cost:** Monthly cost estimate with source tag
- **Expected volume:** Customers/month with source tag
- **CAC:** Cost per acquisition
- **Timeline:** When it starts producing results
- **Scalability:** Does it grow or plateau?

**Present as scenarios for Monte Carlo integration:**

```
📊 LAUNCH SCENARIOS

| Scenario    | Channels            | Cost/month | Expected customers/month | CAC   |
|-------------|---------------------|:----------:|:------------------------:|:-----:|
| Conservative| [channel 1 only]    | $XX        | X-Y                      | $X.XX |
| Moderate    | [channels 1+2]      | $XX        | X-Y                      | $X.XX |
| Aggressive  | [channels 1+2+3]    | $XX        | X-Y                      | $X.XX |
```

**Wait for user feedback.** Adjust scenarios based on what the user thinks is realistic.

Store results in `go_to_market`.

---

## Step 8: Monte Carlo Projections (Research-Based)

```
📊 Running projections with real-world data...
```

### Step 8.1: Build Variables (Research-Based)

The agent constructs stochastic variables using the **Parameter Sourcing Hierarchy** (see above).

**For EVERY variable, the agent MUST:**
1. Search for real benchmarks first (WebSearch)
2. Assign a source tag
3. Build the distribution from data, NOT from intuition

Variables to construct per stream:
- Revenue per unit per stream → distribution from real pricing data
- Monthly acquisition rate per channel → from go-to-market research
- Conversion rate per channel → from industry benchmarks
- Monthly churn → from comparable services
- Operating costs → from Step 5.2 (confirmed by user)
- Launch strategy impact → from Step 7 scenarios

**Present parameter table to user:**

```
📋 SIMULATION PARAMETERS

| Parameter                  | Distribution    | Values        | Source      |
|----------------------------|:---------------:|:-------------:|:-----------:|
| Project value (typical)    | triangular      | $X / $Y / $Z  | [VALIDATED] |
| Monthly new customers      | uniform         | X - Y          | [RESEARCH]  |
| Conversion rate            | uniform         | X% - Y%        | [PROXY]     |
| Monthly churn              | uniform         | X% - Y%        | [ANALOG]    |
| Operating costs            | fixed           | $X/month       | [VALIDATED] |
| ...                        | ...             | ...            | ...         |

⚠️ Parameters tagged [INFERRED]: X of Y total (Z%)
Do you want to confirm or adjust any of these?
```

**Wait for user confirmation.** Adjust any values the user challenges.

### Step 8.2: Generate and Execute Python Script

Generate a temporary Python script using numpy:
```python
import numpy as np
import json

# 10,000 simulations, N months
# Variables with distributions from Step 8.1 (research-based)
# Operating costs deducted monthly (from Step 5.2)
# Go-to-market scenarios as separate simulation runs (from Step 7)
# Calculates: gross revenue, operating costs, NET revenue, customers, stream breakdown
# Sensitivity analysis: vary each parameter +-20%, measure impact on net revenue
# Outputs: month_by_month, probability_targets, sensitivity_ranking, cost_breakdown
```

Execute via Bash, capture results.

### Step 8.3: Present Results with Interpretable Graphics

Generate the 5 graphics described in the Graphics Design section above.

Present results in natural language:
```
📊 PROJECTION RESULTS (10,000 scenarios, N months)

Scenario: [scenario name]

Month 3:  Gross $X → Costs $Y → NET $Z | P(≥ survival) = X%
Month 6:  Gross $X → Costs $Y → NET $Z | P(≥ survival) = X% | P(≥ goal) = X%
Month 12: Gross $X → Costs $Y → NET $Z | P(≥ survival) = X% | P(≥ goal) = X%

What affects your result most:
1. [variable in natural language] — high sensitivity [SOURCE_TAG]
2. [variable in natural language] — medium sensitivity [SOURCE_TAG]

⚠️ High-sensitivity variables with [INFERRED] tag:
→ [variable]: if this estimate is wrong by 30%, your survival probability changes by X points.
→ RECOMMENDATION: validate this before building.
```

### Step 8.4: Proactive Suggestions

If probability is low, suggest adjustments:
- "If you add a premium services stream at $500/project, the probability of reaching $6K/month rises from 24% to 68%."
- "Increasing your price by 15% raises your survival probability by 20 percentage points."
- "Your go-to-market [channel X] is the most impactful lever. Doubling the budget there adds Y% to survival probability."

Offer to create alternative scenarios (conservative, optimistic, pivot).

Store results in `revenue_projections[]`.

---

## Step 9: Bayesian Analysis (Rigorous)

### Step 9.1: Establish Priors — 6 Granular Beliefs

The agent evaluates viability through **6 specific beliefs**, not 3 generic ones. Ask in natural language (agent converts to probabilities 0-1):

| # | Belief | Question to ask | Maps to |
|:-:|--------|----------------|---------|
| 1 | **The problem exists and hurts** | "On 1-10, how sure are you this problem causes real pain worth paying to fix?" | P(problem_real) |
| 2 | **Customers are reachable** | "On 1-10, how confident you can actually find and reach these customers?" | P(reachable) |
| 3 | **Customers will pay this price** | "On 1-10, how sure are you they'll pay what you plan to charge?" | P(will_pay) |
| 4 | **You can execute** | "On 1-10, how confident you have the skills, time, and resources to build this?" | P(can_execute) |
| 5 | **The model generates margin** | "On 1-10, how sure are you the math works — revenue exceeds all costs?" | P(margin_positive) |
| 6 | **It's defensible** | "On 1-10, how confident that a competitor can't just copy this and win?" | P(defensible) |

Convert 1-10 scale to probability: P = score / 10 (e.g., 7 → 0.70).

### Step 9.2: Gather Evidence with Typed Likelihood Ratios

For each piece of evidence, the agent MUST:
1. Classify the evidence type
2. Use the predefined LR range for that type
3. Explain to the user WHY this evidence strengthens or weakens the belief
4. Show the impact

**Evidence Types and Predefined Likelihood Ratio Ranges:**

| Evidence Type | LR Range | When to use | Example |
|---------------|:--------:|-------------|---------|
| **Published market data** | 2.0 - 5.0 | Industry reports, government statistics, published research | "BID reports 70% informality in LATAM construction" |
| **Real customer conversations (5+)** | 1.5 - 4.0 | Direct interviews with target customers confirming pain/willingness | "Talked to 5 contractors, 4 said they'd pay $15/month" |
| **Functional pilot with payments** | 3.0 - 8.0 | Actual paying customers, even 1-5 | "3 customers paid for a prototype in 2 weeks" |
| **Founder domain expertise (10+ yr)** | 1.2 - 2.5 | Relevant deep experience in the domain | "30 years in construction, knows pricing dynamics" |
| **Competitor success analysis** | 1.3 - 3.0 | Competitor validated demand (even if they failed on execution) | "IguanaFix proved demand exists but failed monetization" |
| **Competitor failure analysis** | 1.1 - 2.0 | Competitor's failure teaches what NOT to do | "Homejoy failed from worker misclassification" |
| **Industry analogy** | 1.1 - 1.8 | Different industry with similar dynamics | "UberEats charges 30% to restaurants successfully" |
| **Go-to-market research** | 1.2 - 2.5 | Validated channels with real CAC data | "Meta Ads in LATAM CPM is $4-6 (published benchmark)" |
| **No direct evidence** | 0.8 - 1.2 | Pure inference — nearly neutral | Use only as last resort |

**LR Assignment Rules:**
- Within each range, assign HIGHER LR when: evidence is recent, from target region, sample size >10, independently verified
- Assign LOWER LR when: evidence is old, from different region, anecdotal (1-2 cases), self-reported
- **Negative evidence** uses LR < 1.0: e.g., "5 customers said they'd NEVER pay that price" → LR = 0.3-0.5

**The agent MUST explain each assignment to the user:**
```
📊 EVIDENCE ANALYSIS

Evidence: "Talked to 8 contractors in Costa Rica, 6 confirmed they'd pay $15/month for management tools"
Type: Real customer conversations
Affects belief: #3 (Customers will pay this price)
LR assigned: 3.2 (high end — 8 conversations, 75% positive, in target market)

Impact: P(will_pay) moves from 60% → 83%
```

### Step 9.3: Calculate Posteriors

For each belief:
```
P_posterior = P_prior × Π(likelihood_ratios)
Normalize to [0, 1]
```

**Overall feasibility confidence:**
```
P(feasible) = geometric_mean(all 6 posterior beliefs)
```

Classification:
- **HIGH** (≥ 70%): Evidence supports viability. Ready for blueprint.
- **MEDIUM** (40-69%): Some beliefs are weak. Identify and address before building.
- **LOW** (< 40%): Significant doubts. Recommend gathering evidence or pivoting.

Present the Bayesian Confidence graphic (Graphic 4).

### Step 9.4: Identify Missing Evidence (Actionable)

For EACH belief with posterior < 70%:

```
⚠️ WEAK BELIEF: #3 — Customers will pay this price (currently 52%)

The SINGLE most impactful action to strengthen this:
→ Get 3 customers to pay the actual price in a 2-week pilot test
→ Expected impact: 52% → 82% (LR = 4.0 for functional pilot)
→ Effort: Medium (need working prototype + 2 weeks)
→ Cost: ~$0

Without this evidence, your Monte Carlo projections are built on an assumption
that has only 52% confidence. Treat the numbers with caution.
```

Store results in the current projection scenario's `bayesian_analysis`.

---

## Step 10: Essential Capabilities Draft

Based on revenue model, personas, Monte Carlo, and go-to-market:

```
🔧 Based on the analysis, here are the minimum capabilities to start generating revenue:
```

- Core capabilities classified as: revenue_blocking, revenue_enabling, usage_expansion
- Essential user flows for the MVP
- Estimated weeks to MVP (from build_effort_days / weekly_hours)
- Estimated weeks to first revenue
- **Go-to-market capabilities** needed for launch strategy

Store results in `essential_capabilities_draft`.

---

## Step 11: Proactive Suggestions Summary

Consolidate all suggestions accumulated during Steps 1-10:

```
💡 Here are my recommendations:
```

- Alternative positioning angles
- Marketing strategies with effort/ROI (informed by go-to-market research)
- Differentiation ideas
- Partnership opportunities
- **Risk mitigation strategies** (from local risk investigation)
- **Evidence gathering plan** (from Bayesian missing evidence analysis)

Store results in `proactive_suggestions`.

---

## Step 12: Iteration Checkpoint

```
🎯 FEASIBILITY SUMMARY

Confidence: [HIGH/MEDIUM/LOW] (X%)
Weakest belief: [belief name] (X%)
Strongest belief: [belief name] (X%)
Parameters with [INFERRED] tag: X of Y
Ready for blueprint?: [YES/NO]

Options:
  [1] Pivot market / re-investigate risks (return to Step 3)
  [2] Pivot revenue model / adjust costs (return to Step 5)
  [3] Redesign go-to-market strategy (return to Step 7)
  [4] New Monte Carlo scenario (return to Step 8)
  [5] Update Bayesian evidence (return to Step 9)
  [6] Refine capabilities (return to Step 10)
  [7] Save and proceed to blueprint
  [q] Save and exit
```

Each iteration is recorded in `iteration_history[]`.

Handle user choice:
- 1 → Go to Step 3, clear/update affected sections
- 2 → Go to Step 5, clear/update affected sections
- 3 → Go to Step 7, redesign launch strategy, re-run Monte Carlo
- 4 → Go to Step 8 (adds new scenario, preserves existing)
- 5 → Go to Step 9 (adds evidence, recalculates posteriors)
- 6 → Go to Step 10
- 7 → Go to Step 13
- q → Go to Step 13

---

## Step 13: Save and Next Step

1. Validate feasibility JSON against schema
2. Save to `ai_files/[name]_feasibility.json`
3. Present summary:

```
✅ Feasibility analysis saved!

📁 File: ai_files/[name]_feasibility.json

📊 Summary:
  • Idea: [core_idea]
  • Confidence: [level] ([X]%)
  • Weakest belief: [name] ([X]%)
  • Best scenario: P(survival) = X%, P(goal) = X%
  • Parameters: X research-based, Y inferred
  • Scenarios analyzed: [N]
  • Go-to-market: [N] channels designed
  • Operating costs: $X/month minimum
  • Iterations: [N]

🎯 Next:
  [If ready for blueprint:]
  • Create product blueprint: /waves:manifest-create [name]

  [If not ready:]
  • Evidence to gather first:
    - [action 1 — expected impact on weakest belief]
    - [action 2 — expected impact on confidence]
  • Continue iterating: /waves:feasibility-analyze [name]
```

---

## Subagents

This command does NOT use subagents. All steps (discovery, analysis, web research, simulation execution, Bayesian calculations, capability drafting) are executed directly by the main agent to preserve full conversation context and expert consultant persona.

---

## Error Handling

| Error | Handling |
|-------|----------|
| user_pref.json not found | Show error, suggest project-init, EXIT |
| Python/numpy not available | Install numpy, retry |
| Monte Carlo script fails | Show error, offer manual variable adjustment |
| No revenue streams defined | Cannot run Monte Carlo, return to Step 5 |
| Timeline exceeds runway | Flag as critical risk, suggest adjustment |
| All probabilities < 10% | Strong recommendation to pivot or abandon |
| WebSearch unavailable | Flag affected parameters as [INFERRED], warn user about reduced confidence |
| >30% parameters [INFERRED] | Warning: "These projections have limited grounding. Prioritize research." |
| Operating costs not confirmed | Cannot run Monte Carlo, return to Step 5.2 |
| No go-to-market defined | Cannot create acquisition scenarios, return to Step 7 |
| Bayesian confidence < 40% | Strong recommendation: gather evidence before building |
| Local risks not investigated | Warning: "Projections don't account for local risks. Results may be optimistic." |

---

**Status:** ✅ DESIGNED (v2.0)
