{...}: {
  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "tokyo-night";
      mode = "auto";
      line_numbers = true;
    };
  };
}
