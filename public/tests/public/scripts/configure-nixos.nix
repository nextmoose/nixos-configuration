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
    $machine->screenshot("shot00");

      $machine->sendChars("user\n");
      $machine->waitUntilTTYMatches(1, "login: user");
      $machine->waitUntilSucceeds("pgrep login");
      $machine->waitUntilTTYMatches(1, "Password: ");
      $machine->sendChars("password\n");
      $machine->waitUntilSucceeds("pgrep -u user bash");
      $machine->screenshot("shot01");

      $machine->sendChars("configure-nixos\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SALT");
      $machine->screenshot("shot02");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SOURCE_DIR");
      $machine->screenshot("shot03");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir /tmp/source\n");
      $machine->waitUntilTTYMatches(1, "Nonexistent SOURCE_DIR");
      $machine->screenshot("shot04");

      $machine->waitUntilSucceeds("mkdir /tmp/source");
      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir /tmp/source\n");
      $machine->waitUntilTTYMatches(1, "Unspecified USER_PASSWORD");
      $machine->screenshot("shot05");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir /tmp/source --user-password password\n");
      $machine->waitUntilTTYMatches(1, "Unspecified WORK_DIR");
      $machine->screenshot("shot06");

      $machine->waitUntilSucceeds("mkdir /tmp/work");
      $machine->waitUntilSucceeds("chown user:users /tmp/work");
      $machine->waitUntilSucceeds("echo 6e124f0a-3fd8-4d04-b5b0-96c585c70bbc > /tmp/source/configuration.nix");
      $machine->waitUntilSucceeds("mkdir /tmp/source/public");
      $machine->waitUntilSucceeds("echo 98f867b0-2265-4ac5-b642-d898414799eb > /tmp/source/public/73e14034-7857-4a49-b437-55ac609630e1");
      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir /tmp/source --user-password 4dcf1fe1-7973-467e-beb9-222eaeeb21ab --work-dir /tmp/work\n");
      $machine->waitForFile("/tmp/work/configuration.nix");
      $machine->waitForFile("/tmp/work/public/73e14034-7857-4a49-b437-55ac609630e1");
      $machine->waitForFile("/tmp/work/private/user-password.hashed.asc");
      $machine->screenshot("shot07");

      $machine->sendChars("cat /tmp/work/configuration.nix\n");
      $machine->waitUntilTTYMatches(1, "6e124f0a-3fd8-4d04-b5b0-96c585c70bbc");
      $machine->screenshot("shot08");

      $machine->sendChars("cat /tmp/work/public/73e14034-7857-4a49-b437-55ac609630e1\n");
      $machine->waitUntilTTYMatches(1, "98f867b0-2265-4ac5-b642-d898414799eb");
      $machine->screenshot("shot09");

      $machine->sendChars("cat /tmp/work/private/user-password.hashed.asc\n");
#      $machine->waitUntilTTYMatches(1, '$6$D1V7GGg0DjvHW4TY$v163wrp9KU/GBooAuoxD7tzG.NSjS71AExx.I0aWtrSPZ.CBRSPS3e9Wp6l8gTkjen4u3mL4NtyrHGPbWJ5B50');
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->screenshot("shot10");


    $machine->shutdown;
  '';
}