{ ... }:
let
  #alvrFlatpakrefPath = builtins.path {
  #  path = ./alvr.flatpakref;
  #  name = "alvr.flatpakref";
  #};
  #alvrFlatpakrefUrl = "file://${builtins.elemAt (builtins.match "(.*)" (toString alvrFlatpakrefPath)) 0}";
in
{
  services.flatpak = {
    enable = true;
    packages = [
      "org.gnome.Snapshot"
      #{
      #  flatpakref = alvrFlatpakrefUrl;
      #  sha256 = "sha256-lmO9lnguAZ9G6iI4Dq6h93D6aLMo3QqFJBlCCbFGPPk=";
      #}
    ];
  };
}
