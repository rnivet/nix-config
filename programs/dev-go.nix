{
  pkgs,
  pkgs-go-migrate,
  ...
}: {
  programs.go = {
    enable = true;
    env.GOPRIVATE = [
      "github.com/oversoc/*"
    ];
  };

  home.packages = [
    pkgs.govulncheck
    pkgs.gosec
    pkgs-go-migrate.go-migrate
  ];
}
