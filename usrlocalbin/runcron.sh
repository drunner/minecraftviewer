#!/bin/bash

if [ ! -e "/etc/cron.d" ]; then
   echo "/etc/cron.d does not exist"
   exit 1
fi

echo "17 * * * * druser /usr/loca/bin/generate.sh ${WORLD} ${APIKEY}" > /etc/cron.d/g
echo " " >> /etc/cron.d/g
cron && tail -f /var/log/cron.log
