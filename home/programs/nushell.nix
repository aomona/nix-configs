{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    configFile.source = ../../dotfiles/config.nu;
    envFile.source = ../../dotfiles/config.nu;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
