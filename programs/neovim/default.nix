{pkgs, ...}: let
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
  inherit
    (
      (builtins.getFlake "github:konradmalik/nixpkgs/1cd039866ff4728d85430ba66af60ba790a4789b")
      .legacyPackages
      .${pkgs.system}
    )
    roslyn-ls
    ;
in {
  home.packages = with pkgs; [
    # Tools for neovim
    tree-sitter

    # Tools for Telescope
    ripgrep
    fd

    # Lua dev
    lua51Packages.lua
    luajitPackages.luarocks
    lua-language-server

    # Python dev
    python313
    python313Packages.pip
    python313Packages.python-lsp-server
    pyright
    black

    # YAML dev
    yaml-language-server
    spectral-language-server

    # WEB dev
    vscode-langservers-extracted
    rubyPackages.htmlbeautifier
    rubyPackages.prettier
    phpactor
    typescript-language-server
    angular-language-server

    # GOlang dev
    gopls
    gofumpt
    goimports-reviser

    # SHELL dev
    bash-language-server
    shfmt

    # DOTNET dev
    omnisharp-roslyn
    roslyn-ls

    # Ansible
    ansible-lint

    # Docker
    dockerfile-language-server
    docker-compose-language-service

    # NIX dev
    nixd
    alejandra

    # HELM charts dev
    helm-ls
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    plugins = [
      treesitterWithGrammars
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  home.file."./.config/nvim/init.lua".text = ''
    require("config.options")
    require("config.filetype")
    require("config.lazy")
    require("config.autocmds")
    vim.opt.runtimepath:append("${treesitter-parsers}")
  '';

  # Treesitter is configured as a locally developed module in lazy.nvim
  # we hardcode a symlink here so that we can refer to it in our lazy config
  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    source = treesitterWithGrammars;
    recursive = true;
  };
}
