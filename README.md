# Install my config on a new host
## Install nix
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```
quit shell and come back

```
nix-shell -p nix-info --run "nix-info -m"
```
## Configure nix to use flakes

Edit /etc/nix/nix.conf and add the following line:
```
experimental-features = nix-command flakes
```
## MacOS hosts
### Install nix-darwin
```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .
### Install config on Darwin after a modification
```
darwin-rebuild switch --flake ~/.config/nix
```
```
## Linux hosts
### Install home-manager
```
nix run home-manager/release-24.05 -- switch 
```
### Install config after a modification
```
home-manager switch -b before-home-manager
```
## Update software in flake
```
nix flake update
```
## Install config on Darwin after a modification
```
darwin-rebuild switch --flake ~/.config/nix
```
