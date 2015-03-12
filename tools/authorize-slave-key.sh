#!/bin/bash

# Print commands; fail on errors.
set -e

if [ "$#" -ne 3 ]; then
  echo "Usage: authorize-slave-key.sh <host> <port> <public key>"
  exit 1
fi

HOST=$1
PORT=$2
KEY=$3
cat $KEY | ssh -p$PORT vagrant@$HOST "cat >> ~/.ssh/authorized_keys"
