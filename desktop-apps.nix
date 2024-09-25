{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    slack
    spotify
    discord
    jellyfin-media-player
    stremio
    mpv
    pika-backup
    thunderbird
    google-chrome
#    kitty
#    kitty-img
#    kitty-themes
 ];

}

