{ config, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "vim";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  # Create a script to authenticate gh CLI with sops token
  home.file.".local/bin/gh-auth-sops" = {
    text = ''
      #!/usr/bin/env bash
      # Authenticate gh CLI using token from sops
      if [ -f /run/secrets/github-token ]; then
        export GITHUB_TOKEN=$(cat /run/secrets/github-token)
        gh auth login --with-token <<< "$GITHUB_TOKEN"
        echo "✅ GitHub CLI authenticated using sops token"
      else
        echo "❌ GitHub token not found in /run/secrets/github-token"
        echo "Make sure sops secrets are properly configured and the system is rebuilt"
        exit 1
      fi
    '';
    executable = true;
  };

  # Set up environment to use the token from sops
  home.sessionVariables = {
    # This will make gh CLI use the token automatically
    GITHUB_TOKEN = "$(test -f /run/secrets/github-token && cat /run/secrets/github-token)";
  };
}
