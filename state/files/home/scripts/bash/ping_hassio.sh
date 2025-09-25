#!/usr/bin/env bash

powerstate="$(pmset -g systemstate)"
if [[
	$powerstate == *'Current System Capabilities are:'*' Graphics'* &&
	$powerstate == *'Current System Capabilities are:'*' Network'* &&
	$powerstate == *'Current Power State: 4'* &&
	$powerstate != *'Desired State: 2'*
]]; then
	curl 'http://homeassistant.local:8123/api/webhook/MiniTytoOnline'
fi
