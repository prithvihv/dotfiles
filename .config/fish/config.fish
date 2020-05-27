
# Functions leveraging the cb() function
function cbf -d "Copy contents of a file to a clipboard"
  cat "$argv" | cb
end

function cbssh -d "Copy (default) SSH public key to a clipboard"
  cb ~/.ssh/id_rsa.pub
end

function cbwd -d "Copy current working directory to a clipboard"
  pwd | cb
end

function cbhs -d "Copy most recent command in history to a clipboard"
  history | head -n 1 | cb
end


function connect_bake-sake
    ssh root@144.202.61.108
end

function jump_signzy_sfpt 
  ssh root@52.229.167.155
end

function jump_signzy_stag
  ssh prithvi@164.52.197.173
end


function jump_sbi_images_machine
  ssh root@164.52.192.123
end


function jump_vcip_stagging
  ssh rsz@164.52.198.108
end

function dr11_gcp
  ssh prithvihv@35.186.150.59 
end

function k
  kubectl $argv
end

function jump_akashMachine
  ssh prithvihv@192.168.1.2
end

alias configGit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# set the workspace path
set -x GOPATH /home/prithvi/go

# add the go bin path to be able to execute our programs
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

set -x EDITOR nvim
set -x NODE_ENV staging