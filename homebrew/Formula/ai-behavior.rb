class AiBehavior < Formula
  desc "Structured context protocol for AI agents — Claude, Codex, Gemini CLI"
  homepage "https://github.com/exovian-developments/ai-behavior"
  url "https://github.com/exovian-developments/ai-behavior/archive/refs/tags/1.1.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "AGPL-3.0-or-later"

  def install
    # Install the CLI binary
    bin.install "bin/ai-behavior"

    # Install data files to share/ai-behavior/
    # The binary's get_data_dir() looks for:
    #   $(brew --prefix)/share/ai-behavior/schemas/
    #   $(brew --prefix)/share/ai-behavior/.claude/commands/
    data_dir = share/"ai-behavior"

    # Copy schemas
    data_dir.install "schemas"

    # Copy Claude commands (preserving .claude/commands/ structure)
    (data_dir/".claude"/"commands").mkpath
    Dir[".claude/commands/*.md"].each do |cmd|
      (data_dir/".claude"/"commands").install cmd
    end
  end

  def caveats
    <<~EOS
      ai-behavior has been installed!

      To set up a new project:
        cd your-project
        ai-behavior init claude

      To update an existing project:
        cd your-project
        ai-behavior update

      After initialization, start Claude Code and run:
        /ai-behavior:project-init

      Documentation: https://github.com/exovian-developments/ai-behavior
    EOS
  end

  test do
    assert_match "ai-behavior version #{version}", shell_output("#{bin}/ai-behavior --version")
  end
end
