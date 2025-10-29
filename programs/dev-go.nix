{pkgs, pkgs-go-migrate, ...}: {
  programs.go = {
    enable = true;
  };

  home.packages = with pkgs; [
    govulncheck
    gosec
  ] ++ [
    pkgs-go-migrate.go-migrate
  ];
}
