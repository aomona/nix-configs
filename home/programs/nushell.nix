{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    configFile.source = ../../dotfiles/config.nu;
    envFile.source = ../../dotfiles/env.nu;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {

    };
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushell}/bin/nu";
  };
}
