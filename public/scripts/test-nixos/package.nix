{
  pkgs
} :
(include ${SOURCE_DIR}/public/staples.nix {
  pkgs = pkgs;
}).${PACKAGE}