{
  pkgs ? import <nixpkgs> {}
} :
rec {
  create-installation-is = (import ./create-assembly.nix {
    pkgs = pkgs;
    name = "create-installation-iso";
    src = ./assemblies/create-installation-iso;
    dependencies = [
      pkgs.utillinux
      pkgs.cryptsetup
      pkgs.lvm2
      pkgs.coreutils
      pkgs.nix
      foo
    ];
  });
  secrets = (import ./create-assembly.nix {
    pkgs = pkgs;
    name = "secrets";
    src = ./assemblies/secrets;
    dependencies = [
      pkgs.coreutils
    ];
  });
}
