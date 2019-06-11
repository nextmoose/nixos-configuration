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
	    pkgs = pkgs;
	  })
        ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile ./test-script.pl);
}