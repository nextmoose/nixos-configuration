{}:
let
  custom-derivation = (import ../custom-derivation.nix);
in
custom-derivation {
  name = "hello";
  src = ./src;
  wrappers = out: ''
    makeWrapper ${out}/scripts/hello.sh ${out}/bin/hello
  '';
}
