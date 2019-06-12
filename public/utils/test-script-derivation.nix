{
  implementation,
  test-script
} :
(import <nixpkgs/nixos/tests/make-test.nix> {
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [ implementation ];
        password = "password";
      };
    };
  };
  testScript = (builtins.readFile test-script);
})