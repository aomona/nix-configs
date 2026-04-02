{ ... }:
{
  imports = [
    # Add container service modules here, e.g.:
    # ./jellyfin.nix
    # ./nextcloud.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
