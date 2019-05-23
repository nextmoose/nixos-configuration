{
  pkgs,
  staples ? (import /etc/nixos/custom/staples.nix {
    pkgs = pkgs;
  })
} :
pkgs.mkShell {
  buildInputs = [ pkgs.bash pkgs.pass pkgs.git staples.post-commit pkgs.which ];
  shellHook = ''
    echo "Hello World!"
  '';
}