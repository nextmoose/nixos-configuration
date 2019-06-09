import /nix/store/wl7y85xg46dsl5a7jjvqqdg1zbf678zn-nixos-18.03.133389.b551f89e256/nixos/nixos/tests/make-test.nix {
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

      $machine->waitUntilSucceeds("mkdir /tmp/work");
      $machine->waitUntilSucceeds("chown user:users /tmp/work");
      $machine->waitUntilSucceeds("touch /tmp/source/configuration.nix");
      $machine->waitUntilSucceeds("mkdir /tmp/source/public");
      $machine->waitUntilSucceeds("touch /tmp/source/public/stuff.txt");
      $machine->sendChars("configure-nixos --source-dir /tmp/source --user-password 4dcf1fe1-7973-467e-beb9-222eaeeb21ab --work-dir /tmp/work\n");
      $machine->waitForFile("/tmp/work/configuration.nix");
      $machine->waitForFile("/tmp/work/public/stuff.txt");
      $machine->waitForFile("/tmp/work/private/user-password.hashed.asc");
      $machine->screenshot("post5");

      $machine->sendChars("cat /tmp/work/private/user-password.hashed.asc\n");
      $machine->waitUntilSucceeds("sleep 20s");
      # this is a perl comment
      $machine->screenshot("post6");

    $machine->shutdown;
  '';
}