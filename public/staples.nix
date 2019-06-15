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
      pkgs.chromium
    ];
    test-script = ./tests/configure-nixos.pl;
  });
  test-scripts = (import ./utilities/script.nix {
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
        implementation = configure-nixos.implementation;
        results = configure-nixos.testing.results;
	script = configure-nixos.script;
	mutants = configure-nixos.mutants;
      };
    };
    test-script = ./tests/configure-nixos.pl;
  });
}
