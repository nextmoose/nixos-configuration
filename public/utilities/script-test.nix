{
  pkgs,
  make-test ? (import ./testing/make-test.nix {
    pkgs = pkgs;
  }),
  implementation,
  test-script
} :
(make-test {
  pkgs = pkgs;
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
}){
}