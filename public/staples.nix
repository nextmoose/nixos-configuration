{
  pkgs
} :
rec {
  configure-nixos = (import ./utilities/script-implementation-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
    ];
  });
  tests = (import ./utilities/script-implementation-derivation.nix {
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
      xconfigure-nixos = (import ./utilities/script-test.nix {
        implementation = configure-nixos;
	test-script = ./tests/configure-nixos.pl;
      });
    };
  });
}
