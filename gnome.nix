{ config, pkgs, lib, ... }:

{
 # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  #security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };

# Install GNOME-related packages
  environment.systemPackages = with pkgs; [
    pkgs.gnome.gnome-tweaks
    gnome.nautilus
    gnome.nautilus-python
    nautilus-open-any-terminal
#    nautilus-open-in-blackbox
    gnome.sushi
    gnome.gnome-calendar
    gnome.seahorse
    gnome.cheese
    gnome.gnome-system-monitor
    gnome.eog
#    blackbox-terminal
#    turtle
    epiphany
    
    #Extensions 
    gnomeExtensions.dash-to-dock
    gnomeExtensions.tray-icons-reloaded
    
    # Theme
    tela-circle-icon-theme
    gruvbox-gtk-theme # gtk theme for gnome
  ];

}

