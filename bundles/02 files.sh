#!/usr/bin/env bash

export EXTEND='files-bundle@1.0.0-next.7'

export FILES="
  [dot]
  fish                  ~/.config/fish
    !functions/_*
  husky                 ~/.config/husky
  gitconfig             ~/.gitconfig
  gitignore             ~/.gitignore
  profile               ~/.profile
  zprofile              ~/.zprofile

  [home]
  scripts               ~/Scripts

  [lib]
  colorsync-displays    ~/Library/ColorSync/Profiles/Displays

  [app-support]
  mouser                ~/Library/Application Support/mouser

  [preferences]         @plutil
  launchservices.plist  ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist
  iterm2.plist          ~/Library/Preferences/com.googlecode.iterm2.plist
  xgestures.plist       ~/Library/Preferences/what.xGestures.plist
"

function bundle::parse::dot/fish() {
  # Remove private (frequently changing) variables from fish config.
  # See https://github.com/IlanCosman/tide/issues/242
  sed -i '' '/^SETUVAR _tide_prompt_/d' "$1/fish_variables"
}

function bundle::parse::home/scripts() {
  # Remove temporary tildepot link.
  rm -f "$1/bin/tildepot"
}
function bundle::serialize::home/scripts() {
  ln -s "$HOME/Projects/tildepot/dist/tildepot" "$1/bin/tildepot"
  tilde::success 'Restored temporary [tildepot] link'
}

function bundle::parse::preferences/iterm2.plist() {
  # Reset frequently changing variables in iTerm2 config.
  plutil -replace NoSyncLaunchExperienceControllerRunCount -integer 0 \
    "$BUNDLE_STATE_DIR/preferences/iterm2.plist"
}


function RESTORE() {
  SUPER

  printf "\n"
  printf "\033[34m==>\033[0m \033[1;39mCaveats\033[0m\n"
  printf "To restore the prompt, either restart this terminal, or run:\n"
  printf "  \033[34mtide reload\033[0m\n"
}
