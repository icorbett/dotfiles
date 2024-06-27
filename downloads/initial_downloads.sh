#!/usr/bin/env bash

DOWNLOADS="${HOME}/Downloads"

just_download () {
  URL="${1}"
  
  which_wget="$(which wget > /dev/null)"
  which_wget_exit_code=$?
  
  which_curl="$(which curl > /dev/null)"
  which_curl_exit_code=$?

  if [[ "${which_wget_exit_code}" -eq 0 ]]; then
    wget "${URL}" "${DOWNLOADS}"
  elif [[ "${which_curl_exit_code}" -eq 0 ]]; then
    curl --output-dir "${DOWNLOADS}" --remote-name --remote-header-name --location "${URL}"
  else
    echo "No download agent available, exiting!"
    exit 1
  fi
}

just_verify () {
  FILENAME=$1

  sha256sum "${DOWNLOADS}/${FILENAME}" \
    | grep -q "${SHA}"
  exit_code=$?

  if [[ "${exit_code}" -eq 0 ]]; then
    echo "Downloaded ${FILENAME} matches ${SHA}"
  else
    echo "Downloaded ${FILENAME} DOES NOT MATCH, Deleting!"
    echo rm "${DOWNLOADS}/${FILENAME}"
  fi
}

download_and_verify () {
  URL="${1}"
  SHA="${2}"

  # TODO: Deal with names that contain double quotes and/or spaces
  FILENAME=$(curl --head -s -o /dev/null --location \
    -w '%header{Content-Disposition}' ${URL} \
      | grep -Po '(?<=filename=).*' \
  )
  if ! [[ "${FILENAME}" ]]; then
    # LASTPATH=${URL##*/}
    # FILENAME="$(echo -e ${LASTPATH/\%/\\x})"
    FILENAME=${URL##*/}
  fi

  if [[ -e "${DOWNLOADS}/${FILENAME}" ]]; then
    just_verify "${FILENAME}"
  else
    just_download "${URL}" "${SHA}"
    just_verify "${FILENAME}"
  fi
}

download_and_verify https://github.com/rxhanson/Rectangle/releases/download/v0.80/Rectangle0.80.dmg 0a66213271219f750af36457b93d4a4210282bfd1ec1c514ea1ef77a5d8ba70f
download_and_verify https://download-installer.cdn.mozilla.net/pub/firefox/releases/127.0.1/mac/en-US/Firefox%20127.0.1.dmg b26e36efe95b2cb0c6c01b726587183c6e6e324fd51b5a0b95c1744bf1a54c3d
download_and_verify https://github.com/Homebrew/brew/releases/download/4.3.6/Homebrew-4.3.6.pkg db80075d62a3847970af6089445081323fb70e7c70f01e480ed92e818489fad8
download_and_verify https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.2.31487-arm64.dmg 51ea1be65b671f1ae99024230a4feb9c3245d0910dd27d2a3e9d5f59d0a99c7f
download_and_verify https://install.determinate.systems/nix-installer-pkg/stable/Universal ccd7a9ec4683bcdbc6ed16803695ae51ed14268474b80a3d234e8a1e72ec61e1
