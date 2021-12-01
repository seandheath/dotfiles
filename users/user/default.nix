{ config, ... }: {
  users.groups.user = {};
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "scanner" "lp" ];
    group = "user";
  };
}

