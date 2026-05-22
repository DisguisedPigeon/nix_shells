{
  pname,
  name ? pname,
  version ? "0.0.0",
  src ? ./.,

  lib,
  versionAtLeast ? lib.versionAtLeast,

  ocaml,
  ocamlPackages,
  buildDunePackage ? ocamlPackages.buildDunePackage,
}:
buildDunePackage (_: {
  inherit
    pname
    name
    version
    src
    ;

  checkInputs = [ ];
  buildInputs = [ ];
  propagatedBuildInputs = [ ];

  doCheck = versionAtLeast ocaml.version "4.05";

  meta = { };
})
