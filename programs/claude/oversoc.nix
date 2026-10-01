{...}: {
  programs.claude-code.settings = {
    extraKnownMarketplaces.oversoc.source = {
      source = "github";
      repo = "oversoc/claude-skills";
    };
    enabledPlugins = {
      "oversoc-marketing@oversoc" = true;
      "oversoc-clients@oversoc" = true;
      "oversoc-donnees@oversoc" = true;
      "oversoc-produit@oversoc" = true;
      "oversoc-dev@oversoc" = true;
    };
  };
}
