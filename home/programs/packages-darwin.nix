{ pkgs, pkgs-with-llm-agents, ... }:
{
  home.packages =
    (with pkgs; [
      # Nix tools
      comma
      vim
      nixd
      nil
      alejandra
      nixfmt

      # Shell utilities
      starship
      fastfetch
      tree
      jq
      wget
      lazygit
      gh
      btop

      # Network tools
      tailscale
      wireguard-tools
    ])
    ++ (with pkgs-with-llm-agents.llm-agents; [
      opencode
      codex
      claude-code
    ]);
}
