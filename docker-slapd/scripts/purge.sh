#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/.."

function purge_() {
  purge_all
}

function purge_all() {
  echo 'This will delete all the data and configs.'
  confirm routine='remove_all'
}

function purge_data() {
  echo 'This will delete the data records.'
  confirm routine='remove_data'
}

function purge_config() {
  echo 'This will delete the config settings.'
  confirm routine='remove_config'
}

function remove_all() {
  remove_data
  remove_config
}

function remove_data() {
  sudo rm -fr "./volumes/data"
}

function remove_config() {
  sudo rm -fr "./volumes/config"
}

function confirm() {
  local routine
  local "${@}"

  read -r -p 'Are you sure to continue?  [y/N] '
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    "${routine}"
  else
    echo 'Abort.'
  fi
}

# === Call the arguments verbatim ===

# TODO provide help info
"purge_${@}"
