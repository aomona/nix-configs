{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    #configFile.source = ../../dotfiles/config.nu;
    #envFile.source = ../../dotfiles/env.nu;
    extraConfig = ''
      ${builtins.readFile ../../dotfiles/config.nu}
    '';
    extraEnv = ''
      ${builtins.readFile ../../dotfiles/env.nu}
    '';
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
    package = pkgs.direnv.overrideAttrs (_: {
      doCheck = false;
    });
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushell}/bin/nu";
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.fzf = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.ripgrep-all = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
}
