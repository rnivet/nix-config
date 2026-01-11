{
  profile = "personal";
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@gmail.com";
  name = "Remi Nivet";
  codestral_token_file = ../secrets/codestral_token.age;
  context7_api_key_file = ../secrets/context7_api_key.age;
  github_pat_file = ../secrets/github_pat.age;
  homebrew_extras = {
    taps = [];
    brews = [
      "opencode"
    ];
    casks = [
      "readdle-spark"
      "signal"
      "whatsapp"
      "roon"
      "nextcloud"
      "vlc"
      "connectmenow"
      "google-drive"
      "protonvpn"
    ];
  };
  age_secrets = {
    codestral_token = {
      file = ../secrets/codestral_token.age;
      owner = "remi";
      mode = "0400";
    };
    context7_api_key = {
      file = ../secrets/context7_api_key.age;
      owner = "remi";
      mode = "0400";
    };
    github_pat = {
      file = ../secrets/github_pat.age;
      owner = "remi";
      mode = "0400";
    };
  };
  dns_addresses = {
    "monel.spip.local" = "127.0.0.1";
  };
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/dev-ansible.nix
    ++ import ../roles/common-desktop.nix
    ++ [../programs/dev-python.nix]
    ++ [../programs/claude.nix]
    ++ [../programs/docker.nix]
    ++ [../programs/telegram.nix];
}
