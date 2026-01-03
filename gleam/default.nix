{
  pname,
  version ? "0.0.0",
  src ? ./.,
}:
{ gleam2nix }:
gleam2nix.buildGleamApplication {
  inherit pname version src;
  gleamNix = import ./gleam.nix;
}
