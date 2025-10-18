{
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  codestral_token_file = ../secrets/codestral_token.age;
  context7_api_key_file = ../secrets/context7_api_key.age;
  homebrew_extras = {
    taps = ["dashlane/tap"];
    brews = ["dashlane-cli"];
    casks = ["transmission"];
  };
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/dev-ansible.nix
    ++ import ../roles/common-desktop.nix
    ++ [../programs/dev-python.nix];
}
