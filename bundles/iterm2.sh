#!/bin/bash
#
# Tildepot bundle for iTerm2
# https://iterm2.com/

function INSTALL_SKIP() {
  [ -f ~/.iterm2_shell_integration.fish ] && echo 'iTerm2 shell integration already installed'
}
function INSTALL() {
  curl -fsSL https://iterm2.com/shell_integration/install_shell_integration.sh | SHELL='fish' bash
  ohai_success "Installed iTerm2 shell integration."
}
