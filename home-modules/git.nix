{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Sean Heath";
    userEmail = "se@nheath.com";
    extraConfig = {
      pull.rebase = false;
    };
  };
}
