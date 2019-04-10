{
  config,
  pkgs,
  ...
}:
{
  users.extraUsers.user.hashedPassword = "${HASHED_USER_PASSWORD}";
}
