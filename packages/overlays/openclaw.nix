{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  SDL2_gfx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openclaw";
  version = "unstable-2022-07-13";

  src = fetchFromGitHub {
    owner = "pjasicek";
    repo = "OpenClaw";
    # Latest commit on master as of 2022-07-13
    # Update with: nix-prefetch-github --rev HEAD pjasicek OpenClaw
    rev = "5ee5740ca98377c76b13b50c84f610b0066a4717";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL2_gfx
  ];

  # Box2D 2.3.2, libwap, and tinyxml2 are bundled in the upstream source tree
  # and compiled as CMake subdirectories — no system packages needed for them.
  #
  # The upstream CMakeLists.txt does not use find_package(SDL2); it relies on
  # Nix stdenv's NIX_CFLAGS_COMPILE / NIX_LDFLAGS to expose buildInputs on the
  # compiler and linker search paths.

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/openclaw

    # The CMakeLists.txt sets CMAKE_RUNTIME_OUTPUT_DIRECTORY to ../Build_Release
    # relative to the cmake build directory.  Search the whole build tree.
    _bin=$(find "$NIX_BUILD_TOP" -name "ClawMain" -type f | head -1)
    if [ -z "$_bin" ]; then
      echo "ERROR: ClawMain binary not found after build" >&2
      exit 1
    fi
    install -m755 "$_bin" "$out/bin/openclaw"

    # Copy open-licensed game assets shipped in the source tree.
    # CLAW.REZ is copyrighted by Monolith Productions and must be supplied
    # by the user separately at runtime — it is NOT included here.
    cp -r "$src/Release/ASSETS" "$out/share/openclaw/ASSETS" 2>/dev/null || true
    cp "$src/Release/config.xml" "$out/share/openclaw/" 2>/dev/null || true
    cp "$src/Release/usercontrol.xml" "$out/share/openclaw/" 2>/dev/null || true

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source reimplementation of Captain Claw (1997) platformer";
    longDescription = ''
      OpenClaw is a multiplatform, open-source reimplementation of the original
      Captain Claw (1997) platformer game by Monolith Productions.

      The original CLAW.REZ game archive must be provided separately at runtime;
      it is copyrighted and not redistributable.
    '';
    homepage = "https://github.com/pjasicek/OpenClaw";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "openclaw";
  };
})
