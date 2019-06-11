{
  pkgs,
  staples-file,
  package-name
} :
(import staples-file {
  pkgs = pkgs;
}).package-name