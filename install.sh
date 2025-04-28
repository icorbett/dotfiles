#!/usr/bin/env sh
#set -e

# only allow sourcing
if ! [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    echo "execute ${0}, do not source it!"
    exit 1
fi

# get our location
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Detect os
case "$(uname -s)" in
  Linux)
    echo "It appears you are running Linux, setting things appropriately"
    GIT_PROMPT="/usr/lib/git-core/git-sh-prompt"
    ;;
  Darwin)
    echo "It appears you are running macOS, setting things appropriately"
    GIT_PROMPT="/usr/local/etc/bash_completion.d/git-prompt.sh"
    ;;
esac

# Detect shell
case "$(basename ${SHELL})" in
  bash)
    echo "It appears you are running bash, setting things appropriately"
    ;;
  zsh)
    echo "It appears you are running zsh, setting things appropriately"
    ;;
esac
