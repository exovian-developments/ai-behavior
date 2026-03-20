#!/bin/bash
# waves installation script
# Created by Exovian Developments
# https://github.com/exovian-developments/waves

set -e

echo "🤖 waves installer"
echo "========================"
echo ""

# Check if we're in a project root
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: No .git directory found. Are you in your project root?"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p ai_files/{schemas,logbooks}

# Determine if we're running from local clone or need to download
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/schemas/logbook_software_schema.json" ]; then
    echo "📋 Copying schemas from local installation..."
    cp "$SCRIPT_DIR/schemas/"*.json ai_files/schemas/
else
    echo "📥 Downloading schemas from GitHub..."
    BASE_URL="https://raw.githubusercontent.com/exovian-developments/waves/main/schemas"
    for schema in logbook_software_schema.json software_manifest_schema.json project_rules_schema.json ticket_resolution_schema.json user_pref_schema.json; do
        echo "  - Downloading $schema..."
        curl -fsSL "$BASE_URL/$schema" -o "ai_files/schemas/$schema"
    done
fi

echo "✅ Schemas installed successfully"
echo ""

# Detect agent file
AGENT_FILE=""
if [ -f "CLAUDE.md" ]; then
    AGENT_FILE="CLAUDE.md"
elif [ -f ".claude/CLAUDE.md" ]; then
    AGENT_FILE=".claude/CLAUDE.md"
elif [ -f "AGENT.md" ]; then
    AGENT_FILE="AGENT.md"
elif [ -f "GEMINI.md" ]; then
    AGENT_FILE="GEMINI.md"
fi

# Inject or create agent configuration
if [ -n "$AGENT_FILE" ]; then
    # Check if already configured
    if grep -q "ai_files/project_manifest.json" "$AGENT_FILE" 2>/dev/null; then
        echo "⚠️  waves configuration already exists in $AGENT_FILE"
        echo "   Skipping agent file modification..."
    else
        echo "📝 Updating $AGENT_FILE with waves configuration..."
        cat >> "$AGENT_FILE" << 'EOF'

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

  - path: "ai_files/schemas/software_manifest_schema.json"
    description: "Json file with structure and guidance about how to create or update a project manifest"
    when: "when_user_ask"

  - path: "ai_files/schemas/project_rules_schema.json"
    description: "Json file with structure and guidance about how to create coding rules, standards and criterias"
    when: "when_user_ask"

  - path: "ai_files/schemas/logbook_software_schema.json"
    description: "Json file with structure and guidance about how to create a logbook to track and maintain conversational context for long-term memory and task tracking."
    when: "when_user_ask"

  - path: "ai_files/schemas/ticket_resolution_schema.json"
    description: "Json file with structure and guidance about how to create a summary of the resolution of the work done"
    when: "when_user_ask"

  - path: "ai_files/schemas/user_pref_schema.json"
    description: "Json file with structure and guidance about how to create a profile with guidance about how the interaction between the agent and the user"
    when: "when_user_ask"
EOF
        echo "✅ Updated $AGENT_FILE"
    fi
else
    echo "ℹ️  No agent file found (CLAUDE.md, AGENT.md, GEMINI.md)"
    echo ""
    echo "Which agent do you use?"
    echo "  1) Claude Code (will create CLAUDE.md)"
    echo "  2) Codex (will create AGENT.md)"
    echo "  3) Gemini (will create GEMINI.md)"
    echo "  4) None / I'll configure manually"
    read -p "Choose [1-4]: " choice

    case $choice in
        1) AGENT_FILE="CLAUDE.md" ;;
        2) AGENT_FILE="AGENT.md" ;;
        3) AGENT_FILE="GEMINI.md" ;;
        4)
            echo ""
            echo "✅ Setup complete!"
            echo "   Please manually add the required_reading section to your agent configuration."
            echo "   See documentation: https://github.com/exovian-developments/waves"
            exit 0
            ;;
        *)
            echo "Invalid choice. Skipping agent configuration."
            AGENT_FILE=""
            ;;
    esac

    if [ -n "$AGENT_FILE" ]; then
        echo "📝 Creating $AGENT_FILE..."
        cat > "$AGENT_FILE" << 'EOF'
# AI Agent Configuration
# Powered by waves protocol
# https://github.com/exovian-developments/waves

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

  - path: "ai_files/schemas/software_manifest_schema.json"
    description: "Json file with structure and guidance about how to create or update a project manifest"
    when: "when_user_ask"

  - path: "ai_files/schemas/project_rules_schema.json"
    description: "Json file with structure and guidance about how to create coding rules, standards and criterias"
    when: "when_user_ask"

  - path: "ai_files/schemas/logbook_software_schema.json"
    description: "Json file with structure and guidance about how to create a logbook to track and maintain conversational context for long-term memory and task tracking."
    when: "when_user_ask"

  - path: "ai_files/schemas/ticket_resolution_schema.json"
    description: "Json file with structure and guidance about how to create a summary of the resolution of the work done"
    when: "when_user_ask"

  - path: "ai_files/schemas/user_pref_schema.json"
    description: "Json file with structure and guidance about how to create a profile with guidance about how the interaction between the agent and the user"
    when: "when_user_ask"
EOF
        echo "✅ Created $AGENT_FILE"
    fi
fi

# Update .gitignore
if [ -f ".gitignore" ]; then
    if ! grep -q "ai_files/waves/" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# Waves delivery cycles (logbooks, resolutions — usually not committed)" >> .gitignore
        echo "ai_files/waves/" >> .gitignore
        echo "✅ Added ai_files/waves/ to .gitignore"
    else
        echo "ℹ️  ai_files/waves/ already in .gitignore"
    fi
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Create your user preferences:"
echo "   Tell your agent: 'Create ai_files/user_pref.json using ai_files/schemas/user_pref_schema.json'"
echo ""
echo "2. Generate project manifest:"
echo "   Tell your agent: 'Analyze the project and create ai_files/project_manifest.json'"
echo ""
echo "3. Generate project rules:"
echo "   Tell your agent: 'Create ai_files/project_rules.json for [layer] based on the schemas'"
echo ""
echo "📚 Documentation: https://github.com/exovian-developments/waves"
echo "🙏 Created by Exovian Developments"
echo ""
