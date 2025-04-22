{pkgs, ...}: {
  home.packages = [
    pkgs.python3
  ];
  programs.poetry = {
    enable = true;
    settings = {
      virtualenvs.create = true;
      virtualenvs.in-project = true;
    };
  };
}
