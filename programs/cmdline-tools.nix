{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    btop
    curl
    devenv
    dos2unix
    fzf
    gnused
    imagemagick
    jq
    lazydocker
    ngrok
    ripgrep
    unzip
    wget
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
    extraOptions = [];
    git = true;
    icons = "auto";
    theme = "tokyonight";
  };
}
