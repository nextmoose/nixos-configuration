{
  pkgs
} :
rec {
  configure-nixos = (import ./utils/script-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = scripts/configure-nixos;
  });
}
