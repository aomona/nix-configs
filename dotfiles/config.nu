# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Aliases
alias rebuild = sudo nixos-rebuild switch --flake /home/akazdayo/configs#nixos
alias alcom = with-env {
    GDK_BACKEND: "x11",
    __NV_DISABLE_EXPLICIT_SYNC: "1",
    WEBKIT_DISABLE_DMABUF_RENDERER: "1"
} { ^ALCOM }
