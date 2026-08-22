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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      git-hooks,
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      localChecks = git-hooks.lib.aarch64-darwin.run {
        src = ./.;

        hooks = {
          nixfmt = {
            enable = true;
            entry = "${pkgs.nixfmt-tree}/bin/treefmt --ci";
            files = "\\.nix$";
            pass_filenames = false;
          };

          statix = {
            enable = true;
            entry = "${pkgs.statix}/bin/statix check .";
            files = "\\.nix$";
            pass_filenames = false;
          };

          deadnix = {
            enable = true;
            entry = "${pkgs.deadnix}/bin/deadnix .";
            files = "\\.nix$";
            pass_filenames = false;
          };

          flake-check = {
            enable = true;
            name = "nix flake check";
            entry = "${pkgs.nix}/bin/nix flake check --no-update-lock-file --print-build-logs";
            always_run = true;
            pass_filenames = false;
            stages = [ "pre-push" ];
          };
        };
      };
      activate = pkgs.writeShellScriptBin "activate" ''
        exec /usr/bin/sudo /usr/bin/env \
          HOME=/var/root \
          PATH=/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH \
          ${nix-darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild \
          switch --flake "${self.outPath}#darwin"
      '';
    in
    {
      formatter.aarch64-darwin = pkgs.nixfmt-tree;

      packages.aarch64-darwin.activate = activate;

      apps.aarch64-darwin.activate = {
        type = "app";
        program = "${activate}/bin/activate";
      };

      checks.aarch64-darwin = {
        darwin = self.darwinConfigurations.darwin.system;
        hooks = localChecks;
      };

      devShells.aarch64-darwin.default = pkgs.mkShellNoCC {
        inherit (localChecks) shellHook;

        packages = with pkgs; [
          deadnix
          nixfmt-tree
          statix
        ];
      };

      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./configurations/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              backupFileExtension = "hm-backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.yumx = import ./modules/home;
            };
          }
        ];
      };
    };
}
