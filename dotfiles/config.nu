# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# direnv
{ ||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
}

# Commands
def --wrapped rebuild [...rest: string] {
    sudo nixos-rebuild switch --flake $"($env.HOME)/configs#(^hostname | str trim)" ...$rest
}

alias alcom = with-env {
    GDK_BACKEND: "x11",
    __NV_DISABLE_EXPLICIT_SYNC: "1",
    WEBKIT_DISABLE_DMABUF_RENDERER: "1"
} { ^ALCOM }
