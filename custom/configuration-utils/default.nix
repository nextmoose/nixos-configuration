{ stdenv, makeWrapper }:
rec {
  custom-derivation = {
    name,
    src ? ./src,
    lib ? ./lib,
    build-dir ? "build",
    ...
  }:
  let
    foo = "bar";
  in
    stdenv.mkDerivation {
      name = "${name}";
      src = "${src}";
      buildInputs = [ makeWrapper ];
      buildPhase = ''
        mkdir ${build-dir} &&
	  if [ -d ${build-dir} ]
          then
	    cp --recursive scripts ${build-dir} &&
	      chmod --recursive 0500 ${build-dir}/scripts &&
	      true
	  fi &&
	  if [ -d ${lib-dir} ]
	  then
	    cp --recursive lib ${build-dir} &&
	      chmod --recursive 0400 ${build-dir}/lib &&
	      true
	  fi &&
	  true
      '';
      installPhase = ''
        mkdir $out &&
	  cp --recursive ${build-dir} $out &&
	  true
      '';
    };
}