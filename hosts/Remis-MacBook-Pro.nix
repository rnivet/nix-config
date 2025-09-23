{
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@oversoc.com";
  name = "Remi Nivet";
  codestral_token_file = ../secrets/codestral_token.age;
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/common-desktop.nix
    ++ import ../roles/macos-dev.nix
    ++ [../programs/kube.nix]
    ++ [../programs/dev-python.nix]
    ++ [../programs/dev-js.nix];
}
