---
description: Update an existing product roadmap — report progress, record decisions, resolve questions, transition phases, or restructure milestones.
---

# Command: /waves:roadmap-update

You are executing the waves roadmap update command. Follow these instructions exactly.

## Your Role

You are the main orchestrator for roadmap updates. You will present the current roadmap state, gather the update from the user, validate changes, and apply them to the roadmap file.

## Step -1: Prerequisites Check (CRITICAL)

- Check if `ai_files/user_pref.json` exists. EXIT if missing.
- Verify at least one roadmap file exists in `ai_files/` directory. Search for both patterns: `roadmap_w*.json` (wave convention) and `*_roadmap.json` (legacy). EXIT if none found with message: "No roadmap files found. Create one first with `/waves:roadmap-create`."
- Extract `preferred_language` from user_pref.json for all user interactions

## Step 0: Select Roadmap

- If parameter provided: Find matching roadmap in ai_files/. Try these patterns in order:
  1. Exact match: `ai_files/[parameter]` (if ends with `.json`)
  2. Wave match: `ai_files/roadmap_w[parameter].json` (if parameter is a number)
  3. Legacy match: `ai_files/[parameter]_roadmap.json`
- If not provided:
  - List all roadmap files in ai_files/ matching both `roadmap_w*.json` and `*_roadmap.json` patterns, with their product names, wave number, and current status
  - Ask user to select one by number or name
- Read selected roadmap file completely into memory

## Step 1: Present Dashboard

Display current roadmap state in clear format (in preferred_language):

```
Product: [name] ([status])
Active Phase: [phase name] — [X]/[Y] milestones completed

Milestones Status:
  ✅ [milestone name] — completed on [date]
  🔵 [milestone name] — in progress (assigned to phase [X])
  ⬜ [milestone name] — not started
  🔴 [milestone name] — blocked (reason)

Open Questions: [N] pending
  - [question 1]
  - [question 2]
  ...

Last Updated: [timestamp]
Last Context Entry: "[text]"
```

## Step 2: Ask Update Type

Present menu options (in preferred_language):

```
What would you like to do?
1. Report progress on a milestone (mark complete, update status, add notes)
2. Record a decision (new decision or decision about existing question)
3. Add a new question or resolve an existing one
4. Transition to next phase (mark current phase complete, advance)
5. Restructure phases/milestones (add, remove, reorder, rename)
6. View detailed timeline or analytics
0. Auto-detect from what I describe (describe in natural language)
```

Wait for user selection.

## Step 3: Gather Details

Based on `update_type` selected, ask relevant follow-up questions (in preferred_language):

**If update_type = 1 (Progress Report):**
- "Which milestone? ([list current milestones])"
- "New status? (in_progress / completed / blocked)"
- "Add notes? (optional, max 200 chars)"
- If blocked: "What's blocking it?"

**If update_type = 2 (Record Decision):**
- "Is this a new decision or a response to an open question?"
- "If new: Decision title and rationale?"
- "If responding: Which question ([list questions])? Decision statement?"

**If update_type = 3 (Question Management):**
- "Add a new question? Or resolve existing?"
- If new: "Question text? Which phase/milestone does it relate to?"
- If resolve: "Which question? Resolution or answer?"

**If update_type = 4 (Phase Transition):**
- "Mark current phase [X] as complete?"
- "Confirm transition to phase [X+1]?"
- "Add completion notes for phase [X]?"

**If update_type = 5 (Restructure):**
- "What structure change? (add phase / remove phase / add milestone / remove milestone / reorder)"
- Follow with specific details for each change

**If update_type = 0 (Auto-detect):**
- Ask: "Describe your update in natural language:"
- Wait for free-text input, then proceed to Step 4

## Step 4: Dispatch Analysis

DISPATCH TO SUBAGENT (via Task tool):
- Subagent: roadmap-updater (subagent 33)
- Send parameters:
  - `roadmap_path`: full path to selected roadmap file
  - `roadmap_content`: entire current roadmap JSON
  - `project_root`: current project directory
  - `update_type`: from Step 2
  - `user_input`: gathered details from Step 3
  - `preferred_language`: from user_pref.json
- Receive:
  - `proposed_changes`: structured changes to apply
  - `context_entry`: new entry to add to recent_context
  - `warnings`: any concerns or side effects

## Step 5: Apply Changes

- Present `proposed_changes` to user in clear format
- Ask for confirmation: "Apply these changes? (yes/no/modify)"
- If "modify": ask which changes to adjust and how
- If approved:
  - Apply all changes to in-memory roadmap object
  - Update `metadata.last_updated` to current UTC timestamp
  - Prepend `context_entry` to `recent_context` array
  - If `recent_context` exceeds 20 items:
    - Compact oldest 10 entries into `history_summary` with summary text
    - Keep newest 10 in `recent_context`
  - Write updated roadmap back to file
  - Confirm write success

## Step 6: Post-Update Summary

Show what was changed in summary format (in preferred_language).

Provide contextual suggestions based on update_type:
- **If milestone completed:** "Milestone complete! Consider creating a logbook for the next milestone with `/waves:logbook-create [product] [next-milestone]`"
- **If all phase milestones done:** "Phase [X] complete! Ready to transition to phase [X+1]?"
- **If question resolved:** "Question resolved! This may unblock milestone [name] in phase [Y]."
- **If blocked milestone:** "Milestone is blocked. Use `/waves:logbook-create` with this milestone to investigate and unblock."
- **If phase transitioned:** "Transitioned to phase [X+1]. Launch first logbook for this phase to begin execution."

End with: "Roadmap updated and saved."
