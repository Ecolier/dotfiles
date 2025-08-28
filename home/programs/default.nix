{ ... }:
{
  imports = [
    ./kitty
    ./direnv.nix
    ./git.nix
    ./ssh.nix
    ./zsh.nix
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    skim = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  programs.home-manager.enable = true;
}
