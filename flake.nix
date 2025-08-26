{
  description = "Nix for MacOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      sops-nix,
    }:
    let
      # Import configuration from well-known location
      configPath = "${builtins.getEnv "HOME"}/.config/nix/darwin-config.nix";

      # Require config file to exist - no defaults
      config =
        if builtins.pathExists configPath then
          import configPath
        else
          builtins.throw ''
            Configuration file not found at: ${configPath}

            Please create it with your machine-specific settings:

            mkdir -p ~/.config/nix
            cat > ~/.config/nix/darwin-config.nix << 'EOF'
            {
              username = "your-username";
              email = "your-email@example.com";  
              hostname = "your-hostname";
              system = "aarch64-darwin"; # or x86_64-darwin for Intel
            }
            EOF

            Or use the installer: curl -sSL https://raw.githubusercontent.com/Ecolier/dotfiles/main/install.sh | bash
          '';

      # Function to create a Darwin configuration
      mkDarwinConfiguration =
        {
          username,
          email,
          hostname,
          system,
        }:
        let
          specialArgs = inputs // {
            inherit username email hostname;
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system specialArgs;
          modules = [
            ./modules/apps.nix
            ./modules/core.nix
            ./modules/network.nix
            ./modules/system.nix
            ./modules/secrets.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${config.username} = import ./home;
            }
          ];
        };

      # Development shell packages
      pkgs = nixpkgs.legacyPackages.${config.system};
    in
    {
      devShells.${config.system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt-tree
        ];
      };

      darwinConfigurations.${config.hostname} = mkDarwinConfiguration config;
    };
}
