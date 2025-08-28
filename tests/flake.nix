{
  description = "Test darwin configuration";

  inputs = {
    dotfiles.url = "path:..";
    nixpkgs.follows = "dotfiles/nixpkgs";
  };

  outputs =
    {
      self,
      dotfiles,
      nixpkgs,
      ...
    }:
    let
      username = "test";
      email = "test@example.com";
      hostname = "test";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."test" = dotfiles.darwinSystem {
        inherit
          username
          email
          hostname
          system
          ;
      };
    };

}
