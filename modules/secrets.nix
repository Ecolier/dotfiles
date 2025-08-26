{
  sops-nix,
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  secretsFile = ../secrets/secrets.yaml;
  secretsFileExists = builtins.pathExists secretsFile;
in
{
  # Import sops-nix module
  imports = [ sops-nix.darwinModules.sops ];

  # Install sops package
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  # Configure sops only if secrets file exists
  sops = lib.mkIf secretsFileExists {
    # Default format for secrets files
    defaultSopsFormat = "yaml";

    # Default sops file location
    defaultSopsFile = secretsFile;

    # Validate sops files at build time
    validateSopsFiles = false;

    # Location of the age key file
    age = {
      # Key file used for decrypting secrets
      keyFile = "/Users/${username}/.config/sops/age/keys.txt";
      # Generate the key if it doesn't exist
      generateKey = true;
    };

    # Define secrets that will be available to the system
    secrets = {
      # GitHub token for gh CLI
      "github/token" = {
        path = "/run/secrets/github-token";
        mode = "0400";
        owner = username;
        group = "staff";
      };

      # SSH private key for GitHub (optional, if you want to manage SSH keys with sops)
      "github/ssh-key" = {
        path = "/run/secrets/github-ssh-key";
        mode = "0400";
        owner = username;
        group = "staff";
      };
    };
  };
}
