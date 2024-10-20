{ pkgs, env, ... }:
{
  programs.git = {
    enable = true;
    userName = env.name;
    userEmail = env.email;
  };

  programs.lazygit.enable = true;
}
