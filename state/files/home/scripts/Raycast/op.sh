#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title 1Password Password
# @raycast.description Copy 1Password password into the clipboard.
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🛂

pasteword get 'op'
