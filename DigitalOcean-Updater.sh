#!/bin/bash

#################### VARIABLES ####################
TOKEN="aaaaabbbbbccccc000001111122222"
DOMAIN="example.com"
RECORD_V4=("300000001" "300000002")
RECORD_V6=("300000003" "300000004")
###################################################

CURRENT_IPV4="$(curl -s v4.ident.me)"
CURRENT_IPV6="$(curl -s v6.ident.me)"

for RECORD_ID in ${RECORD_V4[*]}
do
	LAST_IPV4="$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"  | json_pp | grep "data" | awk -F '"' '{print $4}')"
	HOST="$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"  | json_pp | grep "name" | awk -F '"' '{print $4}')"
	if [ $CURRENT_IPV4 == $LAST_IPV4 ]; then
		echo "IPV4 has not changed for [$HOST] ($CURRENT_IPV4)"
	else
		echo "IPV4 for [$HOST] has changed to $CURRENT_IPV4 from $LAST_IPV4"
		curl -s -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"data":"'"$CURRENT_IPV4"'"}' "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"
		echo ""
	fi
done

for RECORD_ID in ${RECORD_V6[*]}
do
	LAST_IPV6="$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"  | json_pp | grep "data" | awk -F '"' '{print $4}')"
	HOST="$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"  | json_pp | grep "name" | awk -F '"' '{print $4}')"
	if [ $CURRENT_IPV6 == $LAST_IPV6 ]; then
		echo "IPv6 has not changed for [$HOST] ($CURRENT_IPV6)"
	else
		echo "IPV6 for [$HOST] has changed to $CURRENT_IPV6 from $LAST_IPV6"
		curl -s -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"data":"'"$CURRENT_IPV6"'"}' "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID"
		echo ""
	fi
done
