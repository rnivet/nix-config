{
  username = "rnivet";
  homedir = "/home/rnivet";
  email = "remi.nivet@hornetsecurity.com";
  name = "Remi Nivet";
  codestral_token_file = ../secrets/codestral_token_pro.age;
  roles =
    import ../roles/common-dev.nix
    ++ [../programs/dotnet.nix]
    ++ [../programs/kube.nix]
    ++ [../programs/clang.nix]
    ++ [../programs/dev-python.nix];
}
