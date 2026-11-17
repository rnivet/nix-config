{pkgs, ...}: {
  # AWS CLI v2, used as an S3-compatible storage client. Endpoints and keys
  # live in ~/.aws/{config,credentials} (per-profile `endpoint_url`), kept
  # out of the store on purpose.
  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
  };

  programs.zsh.initContent = ''
    autoload -U +X bashcompinit && bashcompinit
    complete -C '${pkgs.awscli2}/bin/aws_completer' aws
  '';
}
