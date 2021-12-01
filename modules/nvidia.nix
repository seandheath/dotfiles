{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Enable NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
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

