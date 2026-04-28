{
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings =
      {
        user = {
          name = "akazdayo";
          email = "82073147+akazdayo@users.noreply.github.com";
        };
        init = {
          defaultBranch = "main";
        };
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        core = {
          sshCommand = "/opt/homebrew/bin/ssh";
        };
      };
  };
}
