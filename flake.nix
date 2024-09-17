{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {system = system;};
        commonPackages = [
          pkgs.elmPackages.elm
          pkgs.just
          pkgs.nodePackages.pnpm
          pkgs.nodePackages.prettier
          pkgs.nodePackages.uglify-js
          pkgs.nodejs-slim_22
        ];
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs =
              commonPackages
              ++ [
                pkgs.act
              ];
          };

          ci = pkgs.mkShell {buildInputs = commonPackages;};
        };
      }
    );
}
