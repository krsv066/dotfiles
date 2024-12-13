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
    # brew install tmux
    # brew install neovim
    # brew install stow

    # brew install --cast alacritty

    # unnecessary
    # brew tap homebrew/cask

    # install font from here: https://www.nerdfonts.com/font-downloads
    # brew install --cask font-iosevka-term-nerd-font


    # show cmd+tab list on every connected display
    # https://www.reddit.com/r/mac/comments/pmoa2t/a_little_tip_for_people_using_multiple_displays/
    # defaults write com.apple.Dock appswitcher-all-displays -bool true; killall Dock
    # to revert:
    # defaults delete com.apple.Dock appswitcher-all-displays; killall Dock

    # TODO
if [ ${machine} == "Linux" ]; then
    sudo apt update
    sudo apt -y install tmux
    # manager symlinks
    sudo apt -y install stow
    sudo apt -y install git wget curl

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

    # plugin manager for tmux
    # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # install plugins
    # ~/.tmux/plugins/tpm/bin/install_plugins
fi



# install vim plug
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    # https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install vim plug for nvim
# curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    #    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# create symlinks for all files in this folder
# stow --adopt .

#install plugins for vim and nvim
# vim +PlugInstall +qall > /dev/null
# nvim --headless +PlugInstall +qall > /dev/null

chsh -s $(which zsh)
