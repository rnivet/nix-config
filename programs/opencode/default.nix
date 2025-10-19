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

    context7_api_key=$(cat ${config.age.secrets.context7_api_key.path})
    run sed "s/__CONTEXT7_API_KEY__/$context7_api_key/g" $oc_config_tpl > $oc_config
  '';
}
