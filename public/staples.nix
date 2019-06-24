{
  pkgs ? import <nixpkgs> {}
} :
let
script = import ./utilities/script.nix {
  pkgs = pkgs;
};
in
rec {
  configure-nixos = (script {
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
    ];
    test-script = ./bats/configure-nixos.sh;
  });
  gnupg-key-id = (script {
    name = "gnupg-key-id";
    src = scripts/gnupg-key-id;
    dependencies = [
      pkgs.gnupg
      pkgs.gnused
      pkgs.gnugrep
      pkgs.coreutils
    ];
    test-script = ./bats/configure-nixos.sh;
  });
  init-read-only-pass = (script {
    name = "init-read-only-pass";
    src = scripts/init-read-only-pass;
    dependencies = [
      gnupg-key-id.implementation
      pkgs.gnupg
      pkgs.pass
      pkgs.git
      pkgs.coreutils
      pkgs.mktemp
      pkgs.bash
    ];
    test-script = ./bats/configure-nixos.sh;
  });
  test-scripts = (script {
    name = "test-scripts";
    src = scripts/test-scripts;
    dependencies = [
      pkgs.jq
      pkgs.chromium
      pkgs.gnugrep
      pkgs.coreutils
      pkgs.nix
    ];
    configuration = {
      configure-nixos = configure-nixos.testing;
    };
    test-script = ./bats/configure-nixos.sh;
  });
}
