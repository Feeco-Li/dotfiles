#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo ""
    echo "##############################################"
    echo "$1"
    echo "##############################################"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if apt package is installed
package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Function to check if snap package is installed
snap_installed() {
    snap list "$1" >/dev/null 2>&1
}

# Function to install apt package if not installed
install_apt() {
    local package=$1
    if package_installed "$package"; then
        echo -e "${GREEN}✓${NC} $package is already installed"
    else
        echo -e "${YELLOW}→${NC} Installing $package..."
        sudo apt install -y "$package"
    fi
}

# Function to install snap package if not installed
install_snap() {
    local package=$1
    local flags=${2:-""}
    if snap_installed "$package"; then
        echo -e "${GREEN}✓${NC} $package is already installed"
    else
        echo -e "${YELLOW}→${NC} Installing $package via snap..."
        sudo snap install $flags "$package"
    fi
}

# Function to install pip package if not installed
install_pip() {
    local package=$1
    local install_cmd=${2:-"pipx install $package"}  # default install command

    # Check if the package is already installed via pipx
    if pipx list | grep -q " $package "; then
        echo -e "${GREEN}✓${NC} $package is already installed via pipx"
    else
        echo -e "${YELLOW}→${NC} Installing $package via pipx..."
        eval "$install_cmd"
    fi
}

# Function to install Python package via uv if not installed
install_uv() {
    local package=$1
    local install_cmd=${2:-"uv tool install $package"}  # default install command

    # Check if the package is already installed via uv
    # Use command_exists as primary check since it's more reliable
    if command_exists "$package"; then
        echo -e "${GREEN}✓${NC} $package is already installed"
    else
        echo -e "${YELLOW}→${NC} Installing $package via uv..."
        # Use --force to overwrite if executable already exists
        if [[ "$install_cmd" == "uv tool install $package" ]]; then
            uv tool install --force "$package"
        else
            eval "$install_cmd"
        fi
    fi
}

# Function to install npm global package if not installed
install_npm_global() {
    local package=$1
    if npm list -g "$package" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $package is already installed globally"
    else
        echo -e "${YELLOW}→${NC} Installing $package globally via npm..."
        sudo npm install -g "$package"
    fi
}

# Function to setup passwordless sudo
setup_passwordless_sudo() {
    if sudo grep -Fxq "$USER ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
        echo -e "${GREEN}✓${NC} User already has passwordless sudo access"
    else
        echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
    fi
}

# Function to perform system update
system_update() {
    print_header "System Update"
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo snap refresh --hold # stop snap store updates
}

# Function to install a .deb package from URL
install_deb_from_url() {
    local url=$1
    local package_name=$2
    
    echo -e "${YELLOW}→${NC} Installing $package_name..."
    local filename=$(basename "$url")
    curl -LO "$url"
    sudo dpkg -i "$filename"
    rm "$filename"
}

# Function to install cargo package if not installed
install_cargo() {
    local package=$1
    local bin_name=${2:-$1}  # optional binary name if different from package name
    if command_exists "$bin_name"; then
        echo -e "${GREEN}✓${NC} $package is already installed"
    else
        echo -e "${YELLOW}→${NC} Installing $package via cargo..."
        cargo install "$package"
    fi
}

# Function to add user to a group
add_user_to_group() {
    local group=$1
    local user=${2:-$USER}
    
    if groups $user | grep -q "\\b$group\\b"; then
        echo -e "${GREEN}✓${NC} User $user is already in the $group group"
    else
        echo -e "${YELLOW}→${NC} Adding user $user to $group group..."
        sudo usermod -aG $group $user
        echo -e "${YELLOW}!${NC} Log out and back in, or run: newgrp $group"
    fi
}

# Function to cleanup system
cleanup_system() {
    print_header "Cleanup"
    sudo fc-cache -fv
    sudo apt clean -y
    sudo apt autoremove -y
    sudo apt autoclean -y
}

# Function to load configuration files
load_configs() {
    print_header "Loading Configuration Files"
    [ -f ~/.bashrc ] && source ~/.bashrc
    [ -f ~/.profile ] && source ~/.profile
    [ -f ~/.tmux.conf ] && command_exists tmux && tmux source-file ~/.tmux.conf 2>/dev/null || true
}

# Grant sudo access without password
setup_passwordless_sudo

# System update
system_update

# Command line tools
print_header "Command Line Tools"
install_apt kitty
install_apt w3m
install_apt w3m-img
install_apt fzf
install_apt fd-find
install_apt git
install_apt whois
install_apt openssh-client
install_apt tmux
install_apt ffmpeg
install_apt mediainfo
install_apt kazam
install_apt ncdu
install_apt vnstat
install_apt curl
install_apt btop
install_apt fcitx5
install_apt fcitx5-chinese-addons
install_apt fcitx5-frontend-gtk3
install_apt awesome
install_apt awesome-extra
install_apt suckless-tools  # contains slock to lock screen
install_apt brightnessctl # lock screen
install_apt ncal
install_apt ansiweather
install_apt tealdeer
install_apt fastfetch
install_apt picom
install_apt evremap
install_apt pdftk
install_apt expect
# email neomut
install_apt aerc
# remove unused debian utilities
sudo apt purge -y installation-report

