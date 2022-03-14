#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/.."

sudo docker-compose run --rm \
  --entrypoint 'bash /scripts/init_directory.sh' \
  main
