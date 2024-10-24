{
  username = "remi";
  homedir = "/home/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/linux-desktop.nix;
}
