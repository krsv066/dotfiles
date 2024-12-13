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
    sudo apt -y install git wget curl
    
    sudo apt -y install tmux

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

    #install zsh
    sudo apt -y install zsh
    # install oh-my-zsh
    sh -c "$(yes N | curl -fsSL https://install.ohmyz.sh/)"
    curl -fsSL https://install.ohmyz.sh/ > ohmyzshsetup
    chmod +x ohmyzshsetup
    yes N | ./ohmyzshsetup
    #install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    omz reload
fi

#set zsh as deefault shell
chsh -s $(which zsh)
