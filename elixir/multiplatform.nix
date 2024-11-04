{
  description = "Elixir dev shell for all supported systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { systems, nixpkgs, ... }:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            (
              [
                elixir-ls
                elixir
              ]
              ++ lib.optional stdenv.isLinux inotify-tools
            );
        };
      });
    };
}
