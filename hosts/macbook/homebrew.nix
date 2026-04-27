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
    brews = [ ];
    casks = [ ];
    masApps = { };
  };
}
