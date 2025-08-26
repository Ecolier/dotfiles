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
      username = builtins.getEnv "NIX_USERNAME";
      email = builtins.getEnv "NIX_EMAIL";
      system = builtins.getEnv "NIX_SYSTEM";
      hostname = builtins.getEnv "NIX_HOSTNAME";

      specialArgs = inputs // {
        inherit username email hostname;
      };
    in
    {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
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
    };
}
