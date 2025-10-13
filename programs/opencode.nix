{...}: {
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
        browser-control = {
          type = "local";
          command = [
            "node"
            "/Users/remi/projects/browser-control-mcp/mcp-server/dist/server.js"
          ];
          environment = {
            EXTENSION_SECRET = "d0e97396-ca92-4da4-a420-ab9894a3cbe4";
            EXTENSION_PORT = "8089";
          };
        };
      };
    };
  };
}
