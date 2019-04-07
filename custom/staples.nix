{
  pkgs ? import <nixpkgs> {}
} :
rec {
  cleanup-old-installation = ./assembly {
    pkgs = pkgs;
    name = "cleanup-old-installation";
    src = ./assemblies/cleanup-old-installation;
    dependencies = [
      pkgs.util-linux
      pkgs.cryptsetup
      pkgs.lvm2
      pkgs.coreutils
    ];
  };
  decrypt-installation-secrets = ./assembly {
    pkgs = pkgs;
    name = "decrypt-installation-secrets";
    src = ./decrypt-installation-secrets;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.gpg
      pkgs.gzip
      pkgs.gnutar
    ];
  };
  encrypt-installation-secrets = ./assembly {
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
  };
  wpa-wifi = ./assemby {
    pkgs = pkgs;
    name = "wpa-wifi";
    src = ./assemblies/wpa-wifi;
    dependencies = [
      pkgs.wpa_supplicant
    ];
  };
}
