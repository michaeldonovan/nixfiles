{ pkgs, ... }: {
  # ddcutils requires i2c
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs;
    [
      # ddcutil can manage *external* monitor's brightness
      ddcutil

      gnomeExtensions.brightness-control-using-ddcutil

    ];

  security.sudo.extraRules = [
    {
      users = [ "michael" ];
      commands = [
        {
          command = "${pkgs.ddcutil}/bin/ddcutil";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.users.michael = {
    extraGroups = [ "i2c" ];
  };

}
