#
{ config, pkgs, ... }:
let
  installed-pass = (import ./installed/pass/default.nix{
    pkgs = pkgs;
  });
  my-atom = (import ./custom/utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "atom";
    src = ./custom/scripts/atom;
    dependencies = [ pkgs.atom pkgs.trash-cli pkgs.glib.dev pkgs.coreutils pkgs.git pkgs.bash ];
  });
  node = (import ./custom/native/node/default.nix {
    pkgs = pkgs;
  });
  zoom = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "zoom";
    src = ./custom/scripts/zoom;
    dependencies = [ pkgs.docker ];
  });
  gnupg-import = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-import";
    src = ./custom/scripts/gnupg-import;
    dependencies = [ pkgs.mktemp installed-pass pkgs.coreutils pkgs.gnupg ];
  });
  gnupg-key-id = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ./custom/scripts/gnupg-key-id;
    dependencies = [ pkgs.coreutils pkgs.gnupg ];
  });
  dot-ssh-init = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "dot-ssh-init";
    src = ./custom/scripts/dot-ssh-init;
    dependencies = [ pkgs.coreutils ];
  });
  dot-ssh-add-domain = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "dot-ssh-add-domain";
    src = ./custom/scripts/dot-ssh-add-domain;
    dependencies = [ pkgs.coreutils installed-pass ];
  });
  post-commit = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "post-commit";
    src = ./custom/scripts/post-commit;
    dependencies = [ pkgs.git pkgs.coreutils ];
  });
  pre-commit = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "pre-commit";
    src = ./custom/scripts/pre-commit;
    dependencies = [ pkgs.git pkgs.coreutils ];
  });
  pass-init = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "pass-init";
    src = ./custom/scripts/pass-init;
    dependencies = [ gnupg-import dot-ssh-init dot-ssh-add-domain pkgs.pass gnupg-key-id pkgs.coreutils pkgs.which post-commit pre-commit ];
  });
  pass-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "pass-entrypoint";
    src = ./custom/scripts/pass-entrypoint;
    dependencies = [ pass-init pkgs.pass pkgs.bash ];
  });
  old-secrets = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "old-secrets";
    src = ./custom/scripts/old-secrets;
    dependencies = [ pkgs.docker ];
  });
  development-environment-init = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "development-environment-init";
    src = ./custom/scripts/development-environment-init;
    dependencies = [ gnupg-import dot-ssh-init pkgs.coreutils pkgs.git dot-ssh-add-domain pkgs.which post-commit gnupg-key-id ];
  });
  emacs-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "emacs-entrypoint";
    src= ./custom/scripts/emacs-entrypoint;
    dependencies = [ development-environment-init pkgs.emacs  pkgs.git node pkgs.gnupg pkgs.bash ];
  });
  atom-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "atom-entrypoint";
    src= ./custom/scripts/atom-entrypoint;
    dependencies = [ development-environment-init pkgs.atom pkgs.coreutils ];
  });
  lighttable-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "lighttable-entrypoint";
    src= ./custom/scripts/lighttable-entrypoint;
    dependencies = [ development-environment-init pkgs.lighttable ];
  });
  launch-atom-ide = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "launch-atom-ide";
    src = ./custom/scripts/launch-atom-ide;
    dependencies = [ pkgs.docker ];
  });
  launch-emacs-ide = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "launch-emacs-ide";
    src = ./custom/scripts/launch-emacs-ide;
    dependencies = [ pkgs.docker ];
  });
  launch-lighttable-ide = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "launch-lighttable-ide";
    src = ./custom/scripts/launch-lighttable-ide;
    dependencies = [ pkgs.docker ];
  });
  vuecli = (import ./custom/utils/custom-npm-derivation.nix {
    pkgs = pkgs;
    node = node;
    name = "vuecli";
    src = ./custom/npm/vue-cli;
  });
  vuecli-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "vuecli-entrypoint";
    src = ./custom/scripts/vuecli-entrypoint;
    dependencies = [ development-environment-init pkgs.bash vuecli ];
  });
  launch-configuration-ide = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "launch-configuration-ide";
    src = ./custom/scripts/launch-configuration-ide;
    dependencies = [ pkgs.docker ];
  });
  initialization = (import ./custom/native/initialization/default.nix {});
  pass = (import ./custom/native/pass/default.nix {
    pkgs = pkgs;
  });
  lighttable = (import ./custom/initialization/lighttable/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  containers = {
    nix-dev-env = (import ./custom/containers/nix-dev-env.nix {
      pkgs = pkgs;
      development-environment-init = development-environment-init;
    });
    go-dev-env = (import ./custom/containers/go-dev-env.nix {
      pkgs = pkgs;
      development-environment-init = development-environment-init;
    });
    javascript-dev-env = (import ./custom/containers/javascript-dev-env.nix {
      pkgs = pkgs;
      development-environment-init = development-environment-init;
    });
    java-dev-env = (import ./custom/containers/java-dev-env.nix {
      pkgs = pkgs;
      development-environment-init = development-environment-init;
    });
   emacs = (import ./custom/containers/emacs.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    chromium = (import ./custom/containers/chromium.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    gnucash = (import ./custom/containers/gnucash.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    gnucash-2 = (import ./custom/containers/gnucash-2.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
   old-secrets = (import ./custom/containers/old-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    browser-secrets = (import ./custom/containers/browser-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
    system-secrets = (import ./custom/containers/system-secrets.nix {
      pkgs = pkgs;
      pass = installed-pass;
    });
  };
  hardware = {
    pulseaudio.enable = true;
  };
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  imports = [
    ./hardware-configuration.nix
    ./installed/password.nix
  ];
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "wl01";
    };
  };
  programs.bash.shellInit = "${pkgs.xorg.xhost}/bin/xhost +local:";
  security.sudo.wheelNeedsPassword = false;
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
	userServices = true;
      };
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "31 *  * * * user nix-collect-garbage"
      ];
    };
    physlock = {
      allowAnyUser = true;
      disableSysRq = true;
      enable = true;
      lockOn = {
        extraTargets = [];
        hibernate = false;
        suspend = false;
      };
    };
    printing.enable = true;
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  sound.enable = true;
  system.stateVersion = "18.03";
  system.autoUpgrade = {
    enable = true;
  };
  systemd.services = {
    docker-image-emacs = (import ./custom/utils/docker-image.nix {
       name = "emacs";
       contents = [ pkgs.bash pkgs.coreutils pkgs.git ];
       entrypoint = [ "${emacs-entrypoint}/bin/emacs-entrypoint" ];
    });
    docker-image-pass = (import ./custom/utils/docker-image.nix {
      name = "pass";
      contents = [ pass-entrypoint pkgs.bash ];
      entrypoint = [ "${pass-entrypoint}/bin/pass-entrypoint" ];
    });
  };
  systemd.services.foo = {
    description = "FOO Daemon";
    enable = true;
    serviceConfig = {
      Type = "forking";
      ExecStart = "${initialization}/bin/initialization";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
  time.timeZone = "US/Eastern";
  users = {
    mutableUsers = false;
    extraUsers.user.isNormalUser = true;
    extraUsers.user.uid = 1000;
    extraUsers.user.extraGroups = [ "wheel" "docker" "vboxusers" ];
    extraUsers.user.packages = [
      old-secrets
      launch-configuration-ide
      launch-atom-ide
      launch-lighttable-ide
      launch-emacs-ide
      zoom
      (import ./installed/pass/default.nix {})
      (import ./installed/default.nix { inherit pkgs; })
      (import ./custom/native/utils/default.nix {})
      (import ./custom/native/create-installation-media/default.nix {})
      (import ./custom/native/validate-not-blank/default.nix {})
      (import ./custom/system/update-nixos/default.nix { inherit pkgs; })
      (import ./custom/user/atom/default.nix {})
      initialization
      pkgs.emacs
      pkgs.networkmanager
      pkgs.gnome3.gnome-terminal
      pkgs.recordmydesktop
      pkgs.git
      pkgs.zip
      pkgs.unzip
      pkgs.chromium
      pkgs.physlock
      pkgs.nixops
      pkgs.lighttable
      my-atom
      pkgs.netbeans
      pkgs.jetbrains.idea-community
      pkgs.maven
      pkgs.docker_compose
      pkgs.jdk10
      pkgs.cdrkit
      (import ./custom/native/node/default.nix {
        pkgs = pkgs;
      })
      (import ./custom/utils/custom-derivation.nix {
         name = "helloworld";
	 src = ./custom/temporary/helloworld;
	 dependencies = [ pkgs.coreutils ];
      })
      (import ./custom/utils/custom-script-derivation.nix {
         name = "foobar";
	 src = ./custom/scripts/foobar;
	 dependencies = [ pkgs.coreutils pkgs.findutils ];
      })
      post-commit
    ];
  };
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
      dates = "daily";
    };
  };
}
# lpadmin -p myprinter -E -v ipp://10.1.10.113/ipp/print -m everywhere
