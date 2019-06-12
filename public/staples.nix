{
  pkgs
} :
rec {
  configure-nixos = (import ./utils/script-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = scripts/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
    ];
  });
  tests = (import ./utils/script-derivation.nix {
    pkgs = pkgs;
    name = "tests";
    src = scripts/tests;
    dependencies = [
      pkgs.jq
      pkgs.chromium
    ];
    configuration = {
      configure-nixos = (import ./utils/test-script-derivation.nix {
        implementation = configure-nixos;
	test-script = ./tests/configure-nixos.pl;
      } {
        pkgs = pkgs;
      });
    };
  });
}
