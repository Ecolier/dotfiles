{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    colima
    docker
    nixfmt-rfc-style
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

    brews = [
      "httpie"
    ];

    masApps = {
      # Xcode = 497799835;
    };

    casks = [
      "firefox@developer-edition"
      "visual-studio-code@insiders"
      "iina"
      "discord"
      "stats"
      "insomnia"
      "wireshark-app"
    ];
  };

}
