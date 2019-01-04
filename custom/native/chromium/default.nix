{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper pkgs.gnutar pkgs.gzip ];
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
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/chromium.sh \
        $out/bin/chromium \
        --set STORE_DIR "$out" \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.chromium pkgs.coreutils pkgs.gnugrep ]} &&
      true
  '';
}
