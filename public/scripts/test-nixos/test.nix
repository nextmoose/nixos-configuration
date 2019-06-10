import <nixpkgs/nixos/tests/make-test.nix> {
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [
          (import ../../../staples.nix {
            pkgs = pkgs;
          }).configure-nixos
        ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile ${TEST_SCRIPT});
}