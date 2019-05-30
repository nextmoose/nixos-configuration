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
  enableOCR = true;
  testScript = ''
    $machine->start;
    $machine->waitForUnit('multi-user.target');
    $machine->sendChars("user\n");
    $machine->waitUntilSucceeds("sleep 1");
    $machine->sendChars("password\n");
    $machine->waitUntilSucceeds("sleep 2");
    $machine->sendChars("mkdir /tmp/source\n");
    $machine->sendChars("mkdir /tmp/source/public\n");
    $machine->sendChars("touch /tmp/source/configuration.nix\n");
    $machine->sendChars("mkdir /tmp/work\n");
    $machine->sendChars("configure-nixos --work-dir /tmp/work --source-dir /tmp/source\n");
    $machine->waitUntilSucceeds("sleep 3");
    $machine->screenshot('shot00100');
    print($machine->getScreenText('whatever', 'wtf'));
    $machine->shutdown;
  '';
}