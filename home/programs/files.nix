{ pkgs, lib, ... }:
{
  home.file = {
    ".bashrc".source = ../../dotfiles/bashrc;
    ".bash_profile".source = ../../dotfiles/bash_profile;
    #".config/zed/settings.json".source = ../../dotfiles/zed_settings.json;
    ".config/git/ignore".source = ../../dotfiles/gitignore;
    ".config/swaylock/config".source = ../../dotfiles/swaylock_config;
    ".config/starship.toml".source = pkgs.fetchurl {
      url = "https://starship.rs/presets/toml/catppuccin-powerline.toml";
      sha256 = "sha256-z4gMhCgYllOHgYTwn7mIo5WzVQZqt7RsHibmu0D/qC0=";
    };
  };
}
