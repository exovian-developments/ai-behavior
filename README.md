<div align="center">

# ai-behavior

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

</div>

## What is it?
A working protocol for AI agents (`Claude Code`, `Codex`, `Gemini CLI`) compatible with all types of software projects, based on a set of `.json` files (json_schema) that provide guidance for operating and generating contexts to work accurately on real projects.

**Pattern:** Each `json_schema` contains the following for each object in the structure:
- `description` = Description of the field/property, so the LLM clearly understands what content to generate.
- `$comment` = How the LLM should operate on that field, without inference and improving result precision.

## Proven Results
These schemas have been used and refined with `Claude Code`, `Codex`, and `Gemini CLI`* and are capable of:

**1. Generate and work with global project context**
- Generate a structured project manifest (language, framework, architecture, layer patterns, features, etc).
- Generate coding rules (Patterns and standards) and follow them.
- Follow the workflow style of the user in charge.

**2. Generate and work with focused context on tasks/tickets/stories**
- Generation of "focused" context per development ticket that can be extended across multiple LLMs and sessions (logbook).
- Produce code following project rules (previously generated).
- Create a structured resolution comment per ticket based on the ticket logbook.

**Note: Gemini CLI** In many tests, it was proven that `Gemini CLI` works better producing results in `.md` format because in `.json` it often has problems with anchors for adding and modifying elements in the `.json`.

## 🛠️ Installation

### Option 1: Homebrew (Recommended for macOS/Linux)
```bash
brew tap exovian-developments/tap
brew install ai-behavior

# From your project root
ai-behavior
```

### Option 2: Installation Script
```bash
# Download the script first (ALWAYS inspect scripts before running them)
curl -O https://raw.githubusercontent.com/exovian-developments/ai-behavior/main/install.sh

# Inspect the content
cat install.sh

# If it looks safe, run it from your project root
bash install.sh
```

⚠️ **Security Note:** Never run scripts from the internet without reviewing them first.

### Option 3: Manual Installation

**1.** Checkout the `ai-behavior` repository.
```bash
git clone https://github.com/exovian-developments/ai-behavior.git
```

**2.** In your project root, create the `ai_files` directory and the following subdirectories:
```bash
mkdir -p ai_files/{schemas,logbooks}
```

**3.** Copy the schemas located in `ai-behavior/schemas/` to the `ai_files/schemas/` directory of your project:
```bash
cp ai-behavior/schemas/*.json ai_files/schemas/
```

Included schemas:
  - `logbook_schema.json`
  - `project_manifest_schema.json`
  - `project_rules_schema.json`
  - `ticket_resolution_schema.json`
  - `user_pref_schema.json`

**4.** Add the following section at the beginning of your agent file `CLAUDE.md`, `AGENT.md`, `GEMINI.md`.
```
# Key files to review on session start:
  required_reading:
    - path: "ai_files/project_manifest.json"
      description: "Detailed explanation about structure, technologies, architecture and features of the current project"
      when: "always"

    - path: "ai_files/project_rules.json"
      description: "This file contains the coding expectation, always follow these coding rules to keep the code consistency and cohesion"
      when: "always"

    - path: "ai_files/user_pref.json"
      description: "This file contains the user interaction preferences when working, always follow this instructions"
      when: "always"

    - path: "ai_files/logbooks/"
      description: "Directory to create and read logbooks related to development tickets. Ask for the logbook to read or create"
      when: "always"

    - path: "ai_files/schemas/project_manifest_schema.json"
      description: "Json file with structure and guidance about how to create or update a project manifest"
      when: "when_user_ask"

    - path: "ai_files/schemas/project_rules_schema.json"
      description: "Json file with structure and guidance about how to create coding rules, standards and criterias"
      when: "when_user_ask"

    - path: "ai_files/schemas/logbook_schema.json"
      description: "Json file with structure and guidance about how to create a logbook to track and maintain conversational context for long-term memory and task tracking."
      when: "when_user_ask"

    - path: "ai_files/schemas/ticket_resolution_schema.json"
      description: "Json file with structure and guidance about how to create a summary of the resolution of the work done"
      when: "when_user_ask"

    - path: "ai_files/schemas/user_pref_schema.json"
      description: "Json file with structure and guidance about how to create a profile with guidance about how the interaction between the agent and the user"
      when: "when_user_ask"

```

**5.** _(Optional)_ Add the `ai_files/logbooks/` directory to your `.gitignore` to avoid committing work logbooks:
```bash
echo "ai_files/logbooks/" >> .gitignore
```

## 🧭 When to Use It
- Ongoing Projects: Start by creating the manifest and rules from code; then use the logbook and ticket resolution schema for daily work with development tickets.

- Greenfield Projects: Use the schemas to generate a manifest and base rules for your project; evolve as the code grows.

> [!IMPORTANT] About Prompts:
> The prompts included are proven guides that you can copy and use directly. You can also create your own prompts while maintaining or improving the idea according to your context.

## 🌎 How to Create the Global Context

**1.** Create your interaction preferences:
- Resulting file: `user_pref.json`
- Schema: `ai_files/schemas/user_pref_schema.json`
- Prompt _(Copy and paste in the conversation with your agent)_:
```
Analyze the entire user_pref_schema.json file and based on the structure and description of each property and object in the file, ask me questions to generate the ai_files/user_pref.json file. Once the questions are finished, generate the file fulfilling the semantic objective of each property indicated in the schema. Be the conversation moderator, be concise in the questions, don't modify the final object and if you see that I deviate from any question, be proactive and resume the conversation thread to generate the file.
```

