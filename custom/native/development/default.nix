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
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ coreutils pass gnupg git bash bash-completion openssh emacs "$out" utillinux maven which nodejs-10_x less ]} --set STORE_DIR "$out" &&
      makeWrapper $out/scripts/git-curt.sh $out/bin/git-curt --set PATH ${lib.makeBinPath [ git ]} &&
      makeWrapper $out/scripts/git-standing.sh $out/bin/git-standing --set PATH ${lib.makeBinPath [ git ]} &&
      makeWrapper $out/scripts/git-refresh.sh $out/bin/git-refresh --set PATH ${lib.makeBinPath [ git "$out" utillinux ]} &&
      makeWrapper $out/scripts/git-prepare.sh $out/bin/git-prepare --set PATH ${lib.makeBinPath [ git "$out" utillinux ]} &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ coreutils git ]} &&
      makeWrapper $out/scripts/pre-push.sh $out/scripts/pre-push --set PATH ${lib.makeBinPath [ coreutils git ]} &&
      true
  '';
}
