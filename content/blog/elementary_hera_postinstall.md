+++
title = "Elementary OS - Hera 5.1 post install"
date = 2020-03-08T08:00:00+05:30
description = "My installs after a fresh install of this beautiful OS."
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "linux", "elementary", "snippet"]
+++
Quick snippets and utils that I use to get going once OS install is complete.

<!-- more -->

![desktop screenshot](01.png)

- Check the official [Hera 5.1.2 release
  post](https://blog.elementary.io/5.1.2-hera-download/)
- Add `Super+Return` custom shortcut to `io.elementary.terminal -n` to open new
  terminals all the time. Otherwise, after upgrade, the focus just goes to
  existing terminal.
- I like the traffic lights windows controls; get [eOS-X
  theme](https://github.com/ipproductions/eOS-X)


## Nice curated tools
- [Crude quarter tiler](https://gist.github.com/peteruithoven/db0cba0b0849c8cb5e267f6e75126304) - very useful to tile your terminals!
- Fondo - to get nice wallpapers.
- Rush! - nice pomodoro timer

## Post install script

```sh
#!/bin/bash
sudo apt install software-properties-common
# if nothing else, I use tweaks to turn on dark mode
sudo apt-add-repository -y ppa:philip.scott/elementary-tweaks
sudo apt-add-repository -y ppa:system76-dev/stable
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt upgrade
sudo apt install elementary-tweaks gdebi
sudo apt install build-essential curl file git vim-gtk3 fonts-firacode htop tree dos2unix
sudo apt install ruby ruby-dev zlib1g-dev
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
sudo apt install gitg postgresql-client neofetch fortune-mod gdebi
sudo gem install vimwiki_markdown
sudo apt install libreoffice libreoffice-gtk libreoffice-style-elementary gimp fondo
sudo apt install tlp tlp-rdw system76-power  #laptop power management
sudo apt install transmission  #torrent client
sudo apt install dconf-editor  #only if you know what you are doing with it
sudo apt install emacs26

EOF
# This  below is to remember last option in GRUB and to boot fast
# very useful in a dual boot machine
echo "Remember boot order: Edit /etc/defaults/grub by adding the following lines"
cat <<EOF
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=3
EOF
echo "After that, run the following"
cat <<EOF
sudo update-grub
sudo apt autoclean 
sudo apt autoremove
EOF
```

## Non curated apps

I always install [linuxbrew.sh](https://linuxbrew.sh) and setup essential
packages from that - if your home directory is in a separate partition, then it
will work when you reinstall packages.
eg:
```sh
# essentials
brew install git curl bzip2 zip  
# productivity
brew install tig tmux bat fd fzf 
brew install task timewarrior
# utils for code and run
brew install jq nq sqlite xsv neovim pandoc
# fun
brew install fortune youtube-dl  wtf 
# coding
brew install python node node@8
# website maker
brew install zola
#vcs + wiki + issues with one exe
brew install fossil 
# git-flow-avh edition
brew install git-flow-avh #http://danielkummer.github.io/git-flow-cheatsheet/


# spacemacs.org
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
git pull develop
```

### Optionals - download 64bit .deb files
- [Google Chrome](https://www.google.com/chrome/)
- [Microft VS Code](https://code.visualstudio.com/)
- [Boostnote.io](https://github.com/BoostIO/boost-releases/releases/)
- [Dropbox](https://www.dropbox.com/install-linux)
- [RipGrep](https://github.com/BurntSushi/ripgrep/releases)
- [Syncthing](https://syncthing.net/) - local network sync.
- [Source Code Pro fonts](https://www.rogerpence.com/posts/install-source-code-pro-font-on-ubuntu)

Double click the downloaded `.deb` files above and install it.

### Optionals - download tar/zip versions and extract
- [Firefox Dev Edition](https://www.mozilla.org/en-US/firefox/developer/)
- [TOR Browser](https://www.torproject.org/download/)
- [Anaconda Python](https://docs.anaconda.com/anaconda/install/linux/)

