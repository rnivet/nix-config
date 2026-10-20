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
      init = {
        defaultBranch = hostConf.git_default_branch;
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
        autoFetch = true;
        autoForwardBranches = "allBranches";
        mainBranches = [
          "main"
          "develop"
        ];
      };
      refresher = {
        fetchInterval = 60;
      };
    };
  };

  home.packages = [
    pkgs.git-filter-repo
  ];
}
