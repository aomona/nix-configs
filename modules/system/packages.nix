{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
