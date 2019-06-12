    $machine->start;
    $machine->waitForUnit('multi-user.target');
    $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
    $machine->screenshot("shot00");

      $machine->sendChars("user1\n");
      $machine->waitUntilTTYMatches(1, "login: user1");
      $machine->waitUntilSucceeds("pgrep login");
      $machine->waitUntilTTYMatches(1, "Password: ");
      $machine->sendChars("password1\n");
      $machine->waitUntilSucceeds("pgrep -u user1 bash");
      $machine->screenshot("shot01");

      $machine->sendChars("mkdir source\n");
      $machine->sendChars("mkdir work\n");
      $machine->sendChars("echo 6e124f0a-3fd8-4d04-b5b0-96c585c70bbc > source/configuration.nix\n");
      $machine->sendChars("mkdir source/public\n");
      $machine->sendChars("pwd\n");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("echo 98f867b0-2265-4ac5-b642-d898414799eb > source/public/x\n");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir source --user-password 4dcf1fe1-7973-467e-beb9-222eaeeb21ab --work-dir work\n");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("ls -alh\n");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("ls -alh work\n");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->screenshot("shot10");


    $machine->shutdown;
