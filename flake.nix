{
  inputs = {
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";
  };
  outputs = { self, ... }@inputs:
  let
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux"; 
    build-host = name: value: inputs.nixpkgs.lib.nixosSystem {
      system = value.system;
      modules = [
        ./hosts/${name}
        ./profiles/core.nix
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.user = import ./home-profiles/${value.home-manager}.nix
        }
      ]
      ++ (map (u: ./users/${u}) value.users)
      ++ (map (p: ./profiles/${p}.nix) value.profiles)
      ++ (map (m: ./modules/${m}.nix) value.modules);
      specialArgs = {inherit inputs;};
    };

    hosts = {
      hydrogen = {
        system = "x86_64-linux";
        users = [ "user" ];
        profiles = [ "server" ];
        home-manager = "server";
        modules = [
          "nvidia"
          "nextcloud"
          "usenet"
          "myjellyfin"
        ];
      };

      oxygen = {
        system = "x86_64-linux";
        home-manager = "workstation";
        users = [ "user" ];
        profiles = [ "workstation" ];
        modules = [ "nvidia" ];
      };

      router = {
        system = "x86_64-linux";
        home-manager = "server";
        users = [ "user" ];
        profiles = [ ];
        modules = [ "ddclient" ];
      };
    };
  in {
    nixosConfigurations = builtins.mapAttrs build-host hosts;

    devShell = import ./shell.nix { inherit pkgs; };
  };
}
