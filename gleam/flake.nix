{
  description = "Gleam dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devenv.url = "github:cachix/devenv";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gleam2nix = {
      url = "git+https://git.isincredibly.gay/srxl/gleam2nix";
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
            packages = with pkgs; [ watchexec inputs.gleam2nix.gleam2nix ];

            languages = {
              gleam.enable = true;
              nix.enable = true;
            };

            treefmt = {
              enable = true;
              config.programs = {
                gleam.enable = true;
                nixfmt.enable = true;
              };
            };

            # # Erlang support (language comes with gleam)
            # treefmt.config.programs.erlfmt.enable = true;

            # # Elixir support
            # languages.elixir.enable = true;
            # treefmt.config.programs.mix-format.enable = true;

            # # Javascript support
            # languages.javascript.enable = true;
            # treefmt.config.programs.prettier.enable = true;
          };

          packages =
            let
              pname = throw ''
                	      You have to fill in the package name
                              (outputs.perSystem.packages, pname parameter)
			      Remember runnning gleam2nix as well
                	    '';
            in
            {
              default = pkgs.callPackage ./default.nix {
                inherit pname;
                inherit (inputs) gleam2nix;
              };
            };
        };
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
