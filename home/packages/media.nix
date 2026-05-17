{ pkgs, pkgs-unstable, ... }:
{
  home.packages =
    (with pkgs; [
      gimp
      kooha
      yt-dlp
      ffmpeg
      vlc
    ])
    ++ (with pkgs-unstable; [
      spotify
    ]);
}
