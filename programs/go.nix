{...}: {
  programs.go = {
    enable = true;
    goPrivate = ["gitlabdev.vadesecure.com"];
  };
}
