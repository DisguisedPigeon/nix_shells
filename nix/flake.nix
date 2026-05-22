{
  description = "Nix dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devenv.url = "github:cachix/devenv";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = {
        devenv.shells.default = {
          languages.nix.enable = true;

          treefmt = {
            enable = true;
            config.programs = {
              nixfmt.enable = true;
              nixf-diagnose.enable = true;
              deadnix.enable = true;
              statix.enable = true;
            };
          };
        };
      };

      imports = [ inputs.devenv.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
