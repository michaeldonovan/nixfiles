{ pkgs, config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
    docker = {
      package = pkgs.docker_25;
      daemon.settings.features.cdi = true;
      daemon.settings = {
        runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
        exec-opts = [ "native.cgroupdriver=cgroupfs" ];
      };
    };
  };


  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
  };
  boot.kernelParams = [ "pcie_aspm=off" ];
}
