#!/bin/bash

mydomain="_"
myhostname="_"
gdapikey="_:_"

myip=`curl -s "https://api.ipify.org"`
oldip=$(tail -n 1 /home/root/iprecord.txt)

if ["$oldip" == "$myip"]; then
  echo "Nothing happened."
  exit 0
fi
echo "$myip" > /home/root/iprecord.txt
echo "IP has changed."
curl -s -X PUT "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}" -H "Authorization: sso-key ${gdapikey}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
exit 0
