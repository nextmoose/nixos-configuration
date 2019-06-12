{
  pkgs
} :
rec {
  configure-nixos = (import ./utils/script-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    implementation = scripts/configure-nixos/implementation;
    test-script = scripts/configure-nixos/test-script.pl;
    dependencies = [
      pkgs.coreutils
      pkgs.mkpasswd
    ];
  });
}
