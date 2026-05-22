{
  description = "Ocaml dev flake";

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
      perSystem =
        { pkgs, ... }:
        {
          devenv.shells.default = {
            pakages = with pkgs; [ watchexec ];

            languages = {
              ocaml.enable = true;
              nix.enable = true;
            };

            treefmt = {
              enable = true;
              config.programs = {
                ocamlformat.enable = true;
                nixfmt.enable = true;
              };
            };
          };

          packages =
            let
              pname = throw ''
                	      You have to fill in the package name
                              (outputs.perSystem.packages, pname parameter)
                	    '';
            in
            {
              default = pkgs.callPackage ./default.nix { inherit pname; };
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
