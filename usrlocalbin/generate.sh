#!/bin/bash

# Generate minecraft world.

function die {
  echo "$1"
  exit 1
}


if [[ $# -eq 1 ]]; then
   WORLD="$1"
fi

[[ -v WORLD ]] || die "WORLD not set."

echo "World is ${WORLD}"

# get rid of any old cruft
[ ! -e "/www/new" ] || rm -rf /www/new
[ ! -e "/www/old" ] || rm -rf /www/old

# preserve cache
[ ! -e "/www/html" ] || cp -a /www/html /www/new

# generate updated map
"/Minecraft-Overviewer/overviewer.py" --rendermodes=smooth-lighting "/minecraft/data/${WORLD}" /www/new

# update hosted files
echo "Updating map"
[ ! -e "/www/html" ] || mv /www/html /www/old
mv /www/new /www/html

[ ! -e "/www/new" ] || rm -rf /www/new
[ ! -e "/www/old" ] || rm -rf /www/old
