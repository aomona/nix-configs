# home/programs/vr.nix
{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn.override {cudaSupport = true;}}/share/openxr/1/openxr_wivrn.json";

  xdg.configFile."openvr/openvrpaths.vrpath" = {
    force = true;
    text = ''
      {
        "config" : [ "${config.xdg.dataHome}/Steam/config" ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" : [ "${config.xdg.dataHome}/Steam/logs" ],
        "runtime" : [ "${pkgs.opencomposite}/lib/opencomposite" ],
        "version" : 1
      }
    '';
  };
}
