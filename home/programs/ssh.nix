{pkgs, lib, ...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "192.168.11.50" = {
        user = "akazdayo";
        identityFile = "~/.ssh/id_ed25519_sk_rk";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk_rk";
        identitiesOnly = true;
      };
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      "*" = lib.hm.dag.entryAfter [ "github.com" ] {
        identityFile = "~/.ssh/id_ed25519_sk_rk";
      };
    };
  };
}
