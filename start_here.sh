#!/usr/bin/env sh
set -e

# Install Command Line Tools (CLT) for Xcode:
xcode-select --install

# Install homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Next run `make brew` to install Homebrew stuff"
