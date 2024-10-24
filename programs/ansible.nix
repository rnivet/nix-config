{
  pkgs,
  hostConf,
  ...
}: {
  home.packages = with pkgs; [
    ansible
    ansible-lint
  ];
}
