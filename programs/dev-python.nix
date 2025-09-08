{pkgs, ...}: {
  home.packages = with pkgs; [
    python313
    python313Packages.pytest
  ];
  programs.poetry = {
    enable = true;
    settings = {
      virtualenvs.create = true;
      virtualenvs.in-project = true;
    };
  };
}
