{config, ...}: {
  programs.opencode = {
    enable = true;
    # rules = "";
    settings = {
      theme = "tokyonight";
      agent = {
        plan = {
          mode = "primary";
          model = "zen/claude-sonnet-4-5";
          tools = {
            write = false;
            edit = false;
            bash = true;
          };
          permissions = {
            bash = {
              cat = "deny";
            };
          };
        };
      };
      mcp = {
        browser = {
          enabled = true;
          type = "local";
          command = [
            "npx"
            "chrome-devtools-mcp@latest"
          ];
        };
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = config.age.secrets.context7_api_key.path;
          };
          enabled = true;
        };
      };
    };
  };
}
