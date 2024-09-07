{
  programs.nixvim = {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/transparent/index.html
    plugins.transparent = {
      enable = true;
      settings = {
      };
    };
  };
}
