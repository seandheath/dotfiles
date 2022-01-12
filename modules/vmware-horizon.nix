{ config, pkgs, ... }: {
  nixpkgs.overlays = [( self: super: rec {

    #vmwareFHSUserEnv = super.vmwareFHSUserEnv.overrideAttrs (old: rec {
      #targetPkgs = old.targetPkgs ++ [ pkgs.opensc ];
    #});

    vmwareHorizonClientFiles = super.vmwareHorizonClientFiles.overrideAttrs (old: rec {
      installPhase = old.installPhase + ''
        mkdir -p $out/lib/vmware/view/pkcs11
        ln -s "${super.opensc}/lib/opensc-pkcs11.so" "$out/lib/vmware/view/pkcs11/libopenscpkcs11.so"
      '';
    });
    vmware-horizon = super.vmware-horizon-client.overrideAttrs (old: rec {
      inherit vmwareHorizonClientFiles;
      #inherit vmwareFHSUserEnv;
    });
  })];
}
