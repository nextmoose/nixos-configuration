    $machine->start;
    $machine->waitForUnit('multi-user.target');
    $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
    $machine->screenshot("shot01");

      $machine->sendChars("user1\n");
      $machine->waitUntilTTYMatches(1, "login: user1");
      $machine->waitUntilSucceeds("pgrep login");
      $machine->waitUntilTTYMatches(1, "Password: ");
      $machine->sendChars("password1\n");
      $machine->waitUntilSucceeds("pgrep -u user1 bash");
      $machine->screenshot("shot02");

      $machine->sendChars("configure-nixos ee1295c8-b797-442a-ba79-2ecebb60b430 059cec2e-e3a5-4d5a-bba9-b5112a7fed17\n");
      $machine->waitUntilTTYMatches(1, "Unsupported Option");
      $machine->waitUntilTTYMatches(1, "ee1295c8-b797-442a-ba79-2ecebb60b430");
      $machine->waitUntilTTYMatches(1, "ee1295c8-b797-442a-ba79-2ecebb60b430 059cec2e-e3a5-4d5a-bba9-b5112a7fed17");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->screenshot("shot03");

      $machine->sendChars("configure-nixos\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SALT");
      $machine->screenshot("shot04");

      $machine->sendChars("configure-nixos\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SALT");
      $machine->screenshot("shot05");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY\n");
      $machine->waitUntilTTYMatches(1, "Unspecified SOURCE_DIR");
      $machine->screenshot("shot06");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir source\n");
      $machine->waitUntilTTYMatches(1, "Nonexistent SOURCE_DIR");
      $machine->screenshot("shot07");

      $machine->sendChars("mkdir source && echo \${?}\n");
      $machine->waitUntilTTYMatches(1, "0");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir source\n");
      $machine->waitUntilTTYMatches(1, "Unspecified USER_PASSWORD");
      $machine->screenshot("shot08");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir source --user-password password\n");
      $machine->waitUntilTTYMatches(1, "Unspecified WORK_DIR");
      $machine->screenshot("shot09");

      $machine->sendChars("mkdir work && echo \${?}\n");
      $machine->waitUntilTTYMatches(1, "0");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("echo 6e124f0a-3fd8-4d04-b5b0-96c585c70bbc > source/configuration.nix && echo \${?}\n");
      $machine->waitUntilTTYMatches(1, "0");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->sendChars("mkdir source/public\n");
      $machine->waitUntilTTYMatches(1, "");
      $machine->sendChars("echo 98f867b0-2265-4ac5-b642-d898414799eb > source/public/73e14034-7857-4a49-b437-55ac609630e1 && echo \${?}\n");
      $machine->waitUntilTTYMatches(1, "0");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->screenshot("shot10");

      $machine->sendChars("configure-nixos --salt D1V7GGg0DjvHW4TY --source-dir source --user-password 4dcf1fe1-7973-467e-beb9-222eaeeb21ab --work-dir work && echo \${?}\n");
      $machine->waitUntilTTYMatches(1, "0");
      $machine->waitUntilSucceeds("sleep 10s");
      $machine->screenshot("shot11");

      $machine->waitForFile("/home/user1/work/configuration.nix");
      $machine->waitForFile("/home/user1/work/public/73e14034-7857-4a49-b437-55ac609630e1");
      $machine->waitForFile("/home/user1/work/private/user-password.hashed.asc");
      $machine->screenshot("shot12");

      $machine->sendChars("cat work/configuration.nix\n");
      $machine->waitUntilTTYMatches(1, "6e124f0a-3fd8-4d04-b5b0-96c585c70bbc");
      $machine->screenshot("shot13");

      $machine->sendChars("cat work/public/73e14034-7857-4a49-b437-55ac609630e1\n");
      $machine->waitUntilTTYMatches(1, "98f867b0-2265-4ac5-b642-d898414799eb");
      $machine->screenshot("shot14");

      $machine->sendChars("cat work/private/user-password.hashed.asc | base64\n");
      $machine->waitUntilTTYMatches(1, "MGFXdHJTUFouQ0JSU1BTM2U5V3A2bDhnVGtqZW40dTNtTDROdHlySEdQYldKNUI1MAo=");
      $machine->screenshot("shot15");


    $machine->shutdown;
