#!/bin/sh
{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "ssh-utils";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp config $out/etc &&
      mkdir $out/scripts &&
      cp init-dot-ssh.sh $out/scripts &&
      chmod 0500 $out/scripts/init-dot-ssh.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/init-dot-ssh.sh $out/bin/init-dot-ssh --set PATH ${lib.makeBinPath [ coreutils ]} --set STORE_DIR $out &&
      true
  ''; 
}

pass git remote add origin 
