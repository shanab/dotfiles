set -gx PATH '/Users/shanab/.rbenv/shims' $PATH
set -gx RBENV_SHELL fish
source '/opt/homebrew/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.fish'
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    # This doesn't seem to work?
    # source (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end
