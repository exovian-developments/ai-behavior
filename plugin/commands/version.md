---
description: Show the installed Waves plugin version (and this project's applied artifact version)
allowed-tools: Read, Bash
---

# /waves:version — Show Waves version

Report the installed Waves **plugin** (framework) version and, if present, the **project's** applied artifact version. This helps confirm which framework version is actually loaded — useful after `/plugin install` or `/plugin update`.

## Steps

1. Read the plugin version from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` → `.version`. This is the framework version currently installed/loaded.
2. If `ai_files/.waves-version` exists in the current project (cwd), read it — this is the framework version this project's artifacts are aligned to (written by `/waves:upgrade` or `/waves:migrate-from-v2-to-v3`).
3. Display concisely (no other side effects):

```
Waves plugin (framework): v<plugin_version>
```

   - IF `ai_files/.waves-version` exists:
     ```
     This project's artifacts: v<project_version>
     ```
     - IF `project_version` != `plugin_version`:
       ```
       ⚠️ Artifacts are behind the plugin. Run /waves:upgrade to align this project to v<plugin_version>.
       ```
   - IF `ai_files/.waves-version` does NOT exist:
     ```
     This project has no .waves-version marker — it has not been initialized or migrated for Waves 3.0+.
     (If it is a 2.x project, install the plugin and run /waves:migrate-from-v2-to-v3 once.)
     ```

Keep the output to a few lines. Do not read or modify anything else.
