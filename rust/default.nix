{
  pname,
  name ? pname,
  src ? ./.,

  pkg-config,

  rustPlatform,
}:
rustPlatform.buildRustPackage {
  inherit name src;
  buildInputs = [ ];

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  meta = { };
}
