{hostConf, ...}: {
  programs.git = {
    enable = true;
    userName = hostConf.name;
    userEmail = hostConf.email;
  };

  programs.lazygit.enable = true;
}
