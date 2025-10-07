{
  hostConf,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    act
  ];

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
        mainBranches = [
          "main"
          "master"
          "develop"
        ];
      };
    };
  };
}
