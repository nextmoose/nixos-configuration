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

      $machine->sendChars("test-nixos\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SOURCE_DIR");
      $machine->screenshot("shot02");

      $machine->sendChars("test-nixos --source-dir source\n");
      $machine->waitUntilTTYMatches(1, "Nonexistant SOURCE_DIR source");
      $machine->screenshot("shot03");

      $machine->sendChars("mkdir source\n");
      $machine->sendChars("test-nixos --source-dir source\n");
      $machine->waitUntilTTYMatches(1, "Nonexistant SOURCE_DIR source");
      $machine->screenshot("shot03");

    $machine->shutdown;
