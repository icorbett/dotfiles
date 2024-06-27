#!/usr/bin/env bash

if ! [[ -d outputs ]]; then
  mkdir outputs
fi

defaults -currentHost read -g > outputs/defaults_currentHost.out
plutil -convert xml1 -o - ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist > outputs/plutil_GlobalPreferences.out

defaults read -g com.apple.keyboard.fnState > outputs/defaults_fnState.out
# defaults write -g com.apple.keyboard.fnState -boolean true
