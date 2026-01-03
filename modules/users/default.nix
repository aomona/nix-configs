{ pkgs, ... }:
{
  users.users.akazdayo = {
    isNormalUser = true;
    description = "akazdayo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrvifm9j0kjjoEUWf+QeFxQgdA9XPYc/VRyS9oPL+X5"
    ];
  };
}
