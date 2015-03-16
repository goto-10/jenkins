#!/bin/bash

set -v -e

if [[ $EUID -ne 0 ]]; then
  echo "Must be run by root"
  exit 1
fi

TMPKEY=/tmp/key.pub
cat > $TMPKEY

DSSH=~jenkins/.ssh
if [ ! -d "$DSSH" ]; then
  mkdir -p $DSSH
  chown jenkins $DSSH
fi

AUTHS=$DSSH/authorized_keys
if [ ! -f "$AUTHS" ]; then
  touch $AUTHS
  chown jenkins $AUTHS
  chmod 644 $AUTHS
fi

if ! grep -f $TMPKEY $AUTHS; then
  cat $TMPKEY >> $AUTHS
fi
