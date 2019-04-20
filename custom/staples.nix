{
  pkgs ? import <nixpkgs> {},
} :
rec {
  add-ssh-domain = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "add-ssh-domain";
    src = ./scripts/add-ssh-domain;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.pass
    ];
  });
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
  gnupg-key-id = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ./scripts/gnupg-key-id;
    dependencies = [
      pkgs.gnupg
      pkgs.coreutils
    ];
  });
  init-dot-ssh = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "init-dot-ssh";
    src = ./scripts/init-dot-ssh;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
    ];
  });
  init-gnupg = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "init-gnupg";
    src = ./scripts/init-gnupg;
    dependencies = [
      pass
      pkgs.coreutils
      pkgs.mktemp
      pkgs.gnupg
    ];
  });
  init-read-only-pass = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "init-read-only-pass";
    src = ./scripts/init-read-only-pass;
    dependencies = [
      pkgs.pass
      pkgs.git
      gnupg-key-id
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
  setup-user = (import ./create-script-derivation.nix {
    pkgs = pkgs;
    name = "setup-user";
    src = ./scripts/setup-user;
    dependencies = [
      add-ssh-domain
      init-dot-ssh
      init-gnupg
      init-read-only-pass
      pkgs.coreutils
    ];
  });
}
