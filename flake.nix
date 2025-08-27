{
  description = "Base darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    {
      darwinSystem =
        {
          system,
          hostname,
          username,
          email,
          modules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
          modules = [
            (
              { ... }:
              {
                imports = [
                  home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = { inherit username email hostname; };
                    home-manager.users.${username} = import ./home;
                  }
                ];
              }
            )
            (import ./modules { inherit hostname username; })
          ]
          ++ modules;
        };
    };
}
