{pkgs, ...}: {
  home.packages = [
    pkgs.python313Packages.huggingface-hub
    pkgs.python313Packages.mlx
  ];
}
