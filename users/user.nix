{ config, ... }: {
  users.groups.user = {};
  users.users.user = {
    isNormalUser = true;
    group = config.users.groups.user.name;
    extraGroups = [ "wheel" "scanner" "lp" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLhPOBx9dR2X3oYz5RS2eAGZA7YSeHPcnrQauHSmuk1"
    ];
  };
}

