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

    shellAliases = {
      lr = "ls -lR";
      lra = "ls -lRa";
      ll = "ls -l";
      lla = "ls -la";
      ".." = "cd ..";
      nv = "nvim";
      icat = "kitty +kitten icat";
      update = "cd ~/.nix; sudo nixos-rebuild --flake . --impure switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      theme = "alanpeabody";
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
    kitty
    tmux
    # Add other packages you want to install for your user here
  ];
#  programs.kitty = {
#    keybindings = {
#      "ctrl+shift+tab" = "nth_window -1";
      #Switch focus to the neighboring window in the indicated direction
      #"ctrl+left" = " neighboring_window left";
      #"ctrl+right" = "neighboring_window right";
      #"ctrl+up" = "neighboring_window up";
      #"ctrl+down" = "neighboring_window down";
      #move window in the indicated direction
      #"shift+up" = "move_window up";
      #"shift+left" = "move_window left";
      #"shift+right" = "move_window right";
      #"shift+down" = "move_window down";
#    };
#    shellIntegration.enableBashIntegration = true;
#    shellIntegration.enableZshIntegration = true;
#    font.package = "fira-code";


 # };

  programs.kitty.settings = {
      scrollback_lines = 25000;
      enable_audio_bell = false;
      update_check_interval = 0;
  };
  # Example configuration for managing dotfiles
#  home.file.".zshrc".source = ./dotfiles/zshrc;

  # Add more user-specific configurations here
}

