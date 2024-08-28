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
        commonPackages = with pkgs; [
          elmPackages.elm
          just
          nodePackages.pnpm
          nodePackages.prettier
          nodePackages.uglify-js
          nodejs-slim_22
        ];
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs =
              commonPackages
              ++ (with pkgs; [
                act
              ]);
          };

          ci = pkgs.mkShell {buildInputs = commonPackages;};
        };
      }
    );
}
