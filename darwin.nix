{
  pkgs,
  config,
  hostConf,
  agenix,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    agenix.packages.${pkgs.system}.default
    alacritty
    obsidian
    slack
  ];

  # fonts.packages = [
  #   (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
  # ];

  # system.activationScripts.applications.text = let
  #   env = pkgs.buildEnv {
  #     name = "system-applications";
  #     paths = config.environment.systemPackages;
  #     pathsToLink = "/Applications";
  #   };
  # in
  #   pkgs.lib.mkForce ''
  #   # Set up applications.
  #   echo "setting up /Applications..." >&2
  #   rm -rf /Applications/Nix\ Apps
  #   mkdir -p /Applications/Nix\ Apps
  #   find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #   while read src; do
  #     app_name=$(basename "$src")
  #     echo "copying $src" >&2
  #     ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  #   done
  # '';

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.remi = {
    name = "remi";
    home = "/Users/remi";
  };

  # Declare primary user
  system.primaryUser = "remi";
  nix.settings.trusted-users = ["root" "remi"];

  # MacOS System settings
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # Brew packages
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    taps =
      []
      ++ (hostConf.homebrew_extras.taps or []);
    brews =
      ["ansible-language-server"]
      ++ (hostConf.homebrew_extras.brews or []);
    casks =
      ["onlyoffice"]
      ++ (hostConf.homebrew_extras.casks or []);
  };

  age = {
    identityPaths = ["${hostConf.homedir}/.ssh/id_agenix"];
    secrets = hostConf.age_secrets or {};
  };
}
