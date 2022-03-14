#!/bin/bash

TOP="$(dirname "${BASH_SOURCE[0]}")/.."
config_dir="${TOP}/volumes/config"

if [[ -f "${config_dir}/my.cnf" ]]; then
  mv "${config_dir}/my.cnf" "${config_dir}/my.cnf.paused"
  echo "'volumes/config/my.cnf' toggled off"
elif [[ -f "${config_dir}/my.cnf.paused" ]]; then
  mv "${config_dir}/my.cnf.paused" "${config_dir}/my.cnf"
  echo "'volumes/config/my.cnf' toggled on"
fi
