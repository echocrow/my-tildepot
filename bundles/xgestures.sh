#!/bin/bash
#
# Tildepot bundle for xGestures
# https://briankendall.net/xGestures/

XGESTURES_PREFPANE="$HOME/Library/PreferencePanes/xGestures.prefPane"

function INSTALL_SKIP() {
  [ -d "$XGESTURES_PREFPANE" ] && echo 'xGestures already installed'
}
function INSTALL() {
  _xgestures_download_and_copy "$(_xgestures_load_dmg_url)"
  ohai_success "Installed xGestures to [$XGESTURES_PREFPANE]."
}

function UPDATE_SKIP() {
  [ ! -d "$XGESTURES_PREFPANE" ] && echo 'xGestures not installed'
  [[ "$(_xgestures_read_current_version)" == "$(_xgestures_load_latest_version)" ]] && echo 'Already up to date'
}
function UPDATE() {
  _xgestures_download_and_copy "$(_xgestures_load_dmg_url)"
  ohai_success "Updated xGestures to [$(_xgestures_read_current_version)]."
}

function _xgestures_read_current_version() {
  defaults read "${XGESTURES_PREFPANE}/Contents/Info" CFBundleShortVersionString
}

function _xgestures_load_dmg_url() {
  local dl_page_url='https://briankendall.net/xGestures'
  echo "${dl_page_url}/$(curl -fsSL "${dl_page_url}/download.htm" | grep -o 'download_files/xGestures[0-9.]*.dmg')"
}

function _xgestures_load_latest_version() {
  basename "$(_xgestures_load_dmg_url)" | grep -o '[0-9]\.[0-9]\.[0-9]'
}

function _xgestures_download_and_copy() {
  local dmg_url="$1"

  # Create temp file
  dmg_file=$(mktemp).dmg
  trap 'rm -f "$dmg_file"' EXIT

  # Download.
  curl -fsSL "$dmg_url" -o "$dmg_file"

  # Mount.
  local vol_path
  vol_path=$(hdiutil attach "$dmg_file" | grep Volumes | cut -f 3-)

  # Copy PrefPane.
  rm -rf "$XGESTURES_PREFPANE"
  cp -R "$vol_path/$(basename "$XGESTURES_PREFPANE")" "$XGESTURES_PREFPANE"

  # Cleanup.
  hdiutil detach "$vol_path" -force -quiet
  rm "$dmg_file"
}
