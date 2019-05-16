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
      system-secrets-read-only-pass2 = "8abb9457-0acd-43c3-85ea-7bcc19cfa293";
      system-secrets-read-write-pass = "87bb24b6-f9e1-46c1-8d49-d56940bcdd07";
      browser-secrets-read-write-pass = "bb0d1f53-73e9-4a8a-a7c6-e4b04dfcd2fa";
      challenge-secrets-read-write-pass = "9d51d00a-cfb4-4e7b-bd8c-2de732aa2003";
    };
  };
in
rec {
  add-ssh-domain = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "add-ssh-domain";
    src = ./scripts/add-ssh-domain;
    dependencies = [
      system-secrets-read-only-pass
      pkgs.coreutils
      pkgs.gnused
      pkgs.pass
      system-secrets-read-only-pass
    ];
  });
  browser-secrets-read-write-pass = (import ./secrets/default.nix {
    pkgs = pkgs;
    name = "browser-secrets-read-write-pass";
    uuid = uuids.containers.browser-secrets-read-write-pass;
  });
  challenge-secrets-read-write-pass = (import ./secrets/default.nix {
    pkgs = pkgs;
    name = "challenge-secrets-read-write-pass";
    uuid = uuids.containers.challenge-secrets-read-write-pass;
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
  docker-health-check = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "docker-health-check";
    src = ./scripts/docker-health-check;
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
  docker-container-start-and-wait-for-healthy = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "docker-container-start-and-wait-for-healthy";
    src = ./scripts/docker-container-start-and-wait-for-healthy;
    dependencies = [
      pkgs.docker
      pkgs.coreutils
    ];
  });
  docker-image-load = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "docker-image-load";
    src = ./scripts/docker-image-load;
    dependencies = [
      pkgs.coreutils
      docker-image-id
      pkgs.docker
      uuid-parser
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
    dependencies = [
      pkgs.mktemp
      pkgs.coreutils
    ];
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
      pkgs.gnupg
      pkgs.jq
      gnupg-private-keys
      gnupg2-private-keys
      gnupg-ownertrust
      gnupg2-ownertrust
    ];
    configuration = {
      gpg = {
        key = ../injected/gnupg-private-keys.asc;
	trust = ../injected/gpupg-ownertrust.asc;
      };
      gpg2 = {
        key = ../injected/gnupg2-private-keys.asc;
	trust = ../injected/gnupg2-ownertrust.asc;
      };
    };
  });
  init-read-only-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-read-only-pass";
    src = ./scripts/init-read-only-pass;
    dependencies = [
      init-gnupg
      pkgs.pass
      pkgs.coreutils
      gnupg-key-id
    ];
  });
  init-read-write-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-read-write-pass";
    src = ./scripts/init-read-write-pass;
    dependencies = [
      init-gnupg
      init-dot-ssh
      add-ssh-domain
      post-commit
      pkgs.pass
      pkgs.coreutils
      gnupg-key-id
      pkgs.which
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
    name = "read-write-pass";
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
  start-read-only-pass-container = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "start-read-only-pass-container";
    src = ./scripts/start-read-only-pass-container;
    dependencies = [
      pkgs.docker
      pkgs.coreutils
      docker-container-start-and-wait-for-healthy
      uuid-parser
      docker-image-id
      docker-container-id
    ];
  });
  start-read-write-pass-container = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "start-read-write-pass-container";
    src = ./scripts/start-read-write-pass-container;
    dependencies = [
      pkgs.docker
      pkgs.coreutils
      docker-container-start-and-wait-for-healthy
      uuid-parser
      docker-image-id
      docker-container-id
    ];
  });
  system-secrets-read-only-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    uuid = "d5949af7-cdeb-4924-9050-435278cbb445";
    run = ''
      ${init-read-only-pass}/bin/init-read-only-pass \
        --remote https://github.com/nextmoose/secrets.git \
	--branch master
    '';
    entrypoint = ''
      ${pkgs.pass}/bin/pass
    '';
  });
  system-secrets-read-write-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-write-pass";
    uuid = "a000bdbe-d054-485e-bd6c-dcf7388de6b2";
    run = ''
      ${init-read-write-pass}/bin/init-read-write-pass \
        --remote origin:nextmoose/secrets.git \
	--branch master \
	--host github.com \
	--user git \
	--committer-name "Emory Merryman" \
	--committer-email "emory.merryman@gmail.com"
    '';
    entrypoint = ''
      ${pkgs.pass}/bin/pass
    '';
  });
  uuid-parser = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "uuid-parser";
    src = ./scripts/uuid-parser;
    dependencies = [ pkgs.jq pkgs.mktemp pkgs.coreutils ];
  });
}
