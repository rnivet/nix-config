let
  perso = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEz8lyJscc6qjM4GU4a556NR3aKU35iKl9WOG+MhFGiQ";
  pro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSBzHipLPuQPPXmWALVR5m+takfCfzX0G1HvR3enLbJ";
in {
  "codestral_token.age".publicKeys = [perso];
  "codestral_token_pro.age".publicKeys = [pro];
}
