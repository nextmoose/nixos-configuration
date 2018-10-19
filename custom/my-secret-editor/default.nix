{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  postcommit = writeShellScriptBin "post-commit" ''
    while ! ${pkgs.git}/bin/git push origin $(${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD --)
      do
        ${pkgs.coreutils}/binsleep 1s
      done
'';
  prepush = writeShellScriptBin "pre-push" ''
    exit 0
  '';
in
stdenv.mkDerivation rec {
  name = "my-secret-editor";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp run.sh $out/scripts/run.sh
      mkdir $out/bin &&
      makeWrapper $out/scripts/run.sh $out/bin/init-my-env --set PATH ${lib.makeBinPath [ network-manager gnupg pass coreutils git postcommit prepush ]} --set STORE_DIR $out &&
      true
  '';
}
