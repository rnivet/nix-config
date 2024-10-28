{
  pkgs,
  hostConf,
  ...
}: {
  home.packages = with pkgs; [
    curl
    wget
    dos2unix
    jq
    btop
    ripgrep
    fzf
    unzip
  ];
}
