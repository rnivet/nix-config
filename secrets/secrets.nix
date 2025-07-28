let
  perso = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEz8lyJscc6qjM4GU4a556NR3aKU35iKl9WOG+MhFGiQ";
in {
  "codestral_token.age".publicKeys = [perso];
}
