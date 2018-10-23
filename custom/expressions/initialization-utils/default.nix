{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  install = (import ../../../installed/init-read-only-pass/default.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "initialization-utils";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/secrets.sh $out/scripts/secrets --set PATH ${lib.makeBinPath [ mktemp coreutils install gzip gnutar gnupg pass ]} &&
      makeWrapper $out/scripts/ssh-remote.sh $out/scripts/ssh-remote --set PATH ${lib.makeBinPath [ coreutils ]} &&
      makeWrapper $out/scripts/project.sh $out/scripts/project --set PATH ${lib.makeBinPath [ coreutils git ]} --prefix STORE_DIR=$out &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ git coreutils ]} &&
      makeWrapper $out/scripts/pre-push.sh $out/scripts/pre-push --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  '';
}
