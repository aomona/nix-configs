{ inputs, ... }:
{
  imports = [
    inputs.minecraft-nix.nixosModules.default
  ];

  services.minecraft-servers.survival = {
    enable = true;
    eula = true;
    lockFile = ./minecraft-server-lock.json;

    software = {
      type = "neoforge";
      minecraftVersion = "1.21.1";
      neoforge = {
        version = "21.1.227";
      };
    };

    mods.modrinth = [
      {
        project = "create";
        loader = "neoforge";
      }
    ];

    port = 25565;
    openFirewall = true;
  };
}
