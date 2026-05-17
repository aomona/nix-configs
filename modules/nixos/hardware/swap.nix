{ hostMeta, ... }:
{
  swapDevices = [
    {
      device = hostMeta.hostData.swap.device;
      size = 24 * 1024;
    }
  ];
}
