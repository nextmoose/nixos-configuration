{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "chromium";
  src = ./src;
  buildInputs = [ makeWrapper gzip gnutar ];
  buildPhase = ''
    gunzip flash_player_ppapi_linux.x86_64.tar.gz &&
      mkdir adobe-flashplugin &&
      tar --extract --file flash_player_ppapi_linux.x86_64.tar --directory adobe-flashplugin &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      cp --recursive adobe-flashplugin $out/lib &&
      mkdir $out/scripts &&
      cp chromium.sh $out/scripts &&
      chmod 0500 $out/scripts/chromium.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/chromium.sh $out/bin/chromium --set PATH ${lib.makeBinPath [ chromium coreutils gnugrep ]} --set STORE_DIR "$out" &&
      true
  '';
}
