{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
}:
buildDotnetGlobalTool {
  pname = "vpm-cli";
  nugetName = "VRChat.VPM.CLI";
  version = "0.1.28";
  executables = "vpm";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetHash = "sha256-Pz8KBpjmpzx+6gD4nqGVBEp5z4UX6hFqZHGy8hJCD4k=";

  meta = {
    description = "VRChat Package Manager CLI";
    homepage = "https://vcc.docs.vrchat.com/vpm/cli/";
    license = lib.licenses.unfree;
    mainProgram = "vpm";
    platforms = lib.platforms.linux;
  };
}
