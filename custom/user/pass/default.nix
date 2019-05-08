{
  pkgs,
  name,
  uuid,
  docker-container-id
}:
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . "$out/src" &&
      chmod 0500 "$out/src/pass.sh &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/pass.sh" \
	"$out/bin/${name}" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.docker docker-container-id ]}" \
	--set UUID "${uuid}" &&
      true
  '';
}