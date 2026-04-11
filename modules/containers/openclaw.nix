{ pkgs, lib, ... }:
let
  # Debian GNU/Linux 12 (bookworm) identity files.
  # These make the container self-describe as Debian while using Nix-packaged
  # runtime libraries for full reproducibility (no apt, no network at build time).
  debianBaseFiles = pkgs.runCommand "debian-base-files" { } ''
    mkdir -p $out/etc

    echo "12" > $out/etc/debian_version

    cat > $out/etc/os-release <<'EOF'
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
EOF

    # Minimal passwd / group expected by many runtime tools
    cat > $out/etc/passwd <<'EOF'
root:x:0:0:root:/root:/bin/sh
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
EOF

    cat > $out/etc/group <<'EOF'
root:x:0:
nobody:x:65534:
EOF
  '';

  # Docker image built entirely with pkgs.dockerTools.buildImage.
  #
  # The image contains:
  #   - pkgs.openclaw   — the game engine binary (CLAW.REZ not included)
  #   - SDL2 runtime libraries (same ABI as Debian's libsdl2-* packages)
  #   - bashInteractive + coreutils for interactive debugging
  #   - Debian OS-identification files in /etc
  #
  # The full Nix closure (SDL2, glibc, …) is embedded in /nix/store/ inside
  # the image layers; the openclaw binary's RPATH resolves them automatically.
  openclawImage = pkgs.dockerTools.buildImage {
    name = "openclaw";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "openclaw-env";
      paths = [
        debianBaseFiles
        pkgs.openclaw
        pkgs.SDL2
        pkgs.SDL2_image
        pkgs.SDL2_mixer
        pkgs.SDL2_ttf
        pkgs.SDL2_gfx
        pkgs.bashInteractive
        pkgs.coreutils
      ];
      pathsToLink = [ "/bin" "/share" "/etc" ];
    };

    config = {
      # Game binary entry point
      Cmd = [ "/bin/openclaw" ];

      # The container expects CLAW.REZ (and optionally other game files) to be
      # bind-mounted at /data.  See the volumes configuration below.
      WorkingDir = "/data";

      Env = [
        "DISPLAY=:0"
        "SDL_VIDEODRIVER=x11"
        "HOME=/root"
        # timidity can be pointed at the host's sound font if MIDI is desired:
        # "TIMIDITY_CFG=/data/timidity.cfg"
      ];
    };
  };
in
{
  # Ensure the host-side game-data directory exists.
  # Place CLAW.REZ (and optionally other Release/ files) here before starting
  # the container.
  systemd.tmpfiles.rules = [
    "d /var/lib/openclaw 0755 root root -"
  ];

  virtualisation.oci-containers.containers.openclaw = {
    image = "openclaw:latest";

    # imageFile tells NixOS to load this Nix-built tarball into Docker before
    # starting the container — no manual docker pull required.
    imageFile = openclawImage;

    volumes = [
      # X11 display socket — required for the game window.
      # On the server, either forward via SSH -X or run an Xvfb / VNC server
      # and set DISPLAY accordingly.
      "/tmp/.X11-unix:/tmp/.X11-unix:ro"

      # Game data directory.  Copy CLAW.REZ here on the host:
      #   sudo cp /path/to/CLAW.REZ /var/lib/openclaw/
      "/var/lib/openclaw:/data"
    ];

    environment = {
      DISPLAY = ":0";
      SDL_VIDEODRIVER = "x11";
    };

    # host networking is the simplest way to reach the host X server.
    # Replace with --net=bridge and XAUTHORITY / xhost config if preferred.
    extraOptions = [ "--network=host" ];
  };
}
