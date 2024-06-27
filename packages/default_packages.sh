#!/usr/bin/env bash

shell_config_file () {
if [[ "${SHELL}" == '/bin/zsh' ]]; then
  echo "${HOME}/.zshrc"
elif [[ "${SHELL}" == '/bin/bash' ]]; then
  echo "${HOME}/.bashrc"
else
  echo "Shell is unsupported, exiting! SHELL: ${SHELL}"
  exit 1
fi
}

#shell_config_file="$(get_shell_config_file)"

check_shell_for_global_devbox () {
  grep -q 'eval "$(devbox global shellenv --init-hook)"' "$(shell_config_file)"
  grep_shell_config_file_for_devbox_init=$?
  # This could fail because the file doesn't exist OR the file doesn't match, this should solve both!
  if [[ "${grep_shell_config_file_for_devbox_init}" -ne 0 ]]; then
    touch "$(shell_config_file)"
    echo 'eval "$(devbox global shellenv --init-hook)"' >> "$(shell_config_file)"
  else
    echo "NOTE: $(shell_config_file) appears to already contain devbox global shellenv"
  fi
}

which_devbox="$(which devbox > /dev/null)"
which_devbox_exit_code=$?
if [[ "${which_devbox_exit_code}" -eq 0 ]]; then
  check_shell_for_global_devbox
  # echo "NOTE: Consider downloading your Global Config"
  # echo "XDG_DATA_HOME: ${XDG_DATA_HOME}"
  # devbox global path
else
  which_nix="$(which nix > /dev/null)"
  which_nix_exit_code=$?
  if [[ "${which_nix_exit_code}" -eq 0 ]]; then
    nix profile install nixpkgs#devbox
  else
    echo "NOTE: Consider installing Determinate Nix from here: https://install.determinate.systems/nix-installer-pkg/stable/Universal"
    echo "The current version of the Determinate Nix Installer is v0.19.0+build.1 with sha: ccd7a9ec4683bcdbc6ed16803695ae51ed14268474b80a3d234e8a1e72ec61e1"
  fi
fi

check_shell_for_brew () {
  grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$(shell_config_file)"
  grep_shell_config_file_for_brew_init=$?
  # This could fail because the file doesn't exist OR the file doesn't match, this should solve both!
  if [[ "${grep_shell_config_file_for_brew_init}" -ne 0 ]]; then
    touch "$(shell_config_file)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$(shell_config_file)"
  else
    echo "NOTE: $(shell_config_file) appears to already contain brew shellenv"
  fi
}

which_brew="$(which brew > /dev/null)"
which_brew_exit_code=$?
if [[ "${which_brew_exit_code}" -ne 0 ]]; then
  check_shell_for_brew
else
  echo "NOTE: Consider installing Homebrew from here: https://github.com/Homebrew/brew/releases/latest"
  echo "The current version of the Homebrew Installer is 4.3.6 with sha256: db80075d62a3847970af6089445081323fb70e7c70f01e480ed92e818489fad8"
fi
