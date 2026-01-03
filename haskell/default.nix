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
  haskellPackages,
  ocaml,
}:

haskellPackages.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  checkInputs = [ ];

  buildInputs = [ ];

  propagatedBuildInputs = [ ];

  # Check minimum ocaml version
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = { };
})
