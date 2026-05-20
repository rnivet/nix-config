{...}: {
  home.file.".config/cmux/cmux.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json";
    schemaVersion = 1;
    app = {
      newWorkspacePlacement = "end";
    };
    shortcuts = {
      bindings = {
        nextSurface = "cmd+right";
        prevSurface = "cmd+left";
      };
    };
  };
}
