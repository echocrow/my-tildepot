# Commands to run in interactive sessions can go here
if status is-interactive

    # Fish Integration
    test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

end

# Add custom executables
fish_add_path -agP {$HOME}/Scripts/bin

# Add custom functions
# set -a fish_function_path {$HOME}/Scripts/fish/functions

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
