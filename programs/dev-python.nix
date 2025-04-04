{pkgs, ...}: {
  home.packages = [
    pkgs.python3
    pkgs.poetry
  ];
}
