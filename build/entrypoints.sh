#!/bin/bash
###
# Name: entrypoints.sh
# @author: Aether
###

# Security
PATH=$(/usr/bin/getconf PATH || kill $$)

# Color
GREEN="\e[32m"
RESET="\033[0m"

# Const
PATH_EXTENSIONS="/opt/extensions"
PATH_TOOLS="/opt/tools"
PATH_ZSH_CUSTOM_PLUGINS="/root/.oh-my-zsh/custom/plugins"
PATH_ZSHRC="/root/.zshrc"

# Print
function debug {
    echo -e "${GREEN}[i] $1${RESET}"
}

# Update
function update {
    apt -qq update
}

# Clean update
function clean_update {
    apt autoremove
    apt clean
    # Delete apt cache
    rm -rf /var/lib/apt/lists/*
}

# Install all arguments
function install {
    apt -qq install --no-install-recommends -y "$@" 2>&1 1>/dev/null
}

# Install shell
function install_shell {
    install zsh
}

# Install other usefull tools
function install_utils {
    install vim binutils git wget curl ca-certificates bsdmainutils build-essential binutils-arm-linux-gnueabihf-dbg
}

# Install compiler
function install_compiler {
    install gcc clang llvm lld nasm
}

# Install tools to run binary for different architecture
function install_arch {
    install qemu-user qemu-user-static
}

function install_debug_extensions {
    git clone https://github.com/longld/peda $PATH_EXTENSIONS/peda
    echo "source $PATH_EXTENSIONS/peda/peda.py" >> ~/.gdbinit
    #git clone https://github.com/pwndbg/pwndbg.git $PATH_EXTENSIONS/pwndbg
    #cd $PATH_EXTENSIONS/pwndbg/
    #$PATH_EXTENSIONS/pwndbg/setup.sh 2>&1 1>/dev/null
    cd /
}

# Debug tools
function install_debug {
    install gdb gdb-multiarch

    install_debug_extensions
}

# Install each lib for a specific language
function install_language_lib {
    python3 -m pip install PyCryptodome pwntools wheel 2>&1 1>/dev/null
}

# Install each language
function install_language {
    install python3 python2.7 python3-pip python3-setuptools python-setuptools

    install_language_lib
}

# Install tools to unpack binary
function install_unpacker {
    install upx
}

# Install each tools
function install_tools {
    install_shell
    install_utils
    install_compiler
    install_arch
    install_debug
    install_language
    install_unpacker
}

function setup_shell_plugins {
    # Search tool
    git clone --depth 1 https://github.com/junegunn/fzf.git $PATH_EXTENSIONS/fzf/
    $PATH_EXTENSIONS/fzf/install --all
    echo -e "export FZF_BASE=$PATH_EXTENSIONS/fzf\n$(cat $PATH_ZSHRC)" > $PATH_ZSHRC

    # Syntax Highlig tool
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PATH_ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting/

    # Auto suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $PATH_ZSH_CUSTOM_PLUGINS/zsh-autosuggestions/

    # Change plugins
    sed -i 's/plugins=(git)/plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)/g' $PATH_ZSHRC
}

# Setup shell configuration
function setup_shell {
    # Theme: robbyrussell
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template $PATH_ZSHRC
    # Change shell settings
    chsh -s $(which zsh)

    setup_shell_plugins
}

function setup_alias {
    echo "alias ll='ls -lah'" >> $PATH_ZSHRC
}

function main {
    debug "Launch update"
    update
    debug "Done"

    debug "Install tools now"
    install_tools
    debug "Done"

    debug "Clean update cache"
    clean_update
    debug "Done"

    debug "Setup zsh"
    setup_shell
    debug "Done"

    debug "Add alias"
    setup_alias
    debug "Done"
}

main
