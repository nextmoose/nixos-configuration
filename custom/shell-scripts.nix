{
  pkgs,
  staples
} :
{
  pass = (import ./script-derivation.nix {
    pkgs = pkgs;
    name = "pass";
    src = ./scripts/pass;
    dependencies = [
      pkgs.coreutils
      pkgs.bash
    ];
  });
}