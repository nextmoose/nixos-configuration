{ stdenv, makeWrapper }:
rec {
  custom-derivation = {
    build-dir ? "build",
    ...
  }:
  let
    foo = "bar";
  in
    stdenv.mkDerivation {
      name = "${foo}";
      src = ./src;
      buildInputs = [ makeWrapper ];
      buildPhase = ''
        mkdir ${build-dir} &&
          cp --recursive scripts ${build-dir} &&
	  chmod --recursive 0500 ${build-dir}/scripts &&
	  true
      '';
      installPhase = ''
        mkdir $out &&
	  cp --recursive ${build-dir} $out &&
	  true
      '';
    };
}