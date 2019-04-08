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
  foo = (import ./create-assembly.nix {
    pkgs = pkgs;
    name = "foo";
    src = ./assemblies/foo;
    dependencies = [
      pkgs.coreutils
    ];
  });
  install-nixos = (import ./install-nixos/default.nix {
    pkgs = pkgs;
  });
  secrets = (import ./create-assembly.nix {
    pkgs = pkgs;
    name = "secrets";
    src = ./assemblies/secrets;
    dependencies = [
      pkgs.coreutils
    ];
  });
  seed-secrets = (import ./create-assembly.nix {
    pkgs = pkgs;
    name = "seed-secrets";
    src = ./assemblies/seed-secrets;
    dependencies = [
      pkgs.gnupg
      pkgs.gzip
      pkgs.gnutar
    ];
  });
}
