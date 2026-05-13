{ ... }:
{
  imports = [
    ./immich.nix
    ./nextcloud.nix
    ./pihole-unbound.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
