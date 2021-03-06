{ config, pkgs, ... }: {
  sops.secrets.wg-priv-s.mode = "0400";
  sops.secrets.wg-psk-s.mode = "0400";
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.100.0.2/24" ];
    dns = [ "10.0.0.1" ];
    privateKeyFile = config.sops.secrets.wg-priv-s.path;
    peers = [
      { # R
        publicKey = "ILwElzleBCCQ8vrGGiV2gUY0B33IHB456MQtgT2ZUTE=";
        presharedKeyFile = config.sops.secrets.wg-psk-s.path;
        allowedIPs = [ "10.0.0.1/24" ];
        endpoint = "sunrise.nheath.com:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}



