{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  initialization-utils = (import ../initialization-utils/default.nix { inherit pkgs; });
  backup-utils = (import ../backup-utils/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "container-initializations";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/aws-secrets.sh $out/bin/aws-secrets --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/browser-secrets.sh $out/bin/browser-secrets --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/old-secrets.sh $out/bin/old-secrets --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/chromium.sh $out/bin/chromium --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/configuration.sh $out/bin/configuration --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/sadscissors.sh $out/bin/sadscissors --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/gnucash.sh $out/bin/gnucash --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      makeWrapper $out/scripts/gnucash-2.sh $out/bin/gnucash-2 --set PATH ${lib.makeBinPath [ initialization-utils coreutils pkgs.awscli pkgs.which mktemp gnome2.GConf which backup-utils ]} --set STORE_DIR "$out" --set AWS_PATH "${pkgs.awscli}" &&
      makeWrapper $out/scripts/gnucash-3.sh $out/bin/gnucash-3 --set PATH ${lib.makeBinPath [ initialization-utils backup-utils ]} --set STORE_DIR "$out" --set AWS_PATH "${pkgs.awscli}" &&
      makeWrapper $out/scripts/paperwork.sh $out/bin/paperwork --set PATH ${lib.makeBinPath [ initialization-utils ]} &&
      true
  '';
}
