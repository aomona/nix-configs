{ ... }:
{
  imports = [
    ./adguard-home.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}
