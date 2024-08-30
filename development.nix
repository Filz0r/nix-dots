{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
  git
  gnumake
  clang
  bear
  typescript
  nodePackages.nodejs
  valgrind
  gcc
  glibc
  man-pages
  thonny
  #jetbrains.clion
 ];

}

