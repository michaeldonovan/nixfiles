{ pkgs, config, ... }:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "Hack" ]; })
    inter
    cascadia-code
  ];
}
