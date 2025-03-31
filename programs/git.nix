{hostConf, ...}: {
  programs.git = {
    enable = true;
    userName = hostConf.name;
    userEmail = hostConf.email;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        edit = "vi {{filename}}";
      };
    };
  };
}
