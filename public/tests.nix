{
  staples
} :
{
  configure-nixos = (import ./utilities/test-script-derivation.nix {
    implementation = staples.configure-nixos;
    test-script = ./tests/configure-nixos.pl;
  });
}