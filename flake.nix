{
  description = "yumx's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      activate = pkgs.writeShellScriptBin "activate" ''
        exec /usr/bin/sudo /usr/bin/env \
          HOME=/var/root \
          PATH=/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH \
          ${nix-darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild \
          switch --flake "$PWD#darwin"
      '';
    in
    {
      formatter.aarch64-darwin = pkgs.nixfmt-tree;

      packages.aarch64-darwin.activate = activate;

      apps.aarch64-darwin.activate = {
        type = "app";
        program = "${activate}/bin/activate";
      };

      devShells.aarch64-darwin.default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixfmt-tree ];
      };

      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./configurations/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "hm-backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yumx = import ./modules/home;
          }
        ];
      };
    };
}
