{ config, pkgs, ... }:

with pkgs;

let 
  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "bad807ade1314420a52c589dbc3d64d3c9b38480";
    sha256 = "099dpxrpch8cgy310svrpdcad2y1qdl6l782mjpcgn3rqgj62vsf";
  });
in
rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.htop.enable = true;
  programs.fzf = {
	enable =true;
	enableZshIntegration=true;
  };
  home.packages = [
	cantarell-fonts
	google-fonts
  ] ++ [ # Themes
	arc-theme	
	google-chrome	
  ] ++ [
	terminator
    termite
	tmux
	zsh
	zip
    i3-gaps
	jq
  ] ++ [ # media
	spotify
	vlc 
	ffmpeg-full
	pavucontrol
	playerctl
  ] ++ [
	python36
	cmake
	gcc
	nodePackages.node2nix
    nodePackages_10_x.bower
    nodePackages_10_x.bower2nix
    nodePackages_10_x.pulp
	gnumake
	cabal2nix
    docker
    docker-compose
    aqemu
  ] ++ [ # most of these must be system level installs
    pass
    wine
    gnupg
    stern
    flameshot
    go
    unzip
    neovim
    kvm
    go2nix
    oh-my-zsh
	feh
    netcat
	arandr
    ruby
    x11
    bundix
    bundler
	bluez-tools
	pacvim
    glxinfo
    yarn
  ] ++ [
    npm2nix
    go2nix
    yarn2nix
  ] ++ (with easyPS.inputs; [
    psc-package
    purescript
    spago
  ]) ++ [
    zlib
    kubectl
  ] ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
      libXext
      xinput
      
    ]);
}
