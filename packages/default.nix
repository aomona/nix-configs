{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      wivrn = final.callPackage (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/vikingnope/nixpkgs/7d24905cd37a24ad9e811e068c0ca0e9ea23edbb/pkgs/by-name/wi/wivrn/package.nix";
        sha256 = "a71304059ad513a89d2b0c18deb24fcaf9c5ef17bb4dff55f475b98f0d5330ec";
      }) { };
    })
  ];
}
