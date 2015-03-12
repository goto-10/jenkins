#!/bin/bash

# Print commands; fail on errors.
set -v -e

if [ "$#" -ne 3 ]; then
  echo "Usage: install-master.sh <host> <port> <private key>"
  exit 1
fi

HOST=$1
PORT=$2
KEY=$3

# Copy the private key to the vagrant user's homedir. The install script will
# copy it on into jenkins.
cat $KEY | ssh -p$PORT vagrant@$HOST "mkdir keydrop && cat > keydrop/id_rsa"


# Run the install script which does most of the work locally.
HELPER=$(dirname $0)/install-master-helper.sh
scp -P$PORT $HELPER vagrant@$HOST:install-master-helper.sh
ssh -p$PORT vagrant@$HOST "sudo ./install-master-helper.sh"
