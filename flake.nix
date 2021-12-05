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
          home-manager.users.user = import ./home-modules/${value.home-manager}.nix;
        }
      ]
      ++ value.modules;
      specialArgs = {inherit inputs;};
    };

    hosts = {
      hydrogen = {
        system = "x86_64-linux";
        home-manager = "server";
        modules = [
          ./users/user
          ./profiles/server.nix
          ./modules/nvidia.nix
          ./modules/nextcloud.nix
          ./modules/usenet.nix
          inputs.nixos-hardware.nixosModules.common-cpu-intel
        ];
      };
      
      oxygen = {
        system = "x86_64-linux";
        home-manager = "workstation";
        modules = [
          ./users/user
          ./profiles/workstation.nix
          ./modules/nvidia.nix
          inputs.nixos-hardware.nixosModules.common-cpu-amd
        ];
      };

      uranium = {
        system = "x86_64-linux";
        home-manager = "workstation";
        modules = [
          ./users/user
          ./profiles/workstation.nix
          #./modules/wg-client.nix
          inputs.nixos-hardware.nixosModules.dell-xps-13-9310
        ];
      };

      plutonium = {
        system = "x86_64-linux";
        home-manager = "workstation";
        modules = [
          ./users/user
          ./profiles/workstation
          inputs.nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      router = {
        system = "x86_64-linux";
        home-manager = "server";
        modules = [
          ./users/user
          ./modules/ddlient.nix
          ./modules/wg-server.nix
          inputs.nixos-hardware.nixosModules.common-cpu-amd
        ];
      };
    };
  in {
    nixosConfigurations = builtins.mapAttrs build-host hosts;
    devShell = import ./shell.nix { inherit pkgs; };
  };
}
