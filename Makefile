# Makefile for dotfiles management
# Usage:
#   make install    - Install brew packages and stow dotfiles
#   make brew       - Install brew packages only
#   make stow       - Stow dotfiles only
#   make unstow     - Remove stowed dotfiles

.PHONY: install brew stow unstow themes themes-ghostty help

# Default target
install: brew stow

# Install brew packages from Brewfile
brew:
	@echo "Installing brew packages..."
	brew bundle --file=Brewfile

# Stow dotfiles to ~/.config
stow:
	@echo "Stowing dotfiles..."
	stow .

# Remove stowed dotfiles
unstow:
	@echo "Unstowing dotfiles..."
	stow --delete --verbose=2 .

# Download and update all themes
themes: themes-ghostty

# Download and update Catppuccin Ghostty themes
themes-ghostty:
	@echo "Updating Ghostty themes..."
	@if [ -d "/tmp/catppuccin-ghostty" ]; then \
		echo "Updating existing repository..."; \
		cd /tmp/catppuccin-ghostty && git pull; \
	else \
		echo "Cloning Catppuccin Ghostty repository..."; \
		git clone https://github.com/catppuccin/ghostty /tmp/catppuccin-ghostty; \
	fi
	@echo "Creating ghostty/themes directory..."
	@mkdir -p ghostty/themes
	@echo "Copying themes..."
	@cp -r /tmp/catppuccin-ghostty/themes/* ghostty/themes/
	@echo "Ghostty themes updated successfully!"

# Show help
help:
	@echo "Available targets:"
	@echo "  install  - Install brew packages and stow dotfiles"
	@echo "  brew     - Install brew packages only"
	@echo "  stow     - Stow dotfiles only"
	@echo "  unstow   - Remove stowed dotfiles"
	@echo "  themes   - Download/update all themes"
	@echo "  themes-ghostty - Download/update Catppuccin Ghostty themes"
	@echo "  help     - Show this help message"