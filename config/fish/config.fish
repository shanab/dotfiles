set -gx EDITOR nvim

alias vim="nvim"

# set up brew
if [ (string lower (uname)) = 'darwin' ]
    if [ (arch) = 'arm64' ]
        set -gx brew_path /opt/homebrew
    else
        set -gx brew_path /usr/local/Homebrew
    end
    eval (env SHELL=fish $brew_path/bin/brew shellenv)
end

# git prompt settings
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_conflictedstate "+"
set -g __fish_git_prompt_color_dirtystate yellow
set -g __fish_git_prompt_color_cleanstate green --bold
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_branch cyan --dim --italics

# don't show greetings
set fish_greeting ""

# don't describe the command for darwin
# https://github.com/fish-shell/fish-shell/issues/6270
function __fish_describe_command; end

# Get pyenv to work
pyenv init - | source

fish_add_path $HOME/go/bin
set -gx GOBIN $HOME/go/bin

# Install zoxide
zoxide init fish | source

# Set up fzf
set -gx FZF_CTRL_T_COMMAND "fd --hidden --follow --no-ignore-vcs"
set -gx FZF_ALT_C_COMMAND "$FZF_CTRL_T_COMMAND --type d ."
set -gx FZF_DEFAULT_COMMAND "$FZF_CTRL_T_COMMAND --type f"

# Senstive functions which are not pushed to Github
source ~/.config/fish/private.fish

# Adjust JQ colors
set -gx JQ_COLORS "2:31"

# rbenv
# status --is-interactive; and rbenv init - fish | source
