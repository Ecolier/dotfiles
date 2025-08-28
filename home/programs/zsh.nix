{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # Load sensitive environment variables from a separate file
      if [[ -f ~/.config/secrets/env ]]; then
        source ~/.config/secrets/env
      fi
    '';
  };
}
