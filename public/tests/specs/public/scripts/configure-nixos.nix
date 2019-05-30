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

      $machine->sendChars("configure-nixos\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SOURCE_DIR");
      $machine->screenshot("post1");

      $machine->sendChars("configure-nixos --source-dir /tmp/source\n");
      $machine->waitUntilTTYMatches(1, "Nonexistent SOURCE_DIR");
      $machine->screenshot("post2");

      $machine->waitUntilSucceeds("mkdir /tmp/source");
      $machine->sendChars("configure-nixos --source-dir /tmp/source\n");
      $machine->waitUntilTTYMatches(1, "Unspecified USER_PASSWORD");
      $machine->screenshot("post3");

      $machine->sendChars("configure-nixos --source-dir /tmp/source --user-password password\n");
      $machine->waitUntilTTYMatches(1, "Unspecified WORK_DIR");
      $machine->screenshot("post4");

      $machine->sendChars("configure-nixos --source-dir /tmp/source\n --user-password password --work-dir /tmp/work");
      $machine->waitUntilTTYMatches(1, "Nonexistent WORK_DIR");
      $machine->screenshot("post2");

      $machine->waitUntilSucceeds("mkdir /tmp/work");
      $machine->sendChars("configure-nixos --source-dir /tmp/source\n --user-password password --work-dir /tmp/work");
      $machine->waitUntilTTYMatches(1, "Nonexistent WORK_DIR");
      $machine->screenshot("post2");

    $machine->shutdown;
  '';
}