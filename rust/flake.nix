{
  description = "Ocaml dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };

    naersk = {
      url = "github:nix-community/naersk";
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
        { pkgs, ... }:
        {
          treefmt.programs = {
            nixfmt.enable = true;
            deadnix.enable = true;
            nixf-diagnose.enable = true;
            rustfmt.enable = true;
          };

          packages =
            let
              naerskLib = pkgs.callPackage inputs.naersk { };
            in
            rec {
              default = prod;
              prod = pkgs.callPackage ((import ./default.nix) {
                pname = throw "You have to fill in the package name, under outputs.perSystem.packages.prod";
              }) { };

              # If there's some way of caching deps,
              # change this in place and use it
              dev = naerskLib.buildPackage {
                name = "rust-wea";
                src = ../.;
                buildInputs = [ ];
                nativeBuildInputs = with pkgs; [ pkg-config ];
              };
            };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              watchexec

              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
            ];
            nativeBuildInputs = with pkgs; [ pkg-config ];

            env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          };
        };
    };
}
