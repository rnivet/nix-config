# Nix Configuration Repository

## Build/Test Commands

### Nix Darwin (macOS)
- Build: `darwin-rebuild build --flake .#<hostname>`
- Switch: `darwin-rebuild switch --flake ~/.config/nix`
- Test: `darwin-rebuild test --flake .#<hostname>`

### Home Manager (Linux)
- Switch: `home-manager switch -b before-home-manager`
- Build: `home-manager build`
- Test: `home-manager check`

### General
- Update flakes: `nix flake update`
- Check configuration: `nix flake check`

## Code Style Guidelines

### Nix Files
- Use 2-space indentation
- Follow functional programming patterns
- Import modules at top of files
- Use descriptive attribute names
- Keep expressions pure and composable
- Use `lib.mkIf` for conditional configuration
- Separate concerns with modules (roles/, programs/, hosts/)

### Lua/Neovim Config
- 2-space indentation (as per nvim options.lua:29)
- Use `local opt = vim.opt` pattern
- Prefer vim.opt over vim.o for options
- Use lazy.nvim for plugin management
- Keep plugin configs in separate files under plugins/

### General
- Use meaningful commit messages
- Test configurations before switching
- Keep host-specific configs in hosts/ directory
- Use roles/ for reusable configuration modules