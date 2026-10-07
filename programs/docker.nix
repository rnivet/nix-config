{pkgs, ...}: {
  home.sessionVariables = {
    COMPOSE_BAKE = "true";
  };

  # Runs `colima start` at login via a launchd agent; also installs colima.
  services.colima.enable = true;

  home.packages = with pkgs; [
    docker_29
    docker-compose
    docker-credential-helpers
    docker-buildx
  ];
}
