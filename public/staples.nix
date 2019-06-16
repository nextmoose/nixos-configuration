{
  pkgs ? import <nixpkgs> {},
  script-implementation-derivation ? import ./utilities/script-implementation-derivation.nix {
    pkgs = pkgs;
  }
} :
rec {
  configure-nixos = (script-implementation-derivation {
    pkgs = pkgs;
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
      pkgs.chromium
    ];
  });
  test-scripts = (script-implementation-derivation {
    pkgs = pkgs;
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
      configure-nixos = {
      };
    };
  });
}
