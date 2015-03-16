#!/bin/bash

set -e

HOST=
PORT=22
SCRIPT=
USER_PREFIX=

while getopts ":-:" OPTCHAR; do
  case "$OPTCHAR" in
    -)
      case "$OPTARG" in
        host)
          HOST="${!OPTIND}"
          OPTIND=$(($OPTIND + 1))
          ;;
        port)
          PORT="${!OPTIND}"
          OPTIND=$(($OPTIND + 1))
          ;;
        user)
          USER_PREFIX="${!OPTIND}@"
          OPTIND=$(($OPTIND + 1))
          ;;
        script)
          SCRIPT="${!OPTIND}"
          OPTIND=$(($OPTIND + 1))
          ;;
        *)
          echo "Unknown option --$OPTARG"
          exit 1
          ;;
      esac
      ;;
    *)
      echo "Unknown option -$OPTARG"
      exit 1
      ;;
  esac
done

if [ -z "$HOST" ]; then
  echo "No --host specified"
  exit 1
fi

if [ -z "$SCRIPT" ]; then
  echo "No --script specified"
  exit 1
fi

if [ ! -f "$SCRIPT" ]; then
  echo "Script $SCRIPT doesn't exist"
  exit 1
fi

set -v

TMPFILE=/tmp/remote-script-$RANDOM.sh
scp -P$PORT $SCRIPT $USER_PREFIX$HOST:$TMPFILE
ssh -p$PORT $USER_PREFIX$HOST "bash $TMPFILE"
