{pkgs, ...}: {
  users.users.akazdayo = {
    isNormalUser = true;
    description = "akazdayo";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.nushell;
  };
}
