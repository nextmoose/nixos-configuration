{
  pkgs
} :
rec {
  add-ssh-domain = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "add-ssh-domain";
    src = ./scripts/add-ssh-domain;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.pass
      user
    ];
  });
  challenge = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "challenge";
    src = ./scripts/challenge;
    dependencies = [
      pkgs.python27Packages.xkcdpass
    ];
  });
  challenge-secrets = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "challenge-secrets";
    src = ./scripts/challenge-secrets;
    dependencies = [
      pkgs.pass
    ];
  });
  configure-nixos = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = ./scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.git
      pkgs.rsync
      user
      pkgs.gnutar
      pkgs.mkpasswd
      pkgs.gnused
    ];
  });
  docker-image-id = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "docker-image-id";
    src = ./scripts/docker-image-id;
    dependencies = [
      pkgs.docker
    ];
  });
  docker-container-id = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "docker-container-id";
    src = ./scripts/docker-container-id;
    dependencies = [
      pkgs.docker
    ];
  });
  gnupg-key-id = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ./scripts/gnupg-key-id;
    dependencies = [
      pkgs.gnupg
      pkgs.coreutils
    ];
  });
  gnupg-ownertrust = (import ./injectable/gnupg-ownertrust/default.nix {
    pkgs = pkgs;
  });
  gnupg2-ownertrust = (import ./injectable/gnupg2-ownertrust/default.nix {
    pkgs = pkgs;
  });
  gnupg-private-keys = (import ./injectable/gnupg-private-keys/default.nix {
    pkgs = pkgs;
  });
  gnupg2-private-keys = (import ./injectable/gnupg2-private-keys/default.nix {
    pkgs = pkgs;
  });
  homer = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "homer";
    src = ./scripts/homer;
  });
  init-dot-ssh = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-dot-ssh";
    src = ./scripts/init-dot-ssh;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
    ];
  });
  init-gnupg = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-gnupg";
    src = ./scripts/init-gnupg;
    dependencies = [
      gnupg-ownertrust
      gnupg2-ownertrust
      gnupg-private-keys
      gnupg2-private-keys
    ];
  });
  install-nixos = (import ./script-derivation.nix {
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
  nmcli-wifi = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "nmcli-wifi";
    src = ./scripts/nmcli-wifi;
    dependencies = [
      pkgs.networkmanager
    ];
  });
  pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "pass";
    src = ./scripts/pass;
    dependencies = [
      docker-container-id
      pkgs.docker
    ];
  });
  post-commit = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "post-commit";
    src = ./scripts/post-commit;
    dependencies = [
      pkgs.git
      pkgs.coreutils
    ];
  });
  read-only-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "read-only-pass";
    src = ./scripts/read-only-pass;
    dependencies = [
      add-ssh-domain
      init-dot-ssh
      init-gnupg
      pkgs.pass
      pkgs.coreutils
      gnupg-key-id
    ];
  });
  read-write-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-read-write-pass";
    src = ./scripts/read-write-pass;
    dependencies = [
      init-gnupg
      init-dot-ssh
      add-ssh-domain
      pkgs.pass
      pkgs.git
      gnupg-key-id
      pkgs.which
      pkgs.coreutils
      post-commit
    ];
  });
  start-docker-container = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "start-docker-container";
    src = ./scripts/start-docker-container;
    dependencies = [
      pkgs.docker
    ];
  });
  system-secrets-read-only-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    src = ./personal/system-secrets-read-only-pass;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.docker
    ];
  });
  system-secrets-read-write-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "system-secrets-read-write-pass";
    src = ./personal/system-secrets-read-write-pass;
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
      pkgs.docker
      system-secrets-read-only-pass
    ];
  });
  user = (import ./user/default.nix {
    pkgs = pkgs;
    read-only-pass = read-only-pass;
    read-write-pass = read-write-pass;
    pass = pass;
    docker-image-id = docker-image-id;
    docker-container-id = docker-container-id;
  });
}
