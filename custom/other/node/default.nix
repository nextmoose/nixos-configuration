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
    mkdir $out/home &&
    mkdir $out/home/npm-packages &&
    export HOME=$out/home &&
    export NPM_PACKAGES=$out/home/npm-packages &&
    echo OUT=$out &&
    echo $out/home/npm-packages > $out/home/npmrc &&
    ${node}/bin/npm install -g ${node-packages} &&
    makeWrapper \
      ${node}/bin/node \
      $out/bin/node \
      --set NPM_PACKAGES "$out/.npm-packages" &&
    makeWrapper \
      ${node}/bin/npm \
      --set NPM_PACKAGES "$out/npm-packages" &&
    makeWrapper \
        $out/scripts/global-init.sh \
        $out/bin/global-init \
        --set STORE_DIR "$out" &&
    true
  '';
}
