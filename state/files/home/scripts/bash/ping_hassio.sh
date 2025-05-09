#!/usr/bin/env bash

# date >> /Users/echocrow/Desktop/cron-log.txt
# date +%s >> ~/Desktop/cron-log.txt
# date >> ~/Desktop/cron-log.txt
# echo "$(date)" '|' "$(pmset -g systemstate | sed 's/[ \t]*$//' | tr '\n' '|' | sed 's/|$//;s/|/ | /')" >> ~/Desktop/cron-log.txt

# curl -v 'http://homeassistant.local:8123/api/webhook/MiniTytoOnline'

# echo -n "$(date)" >> ~/Desktop/cron-log.txt

powerstate="$(pmset -g systemstate)"
# posted='OMIT'
if [[ 
	"$powerstate" =~ Current\ System\ Capabilities\ are:[a-zA-Z\ ]*\ Graphics &&
	"$powerstate" =~ Current\ System\ Capabilities\ are:[a-zA-Z\ ]*\ Network &&
	"$powerstate" =~ Current\ Power\ State:\ 4 &&
	! "$powerstate" =~ Desired\ State:\ 2 ]] \
	; then
	curl -v 'http://homeassistant.local:8123/api/webhook/MiniTytoOnline'
	# posted='POST'
	# else
	# echo "BAD"
fi
exit 0

# echo " | ${posted} | $(echo "$powerstate" | sed 's/[ \t]*$//' | tr '\n' '|' | sed 's/|$//;s/|/ | /')" >> ~/Desktop/cron-log.txt
