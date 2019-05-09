{
  pkgs
} :
let
  uuids = {
    images = {
      read-only-pass = "afe57ba0-feef-476b-9ad1-48265a2dea92";
      read-write-pass = "b080b562-9a71-471e-b903-11e58012e7a2";
    };
    containers = {
      system-secrets-read-only-pass = "688e3276-08da-457f-9aa8-823b2e6acbf3";
      system-secrets-read-write-pass = "87bb24b6-f9e1-46c1-8d49-d56940bcdd07";
    };
  };
in
rec {
  add-ssh-domain = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "add-ssh-domain";
    src = ./scripts/add-ssh-domain;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.pass
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
  setup = (import ./setup/default.nix {
    pkgs = pkgs;
    uuids = uuids;
    docker-image-id = docker-image-id;
    docker-container-id = docker-container-id;
    read-only-pass = read-only-pass;
    uuid-parser = uuid-parser;
  });
  start-docker-container = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "start-docker-container";
    src = ./scripts/start-docker-container;
    dependencies = [
      pkgs.docker
    ];
  });
  system-secrets-read-only-pass = (import ./secrets/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    uuid = uuids.containers.system-secrets-read-only-pass;
  });
  teardown = (import ./teardown/default.nix {
    pkgs = pkgs;
    uuids = uuids;
  });
  uuid-parser = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "uuid-parser";
    src = ./scripts/uuid-parser;
    dependencies = [ pkgs.jq pkgs.mktemp pkgs.coreutils ];
  });
}
