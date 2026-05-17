{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    cloudflared
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
