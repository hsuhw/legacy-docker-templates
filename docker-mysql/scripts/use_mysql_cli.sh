#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/.."

sudo chmod 660 .env*
sudo docker-compose run --rm main sh
