{ config, pkgs, ... }: {
  imports = [
    ./core.nix
  ];
  programs.kodi = {
    enable = true;
    sources = {
      video = {
        default = "movies";
        source = [
          {
            name = "movies";
            path = "/data/movies";
          }
          {
            name = "tv";
            path = "/data/tv";
          }
        ];
      };
    };
  };
}
