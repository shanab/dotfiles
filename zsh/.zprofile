# Machine-specific login-shell setup that must run first (gitignored)
[[ -f ~/.config/zsh/.zprofile.pre.private ]] && source ~/.config/zsh/.zprofile.pre.private

# Machine-specific login-shell setup that must run last (gitignored)
[[ -f ~/.config/zsh/.zprofile.private ]] && source ~/.config/zsh/.zprofile.private
