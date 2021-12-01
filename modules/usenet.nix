{ config, ... }:
let
  id = 2000;
in {
  users.groups.usenet.gid = id;
  users.users.usenet = {
    isSystemUser = true;
    uid = id;
    group = "usenet";
  };
  system.activationScripts.usenet.text = ''
    mkdir -p /var/lib/usenet/{nzbget,sonarr,radarr,jellyfin}
    chown -R usenet:usenet /var/lib/usenet/
  '';
  containers.usenet = {
    ephemeral = true;
    autoStart = true;
    bindMounts = {
      "/var/lib/nzbget" = {
        hostPath = "/var/lib/usenet/nzbget";
        isReadOnly = false;
      };
      "/var/lib/jellyfin" = {
        hostPath = "/var/lib/usenet/jellyfin";
        isReadOnly = false;
      };
      "/var/lib/sonarr" = {
        hostPath = "/var/lib/usenet/sonarr";
        isReadOnly = false;
      };
      "/var/lib/radarr" = {
        hostPath = "/var/lib/usenet/radarr";
        isReadOnly = false;
      };
      "/data" = {
        hostPath = "/data";
        isReadOnly = false;
      };
    };
    config = { config, pkgs, builtins, ... }: {
      hardware.opengl = {    
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [ libva vaapiVdpau libvdpau-va-gl ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ];
        setLdLibraryPath = true;    
      };
      environment.systemPackages = with pkgs; [
        ffmpeg
      ];
      nixpkgs.config.allowUnfree = true;
      users.groups.usenet.gid = id;
      users.users.usenet = {
        isNormalUser = true;
        uid = id;
        group = "usenet";
      };
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 6789 8096 7878 8989 ];
      services.nzbget = {
        enable = true;
        user = "usenet";
        group = "usenet";
      };
      services.sonarr = {
        enable = true;
        user = "usenet";
        group = "usenet";
      };
      services.radarr = {
        enable = true;
        user = "usenet";
        group = "usenet";
      };
      services.jellyfin = {
        enable = true;
        user = "usenet";
        group = "usenet";
      };
    };
  };
}
