{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.gnucash}/bin/gnucash
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  contents = [ pkgs.bash pkgs.gnucash pkgs.coreutils pkgs.gtk2-x11 pkgs.dbus pkgs.dbus_libs pkgs.dbus_tools pkgs.dbus_daemon pkgs.dbus-broker gnome2.GConf pkgconfig gtk2-x11 xorg.libX11 perl gdbm glib
    aqbanking
    atk
    boost
    cairo
    gnome3.dconf
    gnome3.dconf-editor
    fribidi
    gdk_pixbuf
    glib
    guile
    gwenhywfar
    libdbi
    libofx
    gnome2.libsoup
    gnome3.libsoup
    libxml2
    libxslt
    gnome2.pango
#    haskellPackages.webkit2gtk3-javascriptcore
    zlib
  ];
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
      mkdir /home /tmp &&
      ${pkgs.shadow}/bin/useradd --create-home user &&
      chmod a+rwx /tmp &&
      true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
