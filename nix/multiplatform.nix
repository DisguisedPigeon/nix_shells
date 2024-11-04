{
  description = "Nix dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      systems,
      nixpkgs,
      ...
    }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pkgs.nixd
            pkgs.nixfmt-rfc-style
          ];
        };
      });
      formatter = eachSystem (pkgs: pkgs.nixfmt-rfc-style);
    };
}
