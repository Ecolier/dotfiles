{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    colima
    docker
    neovim
    nodejs # LTS version for tools (VSCode, etc.)
    git
  ];

  environment.variables.EDITOR = "nvim";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      "firefox@developer-edition"
      "visual-studio-code@insiders"
    ];
  };

}
