{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
	vim
	powertop
	tree
	btop
	wget
	curl
	usbutils
	unzip
 ];

}

