{ hostMeta, ... }:
let
  hostData = {
    networking = {
      primaryInterface = "enp1s0";
    };

    velocity = {
      # Port for Velocity to listen on (public-facing)
      serverPort = 25565;
      jvmOpts = "-Xms512M -Xmx1G";

      # Shared secret for Velocity modern forwarding.
      # Must match the value on all Fabric backend servers (minecraft host).
      # FIXME: Migrate to sops-nix for production use.
      secret = "changeme-please-replace-at-deploy-time";
    };

    minecraft = {
      # Internal IP of the minecraft backend host (on the same OpenStack network).
      # Resolve via: tofu -chdir=infra/openstack/minecraft output -raw fixed_ip
      internalIp = "<MINECRAFT_INTERNAL_IP>";

      smp = {
        serverPort = 25566;
      };

      creative = {
        serverPort = 25568;
      };
    };

    users.${hostMeta.primaryUser}.authorizedKeys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIuYLePldOwgtFXwo0sw48rBVzX2zHjzGshFq4V9xwMLAAAABHNzaDo= somanoda@25N1103630nodasoma.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrvifm9j0kjjoEUWf+QeFxQgdA9XPYc/VRyS9oPL+X5"
    ];

    users.deploy.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0cl+EdTJh1MxftdC1ePO0C4oXajt7JzJrltg0kwR0U github-actions-deploy"
    ];
  };
in
{
  _module.args.hostData = hostData;
}
