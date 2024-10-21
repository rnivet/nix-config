{ pkgs, ... }:
{
  home.packages = [
    pkgs.oh-my-posh
    (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
  ];

  home.file = {
    ".config/oh-my-posh/config.toml".source = ./oh-my-posh.yml;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    initExtra = "eval \"$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oh-my-posh.yml)\"";
    oh-my-zsh = {
      enable = true;
      extraConfig = "zstyle ':omz:update' mode auto";
      plugins = [
        "git"
        "docker"
        "docker-compose"
      ];
    };
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      filter_mode_shell_up_key_binding = "session";
      enter_accept = true;
    };
  };
}
