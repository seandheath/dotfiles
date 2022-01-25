{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Enable NVIDIA driver
  #hardware.nvidia.modesetting.enable = true;
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm.nvidiaWayland = false;
  #hardware.nvidia.package =
    #config.boot.kernelPackages.nvidiaPackages.beta;
  services.xserver.screenSection = ''
    Option  "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option  "AllowIndirectGLXProtocol" "off"
    Option  "TripleBuffer" "on"
  '';
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libva
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [
      libva
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}

