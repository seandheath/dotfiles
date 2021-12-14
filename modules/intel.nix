{ config, pkgs, ... }: {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libva
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    setLdLibraryPath = true;
  };
}
