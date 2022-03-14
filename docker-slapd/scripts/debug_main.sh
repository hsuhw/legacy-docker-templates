#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/.."
source <(cat ./.env | sed "s/=\(.*\)/='\1'/")

sudo docker-compose run --rm \
  -p ${FACADE_INTERFACE}:389:389 -p ${FACADE_INTERFACE}:636:636 \
  --entrypoint "bash -c '/container/tool/run --copy-service --loglevel debug'" \
  main
