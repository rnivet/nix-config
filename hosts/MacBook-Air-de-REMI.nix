{
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  codestral_token_filename = ../secrets/codestral_token.age;
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/dev-ansible.nix
    ++ import ../roles/common-desktop.nix
    ++ [../programs/dotnet.nix];
}
