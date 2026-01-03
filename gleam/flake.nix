{
  description = "Gleam dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    gleam2nix = {
      url = "git+https://git.isincredibly.gay/srxl/gleam2nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
        { pkgs, lib, ... }:
        {
          treefmt.programs = {
            nixfmt.enable = true;
            deadnix.enable = true;
            nixf-diagnose.enable = true;
            gleam.enable = true;

            # erlfmt.enable = true;
            # mix-format.enable = true;
            # prettier.enable = true;
          };

          packages = rec {
            default = prod;
            prod = pkgs.callPackage ((import ./default.nix) {
              pname = throw "You have to fill in the package name. Remember running gleam2nix too.";
            }) { gleam2nix = inputs.gleam2nix; };

            dev = prod;
          };

          devShells.default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                watchexec

                gleam

                beamMinimal27Packages.erlang
                beamMinimal27Packages.rebar3
                beamMinimal27Packages.erlfmt
                erlang-language-platform

                gitmoji-cli
              ]
              ++ lib.optional stdenv.isLinux inotify-tools;
          };
        };
    };
}
