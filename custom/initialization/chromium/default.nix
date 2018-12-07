{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg = (import ../gnupg/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  dot-ssh = (import ../dot-ssh/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  gnupg-key-id = (import ../../native/gnupg-key-id/default.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/chromium.sh \
        $out/bin/chromium \
        --set PATH ${pkgs.lib.makeBinPath [ gnupg dot-ssh gnupg-key-id pkgs.pass pkgs.which pkgs.coreutils pkgs.gnugrep pkgs.findutils]} &&
      true
  '';
}
