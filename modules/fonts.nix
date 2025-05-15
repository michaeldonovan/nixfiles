{ pkgs, config, ... }:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "Hack" ]; })
    inter-ui
    cascadia-code
  ];
}
