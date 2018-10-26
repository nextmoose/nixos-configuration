{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "update-nixos";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp head.txt tail.txt $out/etc &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/create-nixos-object.sh $out/bin/create-nixos-objects --set PATH ${lib.makeBinPath [ coreutils findutils ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/update-nixos.sh $out/bin/update-nixos --set PATH ${lib.makeBinPath [ "$out" "/run/wrappers" nixos-rebuild coreutils rsync nixos-container gnugrep systemd mktemp ]} --set STORE_DIR $out &&
      true
  '';
}
