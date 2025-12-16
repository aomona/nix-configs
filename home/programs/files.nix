{ ... }:
{
  home.file = {
    ".bashrc".source = ../../dotfiles/bashrc;
    ".bash_profile".source = ../../dotfiles/bash_profile;
    ".config/nushell/config.nu".source = ../../dotfiles/config.nu;
    ".config/nushell/env.nu".source = ../../dotfiles/env.nu;
    ".config/zed/settings.json".source = ../../dotfiles/zed_settings.json;
    ".config/git/ignore".source = ../../dotfiles/gitignore;
    ".config/swaylock/config".source = ../../dotfiles/swaylock_config;
  };
}
