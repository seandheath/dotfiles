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
    defaultModules = [
      ./profiles/core.nix
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.user = import ./users/user/home.nix;
      }
    ];
    build-host = name: value: inputs.nixpkgs.lib.nixosSystem {
        system = value.system;
        modules = [
          ./hosts/${name}
        ] ++ value.users ++ value.modules ++ defaultModules;
        specialArgs = {inherit inputs;};
    };
    hosts = {
      oxygen = {
        system = "x86_64-linux";
        users = [
          ./users/user
        ];
        modules = [
          ./profiles/workstation.nix
          ./modules/nvidia.nix
        ];
      };
    };
  in {
    nixosConfigurations = builtins.mapAttrs build-host hosts;
    devShell = import ./shell.nix { inherit inputs; };
  };
}
