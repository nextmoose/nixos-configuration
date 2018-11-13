{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "development";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      chmod 0400 $out/lib/* &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ coreutils pass gnupg git bash bash-completion openssh emacs "$out" ]} --set STORE_DIR "$out" &&
      makeWrapper $out/scripts/git-curt.sh $out/bin/git-curt --set PATH ${lib.makeBinPath [ git ]} &&
      makeWrapper $out/scripts/git-standing.sh $out/bin/git-standing --set PATH ${lib.makeBinPath [ git ]} &&
      makeWrapper $out/scripts/git-refresh.sh $out/bin/git-refresh --set PATH ${lib.makeBinPath [ git "$out" util-linux ]} &&
      makeWrapper $out/scripts/git-prepare.sh $out/bin/git-prepare --set PATH ${lib.makeBinPath [ git "$out" util-linux ]} &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ coreutils git ]} &&
      true
  '';
}
