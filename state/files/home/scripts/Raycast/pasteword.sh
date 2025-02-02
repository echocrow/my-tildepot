#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pasteword
# @raycast.description Copy a basic keychain password into the clipboard.
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔐
# @raycast.argument1 { "type": "text", "placeholder": "Name" }
# @raycast.argument2 { "type": "password", "placeholder": "Value", "optional": true }

if [[ -z "$2" ]]; then
  pasteword get "$1"
else
  pasteword set "$1" "$2"
fi
