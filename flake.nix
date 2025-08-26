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
      # Define system configuration
      system = "aarch64-darwin";
      
      # Function to create a Darwin configuration
      mkDarwinConfiguration = { username, email, hostname }: 
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
              home-manager.users.${username} = import ./home;
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        "MacBook-Pro-de-Evan" = mkDarwinConfiguration {
          username = "ecolier";
          email = "evan.gruere@gmail.com"; 
          hostname = "MacBook-Pro-de-Evan";
        };
      };
    };
}
