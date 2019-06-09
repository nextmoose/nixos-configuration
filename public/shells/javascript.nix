{
  pkgs ? import <nixpkgs> {}
} :
pkgs.mkShell {
  buildInputs = [
    pkgs.atom
    pkgs.git
    pkgs.nodejs-8_x
    pkgs.jdk
    pkgs.xvfb_run
    pkgs.gnome2.libgtkhtml
    pkgs.libnotify
    pkgs.gnome2.GConf
    pkgs.nss
    pkgs.htmlcxx
    pkgs.ecasound
  ];
}