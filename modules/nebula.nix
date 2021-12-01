{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  services.nebula = {
    enable = true;
    networks = {
      vpn = {
        enable = true;
        ca = "";
        cert = "";

}

