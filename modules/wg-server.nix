{ config, pkgs, ... }: {
  sops.secrets.wg-priv-r.mode = "0400";
  sops.secrets.wg-psk-s.mode = "0400";
  networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets.wg-priv-r.path;
    peers = [
      { # S
        publicKey = "4ZAwOX6/WKDCm0YBuaNXKhSVej+3pwGEOgFU5Ca2pBM=";
        presharedKeyFile = config.sops.secrets.wg-psk-s.path;
        allowedIPs = [ "10.100.0.2/32" "10.0.0.0/24" ];
      }
      { # D
        publicKey = "EVp4ViHecARK9fqh6Pa8fwJzEVxqvo+FpVCt3/ZTODQ=";
        allowedIPs = [ "10.100.0.3/32" "10.0.0.0/24" ];
      }
    ];
  };
}
