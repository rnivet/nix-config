{
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  roles =
    import ../roles/dev.nix
    ++ import ../roles/common-desktop.nix;
}
