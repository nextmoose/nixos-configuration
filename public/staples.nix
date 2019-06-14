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
  test-scripts = (import ./utilities/script.nix {
    pkgs = pkgs;
    name = "test-scripts";
    src = scripts/test-scripts;
    dependencies = [
      pkgs.jq
      pkgs.chromium
      pkgs.gnugrep
      pkgs.coreutils
    ];
    configuration = {
      configure-nixos = {
        results = configure-nixos.testing.results;
      };
    };
    test-script = ./tests/configure-nixos.pl;
  });
}
