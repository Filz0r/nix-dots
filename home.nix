{ config, pkgs, lib, ... }:

{
  home.username = "filipe";
  home.homeDirectory = "/home/filipe";

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";

  # Set the shell for the user
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
        "copyfile"
        "web-search"
        "copydir"
        "dirhistory"
      ];
   };
  };

  # Ensure Zsh is set as the default login shell
  home.activation.setZshAsDefaultShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ "$(basename "$SHELL")" != "zsh" ]; then
      /run/wrappers/bin/chsh -s ${pkgs.zsh}/bin/zsh
    fi
  '';


  # Enable some common programs
  programs.bash.enable = true;

  # Set up some environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    MY_VAR = "curl parrot.live";
  };

  # Define user-specific packages
  home.packages = with pkgs; [
    tmux
    # Add other packages you want to install for your user here
  ];

  # Example configuration for managing dotfiles
#  home.file.".zshrc".source = ./dotfiles/zshrc;

  # Add more user-specific configurations here
}

