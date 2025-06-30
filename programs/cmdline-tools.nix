{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    btop
    curl
    devenv
    dos2unix
    fzf
    jq
    lazydocker
    ripgrep
    unzip
    wget
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
