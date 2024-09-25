{
  programs.nixvim = {
    plugins.better-escape = {
      enable = true;
      settings.default_mappings = true;
    };
  };
}
