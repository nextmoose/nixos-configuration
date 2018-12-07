{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg = (import ../gnupg/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  gnupg-key-id = (import ../../native/gnupg-key-id/default.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "gnucash";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/gnucash.sh \
        $out/bin/gnucash \
        --set STORE_DIR $out \
        --set PATH ${pkgs.lib.makeBinPath [ gnupg pkgs.coreutils pkgs.gnugrep pkgs.findutils ]} &&
      true
  '';
}
