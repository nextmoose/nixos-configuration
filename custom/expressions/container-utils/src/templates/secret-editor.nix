{ config, lib, pkgs, ... }:
with lib;
{
    users.mutableUsers = false;
    users.extraUsers.user = {
      isNormalUser = true;
      password = "password";
  };
}
