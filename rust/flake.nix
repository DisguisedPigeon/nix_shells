{
  description = "Rust dev flake by dpigeon";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devenv.url = "github:cachix/devenv";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
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
            packages = with pkgs; [ bacon ];

            languages = {
              rust.enable = true;
              nix.enable = true;
            };

            treefmt = {
              enable = true;
              config.programs = {
                rustfmt.enable = true;
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
              prod = pkgs.callPackage ./default.nix { inherit pname; };
            in
            {
              inherit prod;

              # Uses native inputs.
              #
              # This makes for a faster iteration
              # but it is less portable.
              dev = (pkgs.callPackage inputs.naersk { }).buildPackage {
                name = pname;
                src = ./.;
                buildInputs = [ ];
                nativeBuildInputs = with pkgs; [ pkg-config ];
              };

              default = prod;
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
