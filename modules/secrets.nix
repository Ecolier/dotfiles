{ inputs, config, pkgs, lib, ... }:

{
  # Import sops-nix module
  imports = [ inputs.sops-nix.darwinModules.sops ];

  # Install sops package
  environment.systemPackages = with pkgs; [ sops age ];

  # Configure sops
  sops = {
    # Default format for secrets files
    defaultSopsFormat = "yaml";
    
    # Validate sops files at build time
    validateSopsFiles = false;
    
    # Location of the age key file
    age = {
      # Key file used for decrypting secrets
      keyFile = "/Users/${builtins.getEnv "NIX_USERNAME"}/.config/sops/age/keys.txt";
      # Generate the key if it doesn't exist
      generateKey = true;
    };

    # Define secrets that will be available to the system
    secrets = {
      # GitHub token for gh CLI
      "github/token" = {
        path = "/run/secrets/github-token";
        mode = "0400";
        owner = builtins.getEnv "NIX_USERNAME";
        group = "staff";
      };
      
      # SSH private key for GitHub (optional, if you want to manage SSH keys with sops)
      "github/ssh-key" = {
        path = "/run/secrets/github-ssh-key";
        mode = "0400";
        owner = builtins.getEnv "NIX_USERNAME";
        group = "staff";
      };
    };
  };
}