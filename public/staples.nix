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
