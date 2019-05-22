{
  pkgs,
  name,
  uuid,
  run,
  entrypoint
} :
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper entrypoint ];
  installPhase = ''
    mkdir "$out" &&
      cp --recursive . "$out/src" &&
      true
  '';
}