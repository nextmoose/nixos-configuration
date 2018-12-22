{ config, pkgs, ... }:
let
  installed-pass = (import ./installed/pass/default.nix{
    pkgs = pkgs;
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
    dependencies = [ gnupg-import dot-ssh-init pkgs.coreutils pkgs.git dot-ssh-add-domain pkgs.which post-commit ];
  });
  emacs-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "emacs-entrypoint";
    src= ./custom/scripts/emacs-entrypoint;
    dependencies = [ development-environment-init pkgs.emacs ];
  });
  atom-entrypoint = (import ./custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "atom-entrypoint";
    src= ./custom/scripts/atom-entrypoint;
    dependencies = [ development-environment-init pkgs.atom ];
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
  systemd.services = {
    docker-image-atom = (import ./custom/utils/docker-image.nix {
       name = "atom";
       entrypoint = [ "${atom-entrypoint}/bin/atom-entrypoint" ];
    });
    docker-image-emacs = (import ./custom/utils/docker-image.nix {
       name = "emacs";
       entrypoint = [ "${emacs-entrypoint}/bin/emacs-entrypoint" ];
    });
    docker-image-pass = (import ./custom/utils/docker-image.nix {
      name = "pass";
      contents = [ pass-entrypoint pkgs.bash ];
      entrypoint = [ "${pass-entrypoint}/bin/pass-entrypoint" ];
    });
    docker-image-lighttable = (import ./custom/utils/docker-image.nix {
      name = "lighttable";
      entrypoint = [ "${lighttable}/bin/lighttable" ];
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
    extraUsers.user.extraGroups = [ "wheel" "docker" ];
    extraUsers.user.packages = [
      old-secrets
      launch-configuration-ide
      launch-atom-ide
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
