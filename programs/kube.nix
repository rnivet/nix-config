{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    argocd
  ];

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  programs.zsh.initContent = ''
    eval "$(kubectl completion zsh)"
    compdef kubecolor=kubectl
  '';
}
