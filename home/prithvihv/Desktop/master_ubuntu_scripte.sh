
############################# NEEDS CUSTOM LICENCE #######################
sudo apt-get install ttf-mscorefonts-installer




############################################################################


# Ubuntu based machines
sudo apt update
sudo apt upgrade
# package names
arandr
chromium-browser
xmonad dmenu 
pulseaudio-utils pavucontrol
sudo apt install vim git xclip scrot pass

## extra xmonad + haskell dev env
sudo apt install libpng-dev zlib1g libx11-dev apt-file libxinerama-dev libxrandr-dev libxss-dev libasound2-dev  libicu-dev libncurses-dev libgmp-dev libxpm-dev
sudo apt install rxvt-unicode
sudo apt install ghc ghc-prof ghc-doc  cabal-install c2hs
sudo apt install haskell-stack
sudo apt-get install trayer xscreensaver
stack upgrade --binary-only
set -U fish_user_paths /home/prithvihv/.cabal/bin $fish_user_paths
``` HIE : 
 stack ./install.hs help    
 stack ./install.hs hie
```

sudo apt install xmobar
cabal update
cabal install Cabal cabal-install
cabal install xmonad alsa-core xmonad-contrib xmonad-extras xmobar
## bluetooth
sudo apt-get purge bluez-tools && sudo apt-get install bluez-tools
sudo apt install blueman
 
## vscode 
view on : https://code.visualstudio.com/docs/setup/linux
actual download link : https://go.microsoft.com/fwlink/?LinkID=760868
sudo apt install ./<file>.deb
## fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get -y install fish
curl -L https://get.oh-my.fish | fish
omf install batman
omf install nvm

## alacritty , terminal emulator
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt update && sudo apt install alacritty

## to steal popOs Stuff
# dont do this shit!
sudo apt-add-repository ppa:system76/pop 
sudo apt install pop-fonts

## getting rid of libreoffice
sudo apt-get remove --purge libreoffice*
sudo apt-get clean
sudo apt-get autoremove

## fc to list fonts
fc-list

# OBS
sudo apt install ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio

sudo apt install python3-pip


# docker 
sudo apt-get install \
	     apt-transport-https \
	         ca-certificates \
		     curl \
		         gnupg-agent \
			     software-properties-common -y
# change version name from focal to whatever base ubuntu version
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 sudo add-apt-repository \
	    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	       focal  \
	          stable"

sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
 sudo usermod -aG docker $USER


# qemu
sudo apt-get install -y qemu

# minikube
cd Downloads
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
 chmod +x ./minikube 
 sudo mkdir -p /usr/local/bin/
 sudo install minikube /usr/local/bin/

# kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


# postgres
# focal <= change ubuntu version
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get install postgresql -y
## postgres config
sudo su - postgres
# inside postgres : CREATE ROLE prithvihv WITH SUPERUSER CREATEDB CREATEROLE LOGIN;
# inside postgres : DROP ROLE prithvihv;


# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-"(uname -s)"-"(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# fim view photos on the terminal
 sudo apt-get install fim

# calibre ebook management
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# peek gif maker!
sudo add-apt-repository ppa:peek-developers/stable
sudo apt update
sudo apt install peek


# elm
curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
gunzip elm.gz
chmod +x elm
sudo mv elm /usr/local/bin/


# c++ build tools
sudo apt install -y ccache


#st term
sudo apt install -y stterm
