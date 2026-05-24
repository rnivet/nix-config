{pkgs, ...}: {
  home.file.".config/cmux/cmux.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json";
    schemaVersion = 1;
    app = {
      newWorkspacePlacement = "end";
      workspaceInheritWorkingDirectory = false;
    };
    notifications = {
      hooks = [
        {
          id = "suppress-when-focused";
          command = "${pkgs.jq}/bin/jq 'if .context.focusedPanel then .effects.desktop = false | .effects.sound = false else . end'";
          timeoutSeconds = 5;
        }
      ];
    };
    shortcuts = {
      bindings = {
        nextSurface = "cmd+right";
        prevSurface = "cmd+left";
      };
    };
  };
}
