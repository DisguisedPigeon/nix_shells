{
  description = "Elixir dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devenv.url = "github:cachix/devenv";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, ... }:
        {
          devenv.shells.default = {
            packages = with pkgs; [ watchexec ];

            languages = {
              elixir.enable = true;
              nix.enable = true;
            };

            treefmt = {
              enable = true;
              config.programs = {
                mix-format.enable = true;
                nixfmt.enable = true;
              };
            };

            # # Erlang support (language comes with gleam)
            # languages.erlang.enable = true;
            # treefmt.config.programs.erlfmt.enable = true;
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
