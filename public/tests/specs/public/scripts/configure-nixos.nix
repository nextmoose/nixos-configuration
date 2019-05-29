import /nix/store/wl7y85xg46dsl5a7jjvqqdg1zbf678zn-nixos-18.03.133389.b551f89e256/nixos/nixos/tests/make-test.nix {
  machine = { pkgs, ... } : {
    environment.systemPackages = [
      pkgs.emacs
    ];
  };
  testScript = ''
    $machine->start;
    $machine->waitForUnit('multi-user.target');
    $machine->waitUntilSucceeds("ls /");
    $machine->screenshot('shot00100');
    $machine->shutdown;
  '';
}