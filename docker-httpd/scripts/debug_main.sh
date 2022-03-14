#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/.."
source <(cat .env | sed "s/=\(.*\)/='\1'/")

sudo chmod 660 .env*
sudo docker-compose run --rm -p ${FACADE_INTERFACE}:${HTTP_PORT}:80 main
