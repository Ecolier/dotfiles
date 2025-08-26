{ username, ... }:
{
  imports = [
    ./core.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./ssh.nix
    ./zsh.nix
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
