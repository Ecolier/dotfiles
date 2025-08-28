{ username, pkgs, ... }:
{
  imports = [
    ./programs
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    jq
    direnv
  ];
}
