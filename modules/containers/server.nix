{ ... }:
{
  imports = [
    ./adguard-home.nix
    ./immich.nix
    ./nextcloud.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
