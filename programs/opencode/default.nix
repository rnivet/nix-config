{
  pkgs,
  config,
  hostConf,
  ...
}: {
  home.packages = [
    pkgs.opencode
  ];

  home.file = {
    ".config/opencode/config.json".source = 
      if hostConf.profile == "work"
      then ./config-work.json
      else ./config-personal.json;
  };
}
