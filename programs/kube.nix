{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    argocd
  ];

  programs.zsh.initExtra = ''
    eval "$(kubectl completion zsh)"
  '';
}
