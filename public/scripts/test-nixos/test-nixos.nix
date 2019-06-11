import <nixpkgs/nixos/tests/make-test.nix> {
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [
	  (import ./package.nix {
	    staples = (import (builtins.getEnv "STAPLES_FILE") {
	      pkgs = pkgs;
	    });
	  })
        ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile (builtins.getEnv "TEST_SCRIPT"));
}