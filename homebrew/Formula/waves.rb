class Waves < Formula
  desc "Structured context protocol for AI agents — Claude, Codex, Gemini CLI"
  homepage "https://github.com/exovian-developments/waves"
  url "https://github.com/exovian-developments/waves/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "f49e452138766984434a0cb608091fd06bbf831cb11abca0f6e9e355c8115b06"
  license "AGPL-3.0-or-later"

  def install
    # Install the CLI binary
    bin.install "bin/waves"

    # Install data files to share/waves/
    # The binary's get_data_dir() looks for:
    #   $(brew --prefix)/share/waves/schemas/
    #   $(brew --prefix)/share/waves/.claude/commands/
    data_dir = share/"waves"

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
      waves has been installed!

      To set up a new project:
        cd your-project
        waves init claude

      To update an existing project:
        cd your-project
        waves update

      After initialization, start Claude Code and run:
        /waves:project-init

      Documentation: https://github.com/exovian-developments/waves
    EOS
  end

  test do
    assert_match "waves version #{version}", shell_output("#{bin}/waves --version")
  end
end
