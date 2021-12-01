{ config, ... }: {
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "scanner" "lp" ];
  };
}

