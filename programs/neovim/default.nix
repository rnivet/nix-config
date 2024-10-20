{ pkgs, ... }:
let
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
    p.regex
  ]));

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  home.packages = with pkgs; [
    ripgrep

    # Lua dev
    lua51Packages.lua
    luajitPackages.luarocks
    lua-language-server

    # Python dev
    python3
    pyright
    python312Packages.python-lsp-server
    black

    # YAML dev
    yaml-language-server
    spectral-language-server

    # WEB dev
    vscode-langservers-extracted
    rubyPackages.htmlbeautifier
    phpactor
    typescript-language-server

    # GOlang dev
    gopls
    gofumpt
    goimports-reviser

    # SHELL dev
    bash-language-server
    shfmt

    # DOTNET dev
    omnisharp-roslyn

    # Ansible
    ansible-language-server

    # Docker
    dockerfile-language-server-nodejs
    docker-compose-language-service
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
    recursive = true;
    source = treesitterWithGrammars;
  };
}
