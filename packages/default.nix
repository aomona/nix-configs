{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      wivrn = final.callPackage (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/vikingnope/nixpkgs/7d24905cd37a24ad9e811e068c0ca0e9ea23edbb/pkgs/by-name/wi/wivrn/package.nix";
        sha256 = "a71304059ad513a89d2b0c18deb24fcaf9c5ef17bb4dff55f475b98f0d5330ec";
      }) { };

      opencode = final.callPackage (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/r-ryantm/nixpkgs/b29c72fedde8dc0795c0e2a9a720ef1dd7d68f0c/pkgs/by-name/op/opencode/package.nix";
        sha256 = "194x6s45kcyjdcmbyba2cymw85ag4nqp3f7kw1s64wj736d02cwy";
      }) { };
    })
  ];
}
