{
  pkgs ? import <nixpkgs> {},
  script-derivation ? import ./utilities/script-derivation.nix {
    pkgs = pkgs;
  }
} :
rec {
  configure-nixos = (script-derivation {
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
      pkgs.chromium
    ];
  });
  mutation-tests = (script-derivation {
    name = "mutation-tests";
    src = scripts/mutation-tests;
    dependencies = [
      pkgs.jq
      pkgs.chromium
      pkgs.gnugrep
      pkgs.coreutils
      pkgs.nix
    ];
  });
  test-scripts = (script-derivation {
    name = "test-scripts";
    src = scripts/test-scripts;
    dependencies = [
      pkgs.jq
      pkgs.chromium
      pkgs.gnugrep
      pkgs.coreutils
      pkgs.nix
    ];
  });
}
