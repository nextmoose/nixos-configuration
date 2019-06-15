{
  make-test ? import <nixpkgs/nixos/tests/make-test.nix>,
  implementation,
  test-script
} :
(make-test {
  name = "configure-nixos";
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers = {
        user1 = {
          isNormalUser = true;
          uid = 1001;
          packages = [ implementation ];
          password = "password1";
        };
        user2 = {
          isNormalUser = true;
          uid = 1002;
          password = "password2";
        };
      };
    };
  };
  testScript = (builtins.readFile test-script);
})
