{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vrcli";
  version = "0.1.1";

  src = fetchCrate {
    pname = "vrcli";
    inherit (finalAttrs) version;
    hash = "sha256-bml7irSRjfsC4KDO/yPTV0YVCwhkQQGmPD+0tUJvPhc=";
  };

  cargoHash = "sha256-+6in3Ni9eYEKm15L5tpCGHQ76f8fH1VrzhYfxpY88Rk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = {
    description = "VRChat API terminal client";
    homepage = "https://github.com/vrcli/vrcli";
    license = lib.licenses.mit;
    mainProgram = "vrcli";
    platforms = lib.platforms.linux;
  };
})
