{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qjackctl
    pavucontrol
    sound-theme-freedesktop
    playerctl
    alsa-utils
  ];

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    media-session.enable = true;
  };

  # musnix
  security.sudo.extraRules = [
    {
      users = [ "michael" ];
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  musnix = {
    enable = true;
    alsaSeq.enable = false;
    # kernel.optimize = true;
    # kernel.realtime = true;
    # das_watchdog.enable = true;

    # magic to me
    rtirq = {
      # highList = "snd_hrtimer";
      resetAll = 1;
      prioLow = 0;
      enable = true;
      nameList = "rtc0 snd";
    };
  };

  users.users.michael = {
    extraGroups = [ "audio" ];
  };

  environment.etc = {
    # focusrite scarlett 18i20 gen2
    "modprobe.d/scarlett.conf".text = ''
      options snd_usb_audio vid=0x1235 pid=0x8201 device_setup=1
    '';
  };

}
