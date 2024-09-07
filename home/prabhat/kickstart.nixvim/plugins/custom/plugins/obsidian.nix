{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/obsidian/index.html
    plugins.obsidian = {
      enable = true;
      settings = {
        dir = "~/Documents";
      };
    };
  };
}
