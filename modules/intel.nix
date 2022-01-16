{ config, pkgs, ... }: {
  boot.kernel.sysctl = {
    "dev.i915.perf_stream_paranoid" = 0;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libva-full
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      vulkan-tools
      vulkan-headers
      vulkan-loader
      #intel-media-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-full
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      vulkan-loader
    ];
    setLdLibraryPath = true;
  };
}
