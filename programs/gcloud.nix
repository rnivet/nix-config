{pkgs, ...}: {
  # gcloud with gke-gcloud-auth-plugin, required by kubectl >= 1.26 to
  # authenticate against GKE clusters. Components must be declared here:
  # `gcloud components install` cannot write to the read-only store path.
  home.packages = [
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];
}
