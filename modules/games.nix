{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    flightgear
    freeorion
    cataclysm-dda
  ];
}

