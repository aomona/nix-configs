{ ... }:
{
  imports = [
    ./core.nix
    ./desktop.nix
    ./development.nix
    ./media.nix
    ./wayland.nix
    ./gaming.nix
    ./llm.nix
    ./server.nix
    ./darwin.nix
  ];
}
