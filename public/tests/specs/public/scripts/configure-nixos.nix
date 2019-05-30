import /nix/store/wl7y85xg46dsl5a7jjvqqdg1zbf678zn-nixos-18.03.133389.b551f89e256/nixos/nixos/tests/make-test.nix {
  machine = { pkgs, ... } : {
    environment.systemPackages = [
      pkgs.which
    ];
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [
          (import ../../../../staples.nix {
            pkgs = pkgs;
          }).configure-nixos
        ];
        password = "password";
      };
    };
  };
  testScript = ''
    $machine->start;
    $machine->waitForUnit('multi-user.target');
    $machine->sendChars("user\n");
    $machine->waitUntilSucceeds("sleep 10");
    $machine->sendChars("password\n");
    $machine->waitUntilSucceeds("sleep 10");
    $machine->screenshot('shot00100');
    $machine->shutdown;
  '';
}