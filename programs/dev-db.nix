{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin
    mongosh
    mongodb-tools
  ];
}
