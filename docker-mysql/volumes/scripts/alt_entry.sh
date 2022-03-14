#!/bin/bash

# change the format of private key
openssl rsa -in /cert/key.pem -out /private_key.pem

# invoke the origin entrypoint routine
docker-entrypoint.sh "$@"
