{pkgs, ...}: {
  home.packages = with pkgs; [
    python314
    python314Packages.pytest
  ];

  programs.poetry = {
    enable = true;
    settings = {
      virtualenvs.create = true;
      virtualenvs.in-project = true;
    };
  };

  programs.uv = {
    enable = true;
  };
}
