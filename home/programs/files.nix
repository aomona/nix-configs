{...}: {
  home.file = {
    ".bashrc".source = ../../dotfiles/bashrc;
    ".bash_profile".source = ../../dotfiles/bash_profile;
    ".config/zed/settings.json".source = ../../dotfiles/zed_settings.json;
    ".config/git/ignore".source = ../../dotfiles/gitignore;
    ".config/swaylock/config".source = ../../dotfiles/swaylock_config;
  };
}
