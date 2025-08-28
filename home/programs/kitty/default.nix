{ pkgs, lib, ... }:
let
  setKittyIcon = pkgs.writeShellScript "set-kitty-icon" ''
    export PATH=${
      pkgs.lib.makeBinPath [
        pkgs.curl
      ]
    }:$PATH
    ${builtins.readFile ./scripts/set-icon.sh}
  '';
in
{
  home.activation.setKittyIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${setKittyIcon}
  '';

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      # Custom icon (you'll need to place the icon file in the right location)
      # macos_custom_beam_cursor = "yes";

      # Theme and appearance
      background_opacity = "0.95";
      window_padding_width = 8;

      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
    };
    keybindings = {
      "cmd+t" = "new_tab";
      "cmd+w" = "close_tab";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
    };
  };
}
