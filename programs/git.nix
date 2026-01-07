{
  hostConf,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = hostConf.name;
        email = hostConf.email;
      };
      pull = {
        rebase = true;
      };
    };
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

  home.packages = [
    pkgs.git-filter-repo
  ];
}