**2.** Create the Project Manifest (Update from time to time)
- Resulting file: `project_manifest.json`
- Schema: `ai_files/schemas/project_manifest_schema.json`
- Prompt _(Copy and paste in the conversation with your agent)_:
```
Analyze the entire project_manifest_schema.json file, then based on the structure and description of each property and object in the file, analyze the current project and strictly identify what is requested in the file; to do the analysis, go to each directory and file in the project; don't ignore paths or files because they may be relevant to discover patterns, architecture or project features. Finally generate the ai_files/project_manifest.json file fulfilling the semantic objective of each property indicated in the schema.
```

**3.** Create Project Rules: Whether it's an ongoing project or a new one, it's recommended to create rules by layers, so that you can create or identify rules according to the specific good practices of the layer and address particularities with attention. It's recommended to have support or experience to avoid over-engineering in this process.
- Resulting file: `project_rules.json`
- Schema: `ai_files/schemas/project_rules_schema.json`
- Recommendation: Send a separate prompt for each `layer` of `project_manifest.technical_details.architecture_identified`.
- Risks: Over-engineering was detected, but if you reinforce the YAGNI principle in the prompt it makes a good improvement.
- Prompt _(indicate layer to analyze according to what was detected in the `project_manifest`)_:
```
Analyze the entire project_rules_schema.json file, then analyze the <layer> layer and everything related according to ai_files/project_manifest.json and then go to the project code and search for related classes, objects, functions and methods, trace everything related and according to the content found identify patterns, generate architecture rules that have been applied, extract and generate naming conventions, class structure conventions, even consider patterns that are not good practice but have been implemented throughout the analyzed content. Always follow the criteria indicated in project_rules_schema.json when you create a rule and always apply the YAGNI principle. Finally update the ai_files/project_rules.json file following the instructions in ai_files/schemas/project_rules_schema.json, if the project_rules.json file doesn't exist yet, then create it based on the structure indicated in project_rules_schema.json and the analyzed content.
```

## 🎯 Focused Context - The Real Power!
**The Logbook**

The ticket/story logbook is the `.json` file that contains the context focused on primary, secondary objectives and records of findings/progress/problems encountered as you work, the result is a universal file useful for any agent, reusable by any LLM, you can even start with one agent (for example `claude code`) and switch to `codex` if it doesn't solve a problem correctly.

You can have two sessions open with different agents as long as they are not modifying files at the same turn/time, you can work simultaneously, the important thing is that each agent adds its records to the recent context array of the logbook.
- Resulting file: `ai_files/logbooks/{logbookName}.json`
- Schema: `ai_files/schemas/logbook_schema.json`

**1.** Start work session with your agent: `claude`, `codex` or `gemini`.

**2.** Provide a prompt with ticket/story details to develop. _(Copy/Paste the content or connect MCP tool and paste the ticket URL to the agent)_.
- __Example prompt__:
```
(This is an example prompt) We will be working on creating a new endpoint so that frontend applications (web and mobile) can get product details, this is the schema we must comply with: ...[API technical content] ... and these are the ticket acceptance criteria: ...[Acceptance criteria]..., do you have any questions?
```

**3.** Track related code and plan work:
- Prompt _(Copy and paste in the conversation with your agent)_:
```
According to the ticket I shared with you, go to the code and trace files/classes/functions/methods/constants/tests related to the ticket. Use ai_files/project_manifest as a high-level initial guide. Then generate a list of actions to achieve the objective, order it in dependency resolution order first. Present it for review, adjustment and human confirmation.
```

**4.** Confirm plan _(human review)_:
- User adjusts the list, removing or adding details for clean execution prepared for the modifications in question.
- User requests to see the "confirmed" version of the action list. Confirms that the steps have a logical order.

**5.** Create logbook _(File name to be created must be indicated)_
- Prompt _(Adjust this prompt, copy and paste in the conversation with your agent)_:
```
Analyze the entire ai_files/schemas/logbook_schema.json file, then based on the action list that was reviewed and approved, create the logbook ai_files/logbooks/{fileName}.json fulfilling the semantic objective of each property of the schema. From now on you will be the moderator that keeps the logbook objectives updated, therefore, if you detect that a new objective appears (primary or secondary) add it or if any is completed, move it to its respective structure.
```

**6.** Every so often or progress _(Like saving progress in a video game)_:
- Prompt (iterative):
```
Based on the progress, findings and problems we have had, update the logbook according to the schema rules and create concise comments in the recent context, update the objectives and bring it up to date.
```

## When Finishing a Development Ticket/Story (Optional)

**Technical Resolution Comment**

It has become good practice to leave a rich summary of the work done to close each ticket, for this:

**1.** Creating the ticket resolution comment:
- File: Not applicable - A comment is delivered on screen.
- Schema: `ai_files/schemas/ticket_resolution_schema.json`
- Prompt _(Logbook name to analyze must be indicated)_:
```
Analyze the ai_files/schemas/ticket_resolution_schema.json file and based on the ai_files/logbooks/{logbookName}.json logbook create a resolution comment in Markdown format to copy and paste on the platform where we manage development tickets.
```

## ✅ Quick Validation
- Node (AJV): `npx ajv validate -s .ai_files/schemas/<schema>.json -d <data>.json`
- Python: `python -c "import json,sys,jsonschema as j; j.validate(json.load(open(sys.argv[2])), json.load(open(sys.argv[1])))" .ai_files/schemas/<schema>.json <data>.json`

## 🧩 Conventions
- IDs: `integer` with `minimum: 1`, stable once created.
- Times: `created_at` (UTC ISO 8601) immutable; `updated_at` (UTC) only when content changes.
- Respect `$comment`: prepend, limits, summaries, immutability.

## 📜 License
- Code and schemas: Apache-2.0 (see `LICENSE`).
- Documentation: you can opt for CC BY 4.0 if you separate the docs license.
