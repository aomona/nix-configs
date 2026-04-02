{ ... }:
{
  imports = [
    ./adguard-home.nix
    ./nextcloud.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
