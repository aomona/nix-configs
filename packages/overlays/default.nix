{ ... }:
let
  entries = builtins.readDir ./.;
  overlayFiles = builtins.filter (
    name:
    name != "default.nix" && entries.${name} == "regular" && builtins.match ".*\\.nix" name != null
  ) (builtins.attrNames entries);

  # Each .nix file is a callPackage-compatible function (nixpkgs by-name style).
  # Wrap each into an overlay that calls final.callPackage on it.
  fileToOverlay =
    name: final: prev:
    let
      pname = builtins.replaceStrings [ ".nix" ] [ "" ] name;
    in
    {
      ${pname} = final.callPackage (./. + "/${name}") { };
    };
in
{
  nixpkgs.overlays = builtins.map fileToOverlay overlayFiles;
}
