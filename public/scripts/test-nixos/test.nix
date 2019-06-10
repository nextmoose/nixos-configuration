import ${MAKE_TEST_FILE} {
  machine = { pkgs, ... } : {
    users = {
      mutableUsers = false;
      extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        packages = [
          (import ${SOURCE_DIR}/public/staples.nix {
            pkgs = pkgs;
          }).configure-nixos
        ];
        password = "7b28e9e8-5a90-42ce-bbbb-908ad375d191";
      };
    };
  };
  testScript = ''
    $machine->start;
    $machine->waitForUnit("multi-user.target");
    $machine->waitUntilSucceeds("pgrep -f 'agetty.*tty1'");
    $machine->screenshot("shot00");

      $machine->sendChars("user\n");
      $machine->waitUntilTTYMatches(1, "login: user");
      $machine->waitUntilSucceeds("pgrep login");
      $machine->waitUntilTTYMatches(1, "Password: ");
      $machine->sendChars("7b28e9e8-5a90-42ce-bbbb-908ad375d191\n");
      $machine->waitUntilSucceeds("pgrep -u user bash");
      $machine->screenshot("shot01");

    $machine->shutdown;
  '';
}