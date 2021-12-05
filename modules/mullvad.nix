{ config, ... }: {
  # Enable wireguard and Mullvad
  networking.wireguard.enable = true;
  #networking.firewall.checkReversePath = "loose";
  services.mullvad-vpn.enable = true;
}

