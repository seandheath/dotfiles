{ config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.history = 100000;
      font = {
        normal.family = "Inconsolata";
        size = 11;
      };
      draw_bold_text_with_bright_colors = true;
      dynamic_title = true;
      cursor.style = "Block";
      cursor.unfocused_hollow = true;
      shell = {
        program = "/run/current-system/sw/bin/bash"

