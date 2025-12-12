{ pkgs, ... }:
let
  myCursor = pkgs.callPackage ../../cursors/milk.nix {};
in
{
  home.pointerCursor = {
    package = myCursor;
    name = "MilkCursor"; # index.themeに書いたNameと一致させる
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
