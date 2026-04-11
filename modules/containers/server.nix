{ ... }:
{
  imports = [
    ./adguard-home.nix
    ./nextcloud.nix
    ./openclaw.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
