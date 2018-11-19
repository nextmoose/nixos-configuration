makeWrapper $out/scripts/hello.sh $out/bin/hello --set PATH ${pkgs.lib.makeBinPath [ pkgs.bash pkgs.coreutils ]}
