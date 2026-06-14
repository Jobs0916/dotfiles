#!/bin/bash

set -e  # Detenerse ante errores

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

sudo apt install xclip -y \
    gcc \
    build-essential \
    git \
    libx11-dev \
    libxft-dev \
    libxinerama-dev \
    libxext-dev \
    libfontconfig1-dev \
    pkg-config \
    wget \
    curl \
    tar \
    xinit \
    feh \
    picom \
    stow 

echo -e "${GREEN}✓ Dependencias instaladas${NC}"

## Instala startship
curl -sS https://starship.rs/install.sh | sh
echo -e "${GREEN}✓ Startship instalada${NC}"

## Instala zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo -e "${GREEN}✓ Zoxide instalada${NC}"


# # Descarga e instala nvm:
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
#
# # # in lieu of restarting the shell
# \. "$HOME/.nvm/nvm.sh"
#
# # # Download and install Node.js:
# nvm install 24
#
# echo -e "${GREEN}✓ Nodejs y npm instaladas${NC}"

