{
  pkgs ? import <nixpkgs>{},
  name,
  src,
  build-dir ? "build",
  scripts-dir ? "scripts",
  bin-dir ? "bin",
  lib-dir ? "lib",
  wrappersScript
} :
let
  xname = "${name}";
  xsrc = "${src}";
in
pkgs.stdenv.mkDerivation rec {
  name = "${xname}";
  src = "${xsrc}";
  buildInputs = [ pkgs.makeWrapper ];
  buildPhase = ''
    if [ -d "${build-dir}" ]
    then
      echo "build directory ${build-dir} already exists." &&
	exit 67 &&
	true
    fi &&
      mkdir "${build-dir}" &&
      if [ -d "${scripts-dir}" ]
      then
	cp --recursive "${scripts-dir}" "${build-dir}" &&
	  chmod --recursive 0500 "${build-dir}"/"${scripts-dir}"/. &&
	  true
      fi &&
      if [ -d "${bin-dir}" ]
      then
	cp --recursive "${bin-dir}" "${build-dir}" &&
	  chmod --recursive 0500 "${build-dir}"/"${bin-dir}"/. &&
	  true
      fi &&
      if [ -d "${lib-dir}" ]
      then
	cp --recursive "${lib-dir}" "${build-dir}" &&
	  chmod --recursive 0500 "${build-dir}"/"${lib-dir}"/. &&
	  true
      fi &&
      true
  '';
  wrappers = wrappersScript {
    out = $out;
    pkgs = ${pkgs};
  };
  installPhase = ''
    mkdir $out &&
      if [ -d "${build-dir}"/"${scripts-dir}" ]
      then
	cp --recursive "${build-dir}"/"${scripts-dir}" $out &&
	  true
      fi &&
      if [ -d "${build-dir}"/"${lib-dir}" ]
      then
	cp --recursive "${build-dir}"/"${lib-dir}" $out &&
	  true
      fi &&
      "${wrappers}" &&
      true
  '';
}
