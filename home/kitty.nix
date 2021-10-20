{ lib, pkgs, config, ... }:
with lib;
let 
  cfg = config.programs.mykitty;
in 
{
  options.programs.mykitty = {
    enable = mkEnableOption "Kitty";
    fontFamily = mkOption {
      type = types.str;
      default = "DejaVu Sans Mono 12";
      description = "Font family";
    };
    fontSize = mkOption {
      type = types.strMatching "[0-9]*";
      default = "12";
      description = "Font size";
    };
    kittyMod = mkOption {
      type = types.str;
      default = "ctrl";
      description = "kitty_mod key";
    };
  };

  config.programs.kitty = {
    enable = cfg.enable;
    font = {
      name = "${cfg.fontFamily}";
      size = lib.toInt cfg.fontSize;
    };
    extraConfig = ''
      kitty_mod ${cfg.kittyMod}

      # unmap
      map ctrl+w noop
      map ctrl+c noop

      copy_on_select yes

      # setup font settings
      disable_ligatures never

      # no bells. Ever.
      enable_audio_bell no
      bell_on_tab yes

      # default layout is vertical splits only
      enabled_layouts splits

      # don't draw extra borders, but fade the inactive text a bit
      draw_minimal_borders yes
      active_border_color none
      inactive_border_color #303030
      inactive_text_alpha 0.6

      # tabbar should be at the top
      tab_bar_edge top
      tab_bar_style separator 
      # tab_powerline_style slanted 
      tab_separator "  |  "
      active_tab_foreground   #202020
      active_tab_background   #a0a0a0
      active_tab_font_style   bold-italic
      inactive_tab_foreground #a0a0a0
      inactive_tab_background #202020
      inactive_tab_font_style normal

      update_check_interval 24
      startup_session default-session.conf

      # split
      map kitty_mod+shift+o launch --location=hsplit
      map kitty_mod+shift+e launch --location=vsplit
      map kitty_mod+left resize_window narrower 3
      map kitty_mod+right resize_window wider 3
      map kitty_mod+up resize_window taller 3
      map kitty_mod+down resize_window shorter 3

      # open new tab with kitty_mod+t
      map kitty_mod+t new_tab


      # kitty_mod+shift+w close window
      map kitty_mod+shift+w close_window


      # switch between next and previous splits
      map kitty_mod+]        next_window
      map kitty_mod+[        previous_window


      # changing font sizes
      map kitty_mod+equal    change_font_size all +2.0
      map kitty_mod+minus    change_font_size all -2.0
      map kitty_mod+0        change_font_size all 0

      wayland_titlebar_color system
      linux_display_server x11

      focus_follows_mouse yes

      # theme afterglow
      background            #202020
      foreground            #d0d0d0
      cursor                #d0d0d0
      selection_background  #505050
      color0                #151515
      color8                #505050
      color1                #ac4142
      color9                #ac4142
      color2                #7e8d50
      color10               #7e8d50
      color3                #e5b566
      color11               #e5b566
      color4                #6c99ba
      color12               #6c99ba
      color5                #9e4e85
      color13               #9e4e85
      color6                #7dd5cf
      color14               #7dd5cf
      color7                #d0d0d0
      color15               #f5f5f5
      selection_foreground  none 
    '';
  };
}