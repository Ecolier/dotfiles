{
  hostname,
  username,
  ...
}:
{
  imports = [
    ./apps.nix
    ./os.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true; # enable touch id for sudo
  nix.enable = false;

  users.users = {
    "${username}" = {
      home = "/Users/${username}";
      description = username;
    };
  };

  system.stateVersion = 6;
  system.primaryUser = username;

  nix.settings.trusted-users = [ username ];
}
