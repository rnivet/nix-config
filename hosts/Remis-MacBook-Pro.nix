{
  profile = "work";
  username = "remi";
  homedir = "/Users/remi";
  email = "rnivet@oversoc.com";
  name = "Remi Nivet";
  codestral_token_file = ../secrets/codestral_token_pro.age;
  context7_api_key_file = ../secrets/context7_api_key_pro.age;
  github_pat_file = ../secrets/github_pat_pro.age;
  homebrew_extras = {
    taps = [];
    brews = [];
    casks = [];
  };
  age_secrets = {
    codestral_token = {
      file = ../secrets/codestral_token_pro.age;
      owner = "remi";
      mode = "0400";
    };
    context7_api_key = {
      file = ../secrets/context7_api_key_pro.age;
      owner = "remi";
      mode = "0400";
    };
    github_pat = {
      file = ../secrets/github_pat_pro.age;
      owner = "remi";
      mode = "0400";
    };
  };
  roles =
    import ../roles/common-dev.nix
    ++ import ../roles/common-desktop.nix
    ++ import ../roles/macos-dev.nix
    ++ [../programs/kube.nix]
    ++ [../programs/dev-python.nix]
    ++ [../programs/dev-js.nix]
    ++ [../programs/dev-go.nix]
    ++ [../programs/claude.nix];
}
