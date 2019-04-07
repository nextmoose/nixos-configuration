{
  pkgs ? import <nixpkgs> {}
} :
rec {
  cleanup-old-installation = (import ./assembly.nix {
    pkgs = pkgs;
    name = "cleanup-old-installation";
    src = ./assemblies/cleanup-old-installation;
    dependencies = [
      pkgs.utillinux
      pkgs.cryptsetup
      pkgs.lvm2
      pkgs.coreutils
    ];
  });
  decrypt-installation-secrets = (import ./assembly.nix {
    pkgs = pkgs;
    name = "decrypt-installation-secrets";
    src = ./assemblies/decrypt-installation-secrets;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.gnupg
      pkgs.gzip
      pkgs.gnutar
    ];
  });
  encrypt-installation-secrets = (import ./assembly.nix {
    pkgs = pkgs;
    name = "encrypt-installation-secrets";
    src = ./encrypt-installation-secrets;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.gpg
      pkgs.gzip
      pkgs.gnutar
    ];
  });
  wpa-wifi = (import ./assembly.nix {
    pkgs = pkgs;
    name = "wpa-wifi";
    src = ./assemblies/wpa-wifi;
    dependencies = [
      pkgs.wpa_supplicant
    ];
  });
}
