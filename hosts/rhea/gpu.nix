{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  virtualisation.docker.enableNvidia = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  boot.kernelParams = [ "pcie_aspm=off" ];
}
