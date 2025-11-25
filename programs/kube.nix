{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
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
