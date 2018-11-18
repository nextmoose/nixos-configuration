{ stdenv, makeWrapper }:
rec {
  custom-derivation = {
    name,
    src ? ./src,
    build-dir ? "build",
    scripts-dir ? "scripts",
    lib-dir ? "lib"
  } @ attrs :
  let
    foo = "bar";
  in
    stdenv.mkDerivation {
      name = "${name}";
      src = "${src}";
      buildInputs = [ makeWrapper ];
      buildPhase = ''
        if [ -f scripts/build-phase.sh ]
	then
	  echo WE HAVE scripts/build-phase.sh &&
	    exit 65
	fi &&
        if [ ! -f scripts/hello.sh ]
	then
	  echo WE DO NOT HAVE scripts/hello.sh &&
	    exit 65
	fi &&
        mkdir ${build-dir} &&
	  if [ -d ${scripts-dir} ]
          then
	    cp --recursive ${scripts-dir} ${build-dir} &&
	      chmod --recursive 0500 ${build-dir}/${scripts-dir}/. &&
	      true
	  fi &&
	  if [ -d ${lib-dir} ]
	  then
	    cp --recursive ${lib-dir} ${build-dir} &&
	      chmod --recursive 0400 ${build-dir}/${lib-dir}/. &&
	      true
	  fi &&
	  true
      '';
      installPhase = ''
        mkdir $out &&
	  if [ -d ${build-dir}/${scripts-dir} ]
	  then
	    cp --recursive ${build-dir}/${scripts-dir} $out &&
	    true
	  fi &&
	  if [ -d ${build-dir}/${lib-dir} ]
	  then
	    cp --recursive ${build-dir}/${lib-dir} $out &&
	    true
	  fi &&
	  true
      '';
    };
}