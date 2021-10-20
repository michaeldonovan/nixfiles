{ pkgs, config, ... }:
{
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "Hack" ]; })
    inter-ui
    cascadia-code
  ];
}
