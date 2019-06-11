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
  test-nixos = (import ./utils/script-derivation.nix {
    pkgs = pkgs;
    name = "test-nixos";
    src = scripts/test-nixos;
    dependencies = [
      pkgs.findutils
      pkgs.coreutils
      pkgs.gnused
      pkgs.nix
    ];
  });
}
