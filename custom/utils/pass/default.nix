{
  pkgs ? import <nixpkgs> {},
  name,
  uuid,
  origin-repository
}:
let
  pass = (import ../../../installed/pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "${pass}";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
	$out/bin/${name} \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST "github.com" \
	--set ORIGIN_USER "git" \
	--set ORIGIN_PORT "22" \
	--set ORIGIN_ORGANIZATION "nextmoose" \
	--set ORIGIN_REPOSITORY "${origin-repository}" \
	--set ORIGIN_BRANCH "master" \
	--set UUID "${uuid}" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pass ]} &&
      true
  '';
}
