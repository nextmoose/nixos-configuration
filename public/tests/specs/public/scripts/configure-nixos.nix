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
    $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
    $machine->screenshot("postboot");

    $machine->sendChars("user\n");
    $machine->waitUntilTTYMatches(1, "login: user");
    $machine->waitUntilSucceeds("pgrep login");
    $machine->waitUntilTTYMatches(1, "Password: ");
    $machine->sendChars("password\n");
    $machine->waitUntilSucceeds("pgrep -u user bash");
    $machine->screenshot("postlogin");

    $machine->shutdown;
  '';
}