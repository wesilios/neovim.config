#!/usr/bin/env bash

# ============================================
# Neovim Configuration Installer for Linux/macOS
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Neovim Configuration Installer${NC}"
echo -e "${CYAN}  Platform: $(uname -s)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM=Linux;;
    Darwin*)    PLATFORM=macOS;;
    *)          PLATFORM="UNKNOWN:${OS}"
esac

echo -e "${YELLOW}Detected platform: ${PLATFORM}${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

MISSING_PREREQS=()

if ! command_exists nvim; then
    MISSING_PREREQS+=("Neovim")
    echo -e "${RED}[X] Neovim not found${NC}"
else
    NVIM_VERSION=$(nvim --version | head -n1)
    echo -e "${GREEN}[OK] Neovim found: ${NVIM_VERSION}${NC}"
fi

if ! command_exists git; then
    MISSING_PREREQS+=("Git")
    echo -e "${RED}[X] Git not found${NC}"
else
    echo -e "${GREEN}[OK] Git found${NC}"
fi

if ! command_exists node; then
    MISSING_PREREQS+=("Node.js")
    echo -e "${RED}[X] Node.js not found${NC}"
else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}[OK] Node.js found: ${NODE_VERSION}${NC}"
fi

if ! command_exists python3; then
    echo -e "${YELLOW}[!] Python3 not found (optional but recommended)${NC}"
else
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}[OK] Python3 found: ${PYTHON_VERSION}${NC}"
fi

# Check for build tools
if [ "$PLATFORM" = "Linux" ]; then
    if ! command_exists make; then
        MISSING_PREREQS+=("build-essential/make")
        echo -e "${RED}[X] make not found${NC}"
    else
        echo -e "${GREEN}[OK] make found${NC}"
    fi
elif [ "$PLATFORM" = "macOS" ]; then
    if ! command_exists make; then
        MISSING_PREREQS+=("Xcode Command Line Tools")
        echo -e "${RED}[X] Xcode Command Line Tools not found${NC}"
    else
        echo -e "${GREEN}[OK] Xcode Command Line Tools found${NC}"
    fi
fi

if [ ${#MISSING_PREREQS[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Missing required prerequisites: ${MISSING_PREREQS[*]}${NC}"
    echo ""
    echo -e "${YELLOW}Please install missing prerequisites:${NC}"
    
    if [ "$PLATFORM" = "Linux" ]; then
        echo -e "${NC}  Ubuntu/Debian:${NC}"
        echo -e "    sudo apt update"
        echo -e "    sudo apt install neovim git nodejs npm build-essential python3 python3-pip"
        echo ""
        echo -e "${NC}  Fedora:${NC}"
        echo -e "    sudo dnf install neovim git nodejs npm gcc make python3 python3-pip"
        echo ""
        echo -e "${NC}  Arch Linux:${NC}"
        echo -e "    sudo pacman -S neovim git nodejs npm base-devel python python-pip"
    elif [ "$PLATFORM" = "macOS" ]; then
        echo -e "${NC}  macOS:${NC}"
        echo -e "    brew install neovim git node python"
        echo -e "    xcode-select --install"
    fi
    echo ""
    exit 1
fi

echo ""
echo -e "${YELLOW}Setting up Neovim configuration...${NC}"

NVIM_CONFIG_PATH="$HOME/.config/nvim"
NVIM_DATA_PATH="$HOME/.local/share/nvim"

# Backup existing configuration
if [ -d "$NVIM_CONFIG_PATH" ]; then
    BACKUP_PATH="${NVIM_CONFIG_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Backing up existing configuration to: ${BACKUP_PATH}${NC}"
    mv "$NVIM_CONFIG_PATH" "$BACKUP_PATH"
fi

# Clone or copy configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/.git" ]; then
    echo -e "${YELLOW}Copying configuration from current directory...${NC}"
    mkdir -p "$(dirname "$NVIM_CONFIG_PATH")"
    cp -r "$SCRIPT_DIR" "$NVIM_CONFIG_PATH"
else
    echo -e "${YELLOW}Cloning configuration from GitHub...${NC}"
    git clone https://github.com/wesilios/neovim.config "$NVIM_CONFIG_PATH"
fi

echo -e "${GREEN}[OK] Configuration copied successfully${NC}"
echo ""

# Install vim-plug
echo -e "${YELLOW}Installing vim-plug...${NC}"
PLUG_PATH="${NVIM_DATA_PATH}/site/autoload/plug.vim"
PLUG_DIR="$(dirname "$PLUG_PATH")"

mkdir -p "$PLUG_DIR"

if curl -fLo "$PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    echo -e "${GREEN}[OK] vim-plug installed successfully${NC}"
else
    echo -e "${RED}Failed to install vim-plug${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Installing plugins...${NC}"
echo -e "${NC}This may take a few minutes...${NC}"

# Install plugins
if nvim --headless +PlugInstall +qall; then
    echo -e "${GREEN}[OK] Plugins installed successfully${NC}"
else
    echo -e "${YELLOW}[!] Plugin installation completed with warnings${NC}"
    echo -e "${YELLOW}You may need to run :PlugInstall manually in Neovim${NC}"
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${NC}  1. Open Neovim: nvim${NC}"
echo -e "${NC}  2. Check plugin status: :PlugStatus${NC}"
echo -e "${NC}  3. Check health: :checkhealth${NC}"
echo -e "${NC}  4. Install CoC extensions: :CocInstall coc-snippets coc-pairs${NC}"
echo ""
echo -e "${YELLOW}Optional language servers:${NC}"
echo -e "${NC}  - JavaScript/TypeScript: npm install -g typescript typescript-language-server${NC}"
echo -e "${NC}  - Python: pip3 install python-language-server${NC}"
echo -e "${NC}  - Rust: rustup component add rls rust-analysis rust-src${NC}"
echo ""

