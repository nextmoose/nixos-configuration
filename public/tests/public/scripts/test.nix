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
	    staples = (import ../../../staples.nix {
	      pkgs = pkgs;
	    });
	  })
#          (import ../../../staples.nix {
#            pkgs = pkgs;
#          }).configure-nixos
        ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile ./configure-nixos.pl);
}