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
     python3
    python311Packages.pip
    python311Packages.django
 thonny
  #jetbrains.clion
 ];

}

