{
  pkgs ? import <nixpkgs>{},
  node ? pkgs.nodejs,
  node-packages ? ""
}:
pkgs.stdenv.mkDerivation {
  name = "node";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper node ];
  installPhase = ''
    mkdir $out &&
    mkdir $out/project &&
    cd $out/project &&
    npm install ${node-packages} &&
    ${node}/bin/npm install -g ${node-packages} &&
    makeWrapper \
      ${node}/bin/node \
      $out/bin/node &&
    makeWrapper \
      ${node}/bin/npm \
      ${node}/bin/npm &&
    makeWrapper \
        $out/scripts/global-init.sh \
        $out/bin/global-init \
        --set STORE_DIR "$out" &&
    true
  '';
}
