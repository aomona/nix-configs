{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages =
    (with pkgs; [
      # Nix ツール
      comma
      vim
      nixd
      nil
      alejandra
      nixfmt

      # シェルユーティリティ
      starship
      fastfetch
      tree
      jq
      wget
      lazygit
      gh
      btop

      # ネットワーク
      tailscale
      wireguard-tools
    ]);
}
