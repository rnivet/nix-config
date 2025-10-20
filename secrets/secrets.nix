let
  perso = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEz8lyJscc6qjM4GU4a556NR3aKU35iKl9WOG+MhFGiQ";
  pro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4sICjhHLHLL0F8XRQbRnUODFGBoeYikM0abA6to9N2";
in {
  "codestral_token.age".publicKeys = [perso];
  "github_pat.age".publicKeys = [perso];
  "context7_api_key.age".publicKeys = [perso];

  "codestral_token_pro.age".publicKeys = [pro];
  "github_pat_pro.age".publicKeys = [pro];
  "context7_api_key_pro.age".publicKeys = [pro];
}
