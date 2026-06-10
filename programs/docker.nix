{pkgs, ...}: {
  home.sessionVariables = {
    COMPOSE_BAKE = "true";
  };

  home.packages = with pkgs; [
    colima
    docker_29
    docker-compose
    docker-credential-helpers
    docker-buildx
  ];
}
