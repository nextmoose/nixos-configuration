{}:
let
  custom-derivation = (import ../custom-derivation.nix);
in
custom-derivation {
  name = "hello";
  src = ./src;
}
