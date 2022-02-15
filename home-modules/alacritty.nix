{ config, pkgs, ... }:
let
  blood_moon = {
    primary = {
      background = "0x10100E";
      foreground = "0xC6C6C4";
    };
    normal = {
      black = "0x10100E";
      red = "0xC40233";
      green = "0x009F6B";
      yellow = "0xFFD700";
      blue = "0x0087BD";
      magenta = "0x9A4EAE";
      cyan = "0x20B2AA";
      white ="0xC6C6C4";
    };
    bright = {
      black = "0x696969";
      red = "0xFF2400";
      green = "0x03C03C";
      yellow = "0xFDFF00";
      blue = "0x007FFF";
      magenta = "0xFF1493";
      cyan = "0x00CCCC";
      white = "0xFFFAFA";
    };
  };
  base16_default_dark = {
    primary = {
      background = "0x181818";
      foreground = "0xd8d8d8";
    };
    cursor = {
      text = "0xd8d8d8";
      cursor = "0xd8d8d8";
    };
    normal = {
      black =   "0x181818";
      red =     "0xab4642";
      green =   "0xa1b56c";
      yellow =  "0xf7ca88";
      blue =    "0x7cafc2";
      magenta = "0xba8baf";
      cyan =    "0x86c1b9";
      white =   "0xd8d8d8";
    };
    bright = {
      black =   "0x585858";
      red =     "0xab4642";
      green =   "0xa1b56c";
      yellow =  "0xf7ca88";
      blue =    "0x7cafc2";
      magenta = "0xba8baf";
      cyan =    "0x86c1b9";
      white =   "0xf8f8f8";
    };
  };
  campbell = {
    primary = {
      background = "0x10100E";
      foreground = "0xcccccc";
    };
    normal = {
      black =      "0x0c0c0c";
      red =        "0xc50f1f";
      green =      "0x13a10e";
      yellow =     "0xc19c00";
      blue =       "0x0037da";
      magenta =    "0x881798";
      cyan =       "0x3a96dd";
      white =      "0xcccccc";
    };
    bright = {
      black =      "0x767676";
      red =        "0xe74856";
      green =      "0x16c60c";
      yellow =     "0xf9f1a5";
      blue =       "0x3b78ff";
      magenta =    "0xb4009e";
      cyan =       "0x61d6d6";
      white =      "0xf2f2f2";
    };
  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.history = 100000;
      font = {
        normal.family = "Inconsolata";
        size = 14;
      };
      draw_bold_text_with_bright_colors = true;
      colors = campbell;
    };
  };
}
