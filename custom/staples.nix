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
      system-secrets-read-only-pass
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
  browser-secrets-read-only-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "browser-secrets-read-only-pass";
    uuid = "327caca0-abce-4dcc-afc3-e54eee6c9af8";
    run = "${init-read-only-pass}/bin/init-read-only-pass --remote https://github.com/nextmoose/browser-secrets.git --branch master";
    entrypoint = "${pkgs.pass}/bin/pass";
  });
  browser-secrets-read-write-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "browser-secrets-read-write-pass";
    uuid = "d0eaca7d-5390-4eac-982e-ba6a02b7091c";
    run = ''${init-read-write-pass}/bin/init-read-write-pass --host origin --host-name github.com --user git --remote origin:nextmoose/browser-secrets.git --branch master --committer-name \"Emory Merryman\" --committer-email emory.merryman@gmail.com'';
    entrypoint = "${pkgs.pass}/bin/pass";
  });
  build-entrypoint = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "build-entrypoint";
    src = ./scripts/build-entrypoint;
  });
  challenge = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "challenge";
    src = ./scripts/challenge;
    dependencies = [
      pkgs.coreutils
    ];
  });
  challenge-secrets-read-only-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "challenge-secrets-read-only-pass";
    uuid = "a2203a1c-8e9b-457a-b5ee-c278652a45bc";
    run = "${init-read-only-pass}/bin/init-read-only-pass --remote https://github.com/nextmoose/challenge-secrets.git --branch master";
    entrypoint = "${pkgs.pass}/bin/pass";
  });
  challenge-secrets-read-write-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "challenge-secrets-read-write-pass";
    uuid = "dc624653-e607-4b95-a4c8-552c42a67fc3";
    run = ''${init-read-write-pass}/bin/init-read-write-pass --host origin --host-name github.com --user git --remote origin:nextmoose/challenge-secrets.git --branch master --committer-name \"Emory Merryman\" --committer-email emory.merryman@gmail.com'';
    entrypoint = "${pkgs.pass}/bin/pass";
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
      pkgs.jq
    ];
  });
  init-dot-ssh-host = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-dot-ssh-host";
    src = ./scripts/init-dot-ssh-host;
    dependencies = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.jq
    ];
    configuration = {
      name = "upstream";
      hostName = "github.com";
      user = "git";
      identityFile = "";
      userKnownHostsFile = "";
    };
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
        key = ./injected/gnupg-private-keys.asc;
	ownertrust = ./injected/gnupg-ownertrust.asc;
      };
      gpg2 = {
        key = ./injected/gnupg2-private-keys.asc;
	ownertrust = ./injected/gnupg2-ownertrust.asc;
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
      pkgs.which
      phonetic
    ];
  });
  init-read-write-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "init-read-write-pass";
    src = ./scripts/init-read-write-pass;
    dependencies = [
      init-gnupg
      init-dot-ssh
      init-dot-ssh-host
      post-commit
      pkgs.pass
      pkgs.coreutils
      gnupg-key-id
      pkgs.which
      system-secrets-read-only-pass
      pass-expiry
      phonetic
      challenge
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
  pass-expiry = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "pass-expiry";
    src = ./scripts/pass-expiry;
    dependencies = [
      pkgs.pass
      pkgs.coreutils
      pkgs.gnugrep
    ];
  });
  phonetic = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "phonetic";
    src = ./scripts/phonetic;
    dependencies = [
      pkgs.pass
      pkgs.coreutils
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
  pre-commit = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "pre-commit";
    src = ./scripts/pre-commit;
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
      pre-commit
      pkgs.which
    ];
  });
  read-write-pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "read-write-pass";
    src = ./scripts/read-write-pass;
    dependencies = [
      init-gnupg
      init-dot-ssh
      init-dot-ssh-host
      pkgs.pass
      pkgs.git
      gnupg-key-id
      pkgs.which
      pkgs.coreutils
      post-commit
    ];
  });
  system-secrets-read-only-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    uuid = "d5949af7-cdeb-4924-9050-435278cbb445";
    run = "${init-read-only-pass}/bin/init-read-only-pass --remote https://github.com/nextmoose/secrets.git --branch master";
    entrypoint = "${pkgs.pass}/bin/pass";
  });
  system-secrets-read-write-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-write-pass";
    uuid = "4926ae80-5a69-4ac9-b42c-ea350021ce0d";
    run = ''${init-read-write-pass}/bin/init-read-write-pass --host origin --host-name github.com --user git --remote origin:nextmoose/secrets.git --branch master --committer-name \"Emory Merryman\" --committer-email emory.merryman@gmail.com'';
    entrypoint = "${pkgs.pass}/bin/pass";
  });
  old-secrets-read-only-pass = (import ./fabricated/persistent-container/default.nix {
    pkgs = pkgs;
    name = "old-secrets-read-only-pass";
    uuid = "90152adb-aa3f-41e6-9ef3-e8151012ed3a";
    run = ''${init-read-only-pass}/bin/init-read-only-pass --remote https://github.com/desertedscorpion/passwordstore.git --branch master'';
    entrypoint = "${pkgs.pass}/bin/pass";
  });
}
