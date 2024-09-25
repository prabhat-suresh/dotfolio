{
  programs.nixvim = {
    plugins.glow = {
      enable = true;
      settings = {
        border = "shadow";
        height = 100;
        height_ratio = 0.7;
        pager = false;
        style = "dark";
        width = 80;
        width_ratio = 0.7;
      };
    };
  };
}
