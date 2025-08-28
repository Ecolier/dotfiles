{ pkgs, ... }:
{

  system.defaults = {

    dock = {
      autohide = true;
      show-recents = false; # disable recent apps
    };

    finder = {
      _FXShowPosixPathInTitle = true; # show full path in finder title
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true; # enable tap to click
      TrackpadRightClick = true; # enable two finger right click
      TrackpadThreeFingerDrag = true; # enable three finger drag
    };
  };

  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];
  };
}