# Node.js and npm
print_header "Node.js/npm/n"
install_apt nodejs
install_apt npm
# n
if command_exists n; then
    echo -e "${GREEN}✓${NC} n (node version manager) is already installed"
else
    echo -e "${YELLOW}→${NC} Installing n globally via npm..."
    sudo npm install -g n
    sudo n lts
fi

# Gemini CLI
print_header "Gemini CLI"
if command_exists gemini; then
    echo -e "${GREEN}✓${NC} gemini-cli is already installed"
else
    echo -e "${YELLOW}→${NC} Installing gemini-cli..."
    sudo npm install -g @google/gemini-cli
fi

# Git credential manager
print_header "Git Configuration"
if command_exists git-credential-manager; then
    echo -e "${GREEN}✓${NC} Git Credential Manager is already installed"
else
    echo -e "${YELLOW}→${NC} Installing Git Credential Manager..."
    LATEST_URL=$(curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | grep "browser_download_url.*gcm-linux_amd64.*\.deb" | cut -d '"' -f 4)
    install_deb_from_url "$LATEST_URL" "Git Credential Manager"
fi

git config --global --get-regexp credential

# GitHub CLI
if command_exists gh; then
    echo -e "${GREEN}✓${NC} GitHub CLI is already installed"
else
    echo -e "${YELLOW}→${NC} Installing GitHub CLI..."
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
fi

# AWS tools
print_header "AWS Tools"
install_snap aws-cli "--classic"
install_npm_global aws-cdk

# Docker Installation for Debian
print_header "Docker"
if command_exists docker; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓${NC} Docker is already installed: $DOCKER_VERSION"
else
    echo -e "${YELLOW}→${NC} Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo -e "${GREEN}✓${NC} Docker installed successfully"
fi

# Add user to docker group
add_user_to_group docker

# Lazydocker
if command_exists lazydocker; then
    echo -e "${GREEN}✓${NC} lazydocker is already installed"
else
    echo -e "${YELLOW}→${NC} Installing lazydocker..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# Database
print_header "Database"
if docker image inspect postgres:latest >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} PostgreSQL Docker image already exists"
else
    echo -e "${YELLOW}→${NC} Pulling PostgreSQL Docker image..."
    docker pull postgres:latest
fi

# Editors
print_header "Editors (nano/vim/neovim)"
sudo apt remove -y nano 2>/dev/null || true
sudo apt remove -y vim-gtk3 2>/dev/null || true
# install_apt vim
install_snap nvim
install_snap yazi
install_apt ripgrep
install_npm_global prettier
install_npm_global typescript

# Media
print_header "Media Player"
install_apt mpv

# Chrome
print_header "Google Chrome"
if command_exists google-chrome; then
    echo -e "${GREEN}✓${NC} Google Chrome is already installed"
else
    install_deb_from_url "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "Google Chrome"
fi

# WeChat
print_header "WeChat"
if command_exists wechat; then
    echo -e "${GREEN}✓${NC} WeChat is already installed"
else
    install_deb_from_url "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb" "WeChat"
fi

# PDF viewer
print_header "PDF Viewer"
install_apt zathura

# Screenshot tool
print_header "Screenshot Tool"
install_apt flameshot

# Python
print_header "Python"
install_apt python3
install_apt python3-pip

# Install uv (Python package manager)
if command_exists uv; then
    echo -e "${GREEN}✓${NC} uv is already installed"
else
    echo -e "${YELLOW}→${NC} Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install Python applications via uv
install_uv vimiv                     
install_uv ty                     
install_uv ruff                     
install_uv yt-dlp

# Install cargo (rust package manager)
if command_exists cargo; then
    echo -e "${GREEN}✓${NC} cargo is already installed"
else
    echo -e "${YELLOW}→${NC} Installing uv..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # check installation status
    rustc --version
    cargo --version
    # add LSP/formatter/Linter/Type Checker
    rustup component add rust-analyzer rustfmt clippy
fi

# Install cargo packages
install_cargo csvlens
install_cargo doxx
install_cargo tabiew tw
install_cargo cargo-generate
install_cargo cargo-binstall
install_cargo cargo-watch
install_cargo cargo-update
install_cargo cargo-make
install_cargo cargo-lambda
install_cargo cargo-audit

# Claude code Installation for Debian
print_header "Claude Code"
if command_exists claude; then
    CLAUDE_VERSION=$(claude --version)
    echo -e "${GREEN}✓${NC} Claude is already installed: $CLAUDE_VERSION"
else
    echo -e "${YELLOW}→${NC} Installing Claude..."
    curl -fsSL https://claude.ai/install.sh | bash
    echo -e "${GREEN}✓${NC} Claude installed successfully"
fi


# Install go
install_snap go

# resterm
print_header "resterm"
if command_exists resterm; then
    echo -e "${GREEN}✓${NC} resterm is already installed"
else
    echo -e "${YELLOW}→${NC} Installing resterm..."
    go install github.com/unkn0wn-root/resterm@latest
fi
# Cleanup
cleanup_system

# Load configuration files
load_configs

print_header "Installation Complete!"
echo -e "${GREEN}✓${NC} All installations finished successfully"
