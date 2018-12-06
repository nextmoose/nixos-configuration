{
  pkgs ? import <nixpkgs> {},
  name,
  container-name,
  script-name
}:
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ]
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/exec.sh \
        $out/bin/${name} \
        --set CONTAINER_NAME "${container-name}" \
        --set SCRIPT_NAME "${script-name}" \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
  '';
}
