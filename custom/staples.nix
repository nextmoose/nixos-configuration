{
  pkgs ? import <nixpkgs> {}
} :
rec {
  create-installation-is = (import ./assembly.nix {
    pkgs = pkgs;
    name = "create-installation-iso";
    src = ./assemblies/create-installation-iso;
    dependencies = [
      pkgs.utillinux
      pkgs.cryptsetup
      pkgs.lvm2
      pkgs.coreutils
    ];
  });
}
