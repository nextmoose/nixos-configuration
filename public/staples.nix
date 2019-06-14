{
  pkgs
} :
rec {
  configure-nixos = (import ./utilities/script.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
    ];
    test-script = ./tests/configure-nixos.pl;
  });
  tests = (import ./utilities/script.nix {
    pkgs = pkgs;
    name = "tests";
    src = scripts/tests;
    dependencies = [
      pkgs.jq
      pkgs.chromium
      pkgs.gnugrep
      pkgs.coreutils
    ];
    configuration = {
      configure-nixos = (import ./utilities/script-test.nix {
        implementation = configure-nixos.implementation;
	test-script = ./tests/configure-nixos.pl;
      }) {
        pkgs = pkgs;
      };
    };
    test-script = ./tests/configure-nixos.pl;
  });
}
