{ pkgs, config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
    docker = {
      # package = pkgs.docker_26;
      daemon.settings.features.cdi = true;
      daemon.settings = {
        runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
        exec-opts = [ "native.cgroupdriver=cgroupfs" ];
      };
    };
  };


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
  };

  systemd.services.docker = {
    after = [ "nvidia-persistenced.service" ];
    wants = [ "nvidia-persistenced.service" ];
  };
}
