{
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/dev-ansible.nix
    ++ import ../roles/common-desktop.nix
    ++ [../programs/dotnet.nix];
}
