{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg-import = (import ../../utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "gnupg-import";
    src = ../../scripts/gnupg-import;
    dependencies = [ pass pkgs.coreutils pkgs.gnupg ];
  });
in
pkgs.stdenv.mkDerivation {
  name = "gnucash";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out &&
      chmod 0400 $out/lib/* &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      makeWrapper \
        $out/scripts/gnucash.sh \
        $out/bin/gnucash \
        --set STORE_DIR "$out" \
        --set PATH ${pkgs.lib.makeBinPath [  pkgs.gnucash  pass  pkgs.coreutils gnupg-import pkgs.aws-cli ]} &&
     true
  '';
}
