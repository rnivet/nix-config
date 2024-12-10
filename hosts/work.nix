{
  username = "rnivet";
  homedir = "/home/rnivet";
  email = "remi.nivet@hornetsecurity.com";
  name = "Remi Nivet";
  roles =
    import ../roles/common-dev.nix
    ++ [../programs/dotnet.nix]
    ++ [../programs/kube.nix];
}
