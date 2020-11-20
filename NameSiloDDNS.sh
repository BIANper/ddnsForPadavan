#!/bin/sh

MYAPIKEY="_"
MYDOMAIN="_"
MYHOST="_"
MYFULLDOMAIN="$MYHOST.$MYDOMAIN"

MYIP=`curl -s "https://api.ipify.org"`
OLDIP=$(tail -n 1 /home/root/iprecord.txt)

if ["$OLDIP" == "$MYIP"]; then
  echo "Nothing happened."
  exit 0
fi
echo "$MYIP" > /home/root/iprecord.txt
echo "IP has changed."

# Fetch DNS record ID
RESPONSE="$(curl -s "https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=$MYAPIKEY&domain=$MYDOMAIN")"
RECORD_ID="$(echo $RESPONSE | sed -n 's/^.*<record_id>\(.*\)<\/record_id><type>A<\/type><host>'$MYFULLDOMAIN'<\/host>.*$/\1/p')"

# Update DNS record in Namesilo
RESPONSE="$(curl -s "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=$MYAPIKEY&domain=$MYDOMAIN&rrid=$RECORD_ID&rrhost=$MYHOST&rrvalue=$MYIP&rrttl=7207")"

exit 0
