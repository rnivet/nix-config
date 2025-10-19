{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.opencode
  ];

  home.file = {
    ".config/opencode/config.json.tpl".source = ./config.json;
  };

  home.activation.setOpencodeSecrets = config.lib.dag.entryAfter ["writeBoundary"] ''
    export PATH=$PATH:/usr/bin

    oc_config_path=${config.home.homeDirectory}/.config/opencode
    oc_config_tpl=$oc_config_path/config.json.tpl
    oc_config=$oc_config_path/config.json

    if [ -f /run/agenix/context7_api_key ] && [ -f /run/agenix/github_pat ]; then
      context7_api_key=$(cat /run/agenix/context7_api_key)
      github_pat=$(cat /run/agenix/github_pat)
      run sed -e "s/__CONTEXT7_API_KEY__/$context7_api_key/g" -e "s/__GITHUB_PAT__/$github_pat/g" $oc_config_tpl > $oc_config
    fi
  '';
}
