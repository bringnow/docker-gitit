#!/bin/bash

# Based on https://github.com/Hyzual/docker-gitit
set -e

function die {
    echo >&2 "$@"
    exit 1
}

# Set timezone to TZ environment variable
if [ -z ${TZ} ]; then
  die "Timezone must be set via TZ environment variable must be specified!"
fi

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Set git author info
if [ -z "${GIT_USER_NAME}" ]; then
  die "GIT_USER_NAME must be specified!"
fi
if [ -z "${GIT_USER_EMAIL}" ]; then
  die "GIT_USER_EMAIL must be specified!"
fi

git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"

if [ ! -f /data/gitit.conf ]; then
  gitit --print-default-config > /data/gitit.conf
fi

if [ "$1" = 'gitit' ]; then
  exec gitit "$@"
fi

exec "$@"
