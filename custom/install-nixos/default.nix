{
  pkgs ? import <nixpkgs> {}
} :
pkgs.stdenv.mkDerivation {
  name = "install-nixos";
  src = ../..;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/etc/install-nixos &&
      cp --recursive . $out/etc/install-nixos &&
      mkdir $out/usr &&
      mkdir $out/usr/src &&
      echo AAAA &&
      ls -alh $out &&
      echo AAAA &&
      ls -alh $out/etc &&
      echo AAAA &&
      ls -alh $out/etc/install-nixos &&
      echo AAAA &&
      ls -alh $out/etc/install-nixos/custom &&
      echo AAAA &&
      ls -alh $out/etc/install-nixos/custom/install-nixos &&
      echo AAAA &&
      ls -alh $out/etc/install-nixos/custom/install-nixos/install-nixos.sh &&
      cp $out/etc/install-nixos/custom/install-nixos/install-nixos.sh $out/usr/src &&
      chmod 0500 $out/usr/src/install-nixos.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/usr/src/install-nixos.sh \
        $out/bin/install-nixos \
        --set PATH "${pkgs.lib.makeBinPath []}" \
        --set STORE_DIR "$out" &&
      true
  '';
}
