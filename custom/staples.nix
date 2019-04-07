{
  pkgs ? import <nixpkgs> {}
} :
rec {
  create-installation-is = (import ./assembly.nix {
    pkgs = pkgs;
    name = "cleanup-old-installation";
    src = ./assemblies/create-installation-iso;
    dependencies = [
      pkgs.utillinux
      pkgs.cryptsetup
      pkgs.lvm2
      pkgs.coreutils
    ];
  });
}
