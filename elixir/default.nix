{
  pname,
  name ? pname,
  version ? "0.0.0",
  src ? ./.,
}:
{ beamPackages }:
beamPackages.buildMix {
  inherit
    pname
    name
    version
    src
    ;

  beamDeps =
    # with beamPackages.;
    [
    ];
}
