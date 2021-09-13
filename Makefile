all: sync

sync:
	mkdir -p ~/.config/kitty
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/nvim
	mkdir -p ~/.tmux

	[ -f ~/.config/kitty/kitty.conf ] || ln -s $(PWD)/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
	[ -d ~/.config/kitty/themes/ ] || ln -s $(PWD)/config/kitty/themes ~/.config/kitty/themes
	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/config/fish/config.fish ~/.config/fish/config.fish
	[ -d ~/.config/fish/functions/ ] || ln -s $(PWD)/config/fish/functions ~/.config/fish/functions
	[ -d ~/.config/fish/completions/ ] || ln -s $(PWD)/config/fish/completions ~/.config/fish/completions
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/config/nvim/init.lua ~/.config/nvim/init.lua
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/config/tmux/tmux.conf ~/.tmux.conf

	@echo 'Completed!'
clean:
	rm -rf ~/.config/kitty/kitty.conf
	rm -rf ~/.config/kitty/themes
	rm -rf ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions
	rm -rf ~/.config/fish/completions
	rm -rf ~/.config/nvim
	rm -rf ~/.tmux.conf
	rm -rf ~/.tmux/plugins

.PHONY: all clean sync
