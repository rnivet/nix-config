{pkgs, ...}: {
  home.sessionVariables = {
    COMPOSE_BAKE = "true";
  };

  home.packages = with pkgs; [
    colima
    docker
    docker-compose
    docker-credential-helpers
    docker-buildx
  ];
}
