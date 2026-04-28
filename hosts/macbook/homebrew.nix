{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [ ];
    brews = [ "openssh" "libfido2" ];
    casks = [ 
      "vesktop"
      "orbstack"
      "spotify"
      "ghostty"
    ];
    masApps = { };
  };
}
