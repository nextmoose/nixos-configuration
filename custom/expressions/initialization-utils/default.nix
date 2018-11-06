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
      cp --recursive lib $out/lib &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/secrets.sh $out/bin/secrets --set PATH ${lib.makeBinPath [ mktemp coreutils install gzip gnutar gnupg pass ]} --set INSTALL_DIR ${install} &&
      makeWrapper $out/scripts/gnucash-2.sh $out/bin/gnucash --set PATH ${lib.makeBinPath [ coreutils gnome2.GConf gnucash ]} --set STORE_DIR "$out" &&
      makeWrapper $out/scripts/ssh-remote.sh $out/bin/ssh-remote --set PATH ${lib.makeBinPath [ coreutils ]} &&
      makeWrapper $out/scripts/project.sh $out/bin/project --set PATH ${lib.makeBinPath [ coreutils git ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/read-only-pass.sh $out/bin/read-only-pass --set PATH ${lib.makeBinPath [ coreutils pass gnupg ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/read-write-pass.sh $out/bin/read-write-pass --set PATH ${lib.makeBinPath [ coreutils pass gnupg ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/aws.sh $out/bin/aws --set PATH ${lib.makeBinPath [ coreutils pass awscli ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/restore.sh $out/bin/restore --set PATH ${lib.makeBinPath [ coreutils gnupg pass awscli mktemp gnutar gzip ]} --set STORE_DIR $out &&
      makeWrapper $out/scripts/post-commit.sh $out/scripts/post-commit --set PATH ${lib.makeBinPath [ git coreutils ]} &&
      makeWrapper $out/scripts/pre-push.sh $out/scripts/pre-push --set PATH ${lib.makeBinPath [ coreutils ]} &&
      makeWrapper $out/scripts/pre-commit.sh $out/scripts/pre-commit --set PATH ${lib.makeBinPath [ coreutils ]} &&
      true
  '';
}
