{
  stdenv,
  name,
  src ? ./src,
  build-dir ? "build",
  scripts-dir ? "scripts",
  lib-dir ? "lib"
} :
stdenv.mkDerivation {
  name = "${name}";
  src = "${src}";
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
      if [ -d "${lib-dir}" ]
      then
	cp --recursive "${lib-dir}" "${build-dir}" &&
	  chmod --recursive 0500 "${build-dir}"/"${lib-dir}"/. &&
	  true
      fi &&
      true
  '';
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
      true
  '';
}
