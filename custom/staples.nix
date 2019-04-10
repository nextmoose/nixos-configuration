{
  pkgs ? import <nixpkgs> {}
} :
rec {
  configure-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
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
  install-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "install-nixos";
    src = ./derivations/install-nixos;
    dependencies = [
      configure-nixos
      pkgs.gnused
      pkgs.gnugrep
      pkgs.systemd
      pkgs.which
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
