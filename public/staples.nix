{
  pkgs ? import <nixpkgs> {},
#  make-test ? import <nixpkgs/nixos/tests/make-test.nix>,
  make-test ? import ./utilities/testing/nixos/tests/make-test.nix
} :
let
script = import ./utilities/script.nix {
  pkgs = pkgs;
  make-test = make-test;
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
    test-script = ./tests/configure-nixos.pl;
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
    test-script = ./tests/configure-nixos.pl;
  });
}
