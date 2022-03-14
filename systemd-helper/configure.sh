#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

readonly cwd="$(pwd)"
readonly service_file=$(cat container-pf.service.tmpl | \
  sed "s|__CURRENT_DIR__|${cwd}|")

sudo sh -c "echo \"${service_file}\" > /etc/systemd/system/container-pf.service"
ln -sf /etc/systemd/system/container-pf.service container-pf.service
