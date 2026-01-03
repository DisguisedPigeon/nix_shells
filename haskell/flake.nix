{
  description = "Haskell dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          treefmt.programs = {
            nixfmt.enable = true;
            deadnix.enable = true;
            nixf-diagnose.enable = true;
            ocamlformat.enable = true;
          };

          packages = rec {
            default = prod;
            prod = pkgs.callPackage ((import ./default.nix) {
              pname = throw "You have to fill in the package name, under outputs.perSystem.packages.prod";
            }) { };

            dev = prod;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              watchexec
            ];
          };
        };
    };
}
