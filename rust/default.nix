# Parameters for the builder.
# I will probably migrate to using callPackage's second arg.
{
  pname,
  name ? pname,
  src ? ./.,
}:
{ rustPlatform, pkg-config }:
rustPlatform.buildRustPackage {
  inherit name src;
  buildInputs = [ ];

  # For native dependency linking
  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  meta = { };
}
