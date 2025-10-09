{
  hostConf,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = hostConf.name;
    userEmail = hostConf.email;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        editPreset = "nvim";
      };
      git = {
        autoFetch = false;
        mainBranches = [
          "main"
          "master"
          "develop"
        ];
      };
    };
  };
}
