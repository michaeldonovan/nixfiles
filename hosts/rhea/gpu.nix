{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  virtualisation.docker.enableNvidia = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
