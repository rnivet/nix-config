{
  pkgs,
  pkgs-go-migrate,
  ...
}: {
  programs.go = {
    enable = true;
  };

  home.packages = [
    pkgs.govulncheck
    pkgs.gosec
    pkgs-go-migrate.go-migrate
  ];
}
