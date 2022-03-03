{ config, pkgs, ... }: {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    #extraPackages = with pkgs; [
      #vaapiIntel
      #vaapiVdpau
      #libvdpau-va-gl
      #intel-media-driver
      #mesa.drivers
    #];
  };
}
