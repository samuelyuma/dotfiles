{
  description = "yumx's system configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      formatter.aarch64-darwin = pkgs.nixfmt;

      devShells.aarch64-darwin.default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixfmt ];
      };
    };
}
