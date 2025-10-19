{
  config,
  hostConf,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = hostConf.username;
  home.homeDirectory = hostConf.homedir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables =
    {}
    // (lib.optionalAttrs (builtins.hasAttr "codestral_token_file" hostConf) {
      CODESTRAL_API_KEY = "`cat /run/agenix/codestral_token`";
    })
    // (lib.optionalAttrs (builtins.hasAttr "github_pat_file" hostConf) {
      GITHUB_PAT = "`cat /run/agenix/github_pat`";
    });

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = hostConf.roles;
}
