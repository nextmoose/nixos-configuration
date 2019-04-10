{
  pkgs ? import <nixpkgs> {}
} :
rec {
  install-local-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "install-local-nixos";
    src = ./derivations/install-local-nixos;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.git
      pkgs.rsync
      pass
      pkgs.gnutar
      pkgs.mkpasswd
      pkgs.gnused
    ];
  });
  nmcli-wifi = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "nmcli-wifi";
    src = ./derivations/nmcli-wifi;
    dependencies = [
      pkgs.networkmanager
    ];
  });
  pass = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "pass";
    src = ./derivations/pass;
    dependencies = [
      pkgs.coreutils
    ];
  });
}
