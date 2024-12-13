#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo Installing configs for $machine

# if [ ${machine} == "Mac" ]; then
    # TODO

if [ ${machine} == "Linux" ]; then
    sudo apt update
    sudo apt -y install wget
    sudo apt -y install curl
    
    sudo apt -y install telegram-desktop

    sudo apt -y install tmux

    sudo apt -y install clang
    sudo apt -y install clang-format

    # install eza
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

    # install neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    echo "Removing nvim installed with apt"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    PATH="$PATH:/opt/nvim-linux64/bin"
    sudo rm -rf ~/.config/nvim
    cp -R .config/nvim  ~/.config

    #install kitty
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    sudo ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/local/bin/
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
    sudo rm ~/.config/kitty/kitty.conf
    cp kitty.conf ~/.config/kitty

    #install zsh
    sudo apt -y install zsh
    # install oh-my-zsh
    sh -c "$(yes N | curl -fsSL https://install.ohmyz.sh/)"
    curl -fsSL https://install.ohmyz.sh/ > ohmyzshsetup
    chmod +x ohmyzshsetup
    yes N | ./ohmyzshsetup
    sudo rm -rf ~/.zshrc
    cp .zshrc ~
    #install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    omz reload
fi

#set zsh as deefault shell
chsh -s $(which zsh)
