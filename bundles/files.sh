#!/bin/bash

# Bundle inherited from tildepot.

export FILES="
  [dot]
  fish                  ~/.config/fish
  husky                 ~/.config/husky
  gitconfig             ~/.gitconfig
  gitignore             ~/.gitignore
  profile               ~/.profile
  zprofile              ~/.zprofile

  [home]
  scripts               ~/Scripts/

  [lib]
  colorsync-displays    ~/Library/ColorSync/Profiles/Displays

  [app-support]
  mouser                ~/Library/Application\ Support/mouser

  [preferences]         @plutil
  launchservices.plist  ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist
  iterm2.plist          ~/Library/Preferences/com.googlecode.iterm2.plist
  xgestures.plist       ~/Library/Preferences/what.xGestures.plist
"

function bundle::parse::dot/fish() {
  # Remove private (frequently changing) variables from fish config.
  # See https://github.com/IlanCosman/tide/issues/242
  sed -i '' '/^SETUVAR _/d' "$1/fish_variables"
}

function bundle::parse::preferences/iterm2.plist() {
  # Reset frequently changing variables in iTerm2 config.
  plutil -replace NoSyncLaunchExperienceControllerRunCount -integer 0 \
    "$BUNDLE_DIR/preferences/iterm2.plist"
}
