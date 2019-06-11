import <nixpkgs/nixos/tests/make-test.nix> {
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [
	  (import ./expression.nix {
	    staples = (import (builtins.getEnv "SOURCE_DIR") {
	      pkgs = pkgs;
	    });
	  })
        ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile ./configure-nixos.pl);
}