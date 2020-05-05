#!/usr/bin/env bash
#
# Purpose: This is a kickstart start script that will setup a the basics of a new computer for myself. #
#

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "ERROR - ${os} is not a supported operating system!"
    exit 1
fi

echo "#####################################
       Begin Kickstart Script...
#####################################" 

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Brew..."
    brew update
fi

# Get list of the currently installed brews and casks, if any. We'll use these
# to reduce runtime and brew installs more efficient.
INSTALLED_BREWS=( $(brew list) )
INSTALLED_CASKS=( $(brew cask list) )

# All the brew packages I'd like to install
BREWS=(
    awscli
    dropbox
    firefox
    git
    google-chrome
    google-drive
    gpgtools
    macvim
    markdown
    npm
    pkg-config
    postgresql
    python
    python3
    pypy
    rename
    ssh-copy-id
    tree
    wget
)

CASKS=(
    google-cloud-sdk
    iterm2
    slack
    vlc
)

PYTHON_PACKAGES=(
    virtualenv
    virtualenvwrapper
)

function remove_duplicated_packages() {
  for final in "${BREWS[@]}"; do
    for i in "${INSTALLED_BREWS[@]}"; do
      if [[ ${final[i]} = ${i} ]]; then
        echo "${final[i]} is already installed. Removing from install list..."
        unset ${final[i]}
      fi
    done
  done
}

echo "Starting installation of brew packages..."
for i in "${BREWS[@]}"
    do
        # Check to see if the package is already installed, if so, move on
        brew list ${i}
        if [[ $? -eq 1 ]]; then    
            echo "Installing ${i} via brew..."
            brew install ${i}
        else
            echo "Brew package ${i} is already installed. Moving on..."
            continue
        fi
    done

echo "Starting installation of brew cask packages..."
for i in "${CASKS[@]}"
    do
        # Check to see if the package is already installed, if so, move on
        brew cask list ${i}
        if [[ $? -eq 1 ]]; then    
            echo "Installing ${i} via brew..."
            brew cask install ${i}
        else
            echo "Brew package ${i} is already installed. Moving on..."
            continue
        fi
    done

echo "Installing Python packages..."
#TODO: update to do this via python3
sudo pip install ${PYTHON_PACKAGES[@]}

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "#####################################
        Kickstart Script Complete...
#####################################" 
