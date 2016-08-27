#!/bin/bash


function die {
  echo "$1"
  exit 1
}


if [[ $# -eq 2 ]]; then
   WORLD="$1"
   APIKEY="$2"
fi

[[ -v WORLD ]] || die "WORLD not set."
[[ -v APIKEY ]] || die "APIKEY not set."

echo "World is ${WORLD}"

overviewer.py "/minecraft/data/${WORLD}" /www
sed -i "s/sensor=false/key=${APIKEY}/g" /www/index.html
