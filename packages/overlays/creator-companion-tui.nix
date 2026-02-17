final: prev:
let
  packageName = "creator-companion-tui";

  packageFn =
    {
      lib,
      rustPlatform,
      fetchFromGitHub,
    }:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = packageName;
      version = "0.1.0";

      src = fetchFromGitHub {
        owner = "m-shintaro";
        repo = "Creator-Companion-TUI";
        rev = "ebf23d2c7973f94eefd6e229c065881951bd353e";
        hash = "sha256-Y7ATLcr4GFOHcfhkX6Kn5krBL62ojGLlspIWV9I0xlU=";
      };

      cargoHash = "sha256-Z/EizPp0pzXwoh42WDtXgw2f6W9EoeRBh06DxeGLGlU=";

      doCheck = false;

      meta = {
        description = "Creator Companion TUI - VRChat Creator Companion terminal interface";
        homepage = "https://github.com/m-shintaro/Creator-Companion-TUI";
        license = lib.licenses.mit;
        mainProgram = "vcc-tui";
        platforms = lib.platforms.linux;
      };
    });
in
{
  ${packageName} = final.callPackage packageFn { };
}
