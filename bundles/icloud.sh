#!/bin/bash
#
# Tildepot bundle for Apple iCloud

function INSTALL() {
  local created=
  [ ! -e ~/Docs ] && ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents ~/Docs && created=1
  [ ! -e ~/Backlog ] && ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Backlog ~/Backlog && created=1
  if [[ -n $created ]]; then
    tilde::success "Created iCloud symlinks created."
  else
    tilde::warning "Skipped iCloud symlinks; they already exist."
  fi
}
