# Parameters for the builder.
# I will probably migrate to using callPackage's second arg.
{
  pname,
  name ? pname,
  version ? "0.0.0",
  src ? ./.,
}:
{
  lib,
  ocamlPackages,
  buildDunePackage ? ocamlPackages.buildDunePackage,
  ocaml,
}:

buildDunePackage (finalAttrs: {
  inherit
    name
    version
    src
    pname
    ;

  checkInputs = [ ];

  buildInputs = [ ];

  propagatedBuildInputs = [ ];

  # Check minimum ocaml version
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = { };
})
