{
  pkgs ? import <nixpkgs> {},
} :
rec {
  configure-nixos = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = ./scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.git
      pkgs.rsync
      pass
      pkgs.gnutar
      pkgs.mkpasswd
      pkgs.gnused
    ];
  });
  install-nixos = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "install-nixos";
    src = ./scripts/install-nixos;
    dependencies = [
      pkgs.mktemp
      configure-nixos
      pkgs.gnused
      pkgs.gnugrep
      pkgs.systemd
      pkgs.which
      pkgs.rsync
      pkgs.coreutils
    ];
  });
  nmcli-wifi = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "nmcli-wifi";
    src = ./scripts/nmcli-wifi;
    dependencies = [
      pkgs.networkmanager
    ];
  });
  pass = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "pass";
    src = ./scripts/pass;
    dependencies = [
      pkgs.coreutils
    ];
  });
}
