{
  pkgs ? import <nixpkgs>{},
  pass
}:
let
  gnupg = (import ../initialization/gnupg/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  dot-ssh = (import ../initialization/dot-ssh/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
  gpg-key-id = (import ../../native/gpg-key-id/default.nix {
    pkgs = pkgs;
  });
  post-commit = (import ../../native/post-commit/default.nix {
    pkgs = pkgs;
  });
in
{
  config = { config, pkgs, ...}:
  {
    programs.bash = {
      enableCompletion = true;
      shellInit = ''
        ${gnupg}/bin/gnupg &&
          ${dot-ssh}/bin/dot-ssh --origin-host github.com --origin-user git --origin-port 22 &&
          pass init $(gpg-key-id) &&
          pass git init &&
          pass git remote add origin origin:desertedscorpion/passwordstore.git &&
          pass git fetch origin master &&
          pass git checkout master &&
          ${pkgs.coreutils}/bin/ln -sf ${post-commit}/bin/post-commit /home/user/.password-store/.git/hooks &&
          true
      '';
    };
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
	      pkgs.pass
      ];
    };
  };
  tmpfs = [ "/home" ];
}
