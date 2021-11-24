{ config, pkgs, lib, ... }:
let
  monoFont = "CaskaydiaCove Nerd Font Mono";
  monoFontSize = "13";
  uiFont = "Inter";
  uiFontSize = "11";
in
{
  imports = [
    ../../../home/kitty.nix
  ];

  home.packages = with pkgs; [

    # utils
    terminator
    alacritty
    kitty
    solaar
    authy
    rofi
    libreoffice
    firefox
    nextcloud-client
    yubioath-desktop
    yubico-piv-tool
    mullvad-vpn
    dconf2nix
    _1password
    _1password-gui
    google-chrome
    lutris
    gitkraken
    nasc

    # games
    steam
    linuxPackages.xpadneo

    # media
    apple-music-electron
    ffmpeg
    youtube-dl
    vlc

    # photo
    krita
    inkscape

    # libs
    pango
    mesa_glu
    alsa-lib

    # audio
    CHOWTapeModel
    reaper
    pulseeffects-pw
    ardour
    calf
    carla
    puredata
    zexy
  ];

  programs.vscode.enable = true;
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.easyeffects = {
    enable = true;
    preset = "Voice";
  };

  # theme
  gtk = {
    enable = true;
    theme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "${uiFont}";
      size = lib.toInt uiFontSize;
    };
  };

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell" = {
      disable-extension-version-validation = true;
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.1;
      font-antialiasing = "grayscale";
      monospace-font-name = "${monoFont} ${monoFontSize}";
      document-font-name = "${uiFont} ${uiFontSize}";
      font-hinting = "slight";
      clock-show-weekday = true;
      clock-show-seconds = false;
      clock-show-date = true;
      clock-format = "12h";
    };
  };

  # fonts
  # fonts.fontconfig.enable = true;

  programs.terminator = {
    enable = true;
    config = {
      global_config = {
        focus = "mouse";
        title_hide_sizetext = true;
        inactive_color_offset = 0.5;
        title_use_system_font = false;
      };
      profiles = {
        default = {
          cursor_color = "#aaaaaa";
          font = "${monoFont} ${monoFontSize}";
          show_titlebar = false;
          disable_mousewheel_zoom = true;
          use_system_font = false;
          use_theme_colors = true;
        };
      };
    };
  };

  programs.mykitty = {
    enable = true;
    fontFamily = "${monoFont}";
    fontSize = "${monoFontSize}";
  };
}
