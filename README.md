# Dotfiles

Personal dotfiles configuration for macOS (ARM64).

## Prerequisites

- macOS with ARM64 architecture
- Homebrew installed and updated

## Installation

### 1. Install Required Tools

```bash
# Clone this repository first
git clone <your-repo-url> ~/projects/dotfiles
cd ~/projects/dotfiles

# Install all dependencies at once
brew bundle
```

### 2. Setup Dotfiles

```bash
# Create symlinks using stow
stow .
```

### 3. Post-Installation Setup

#### Shell Configuration

```bash
# Change default shell (choose one)
chsh -s $(which fish)  # For fish
chsh -s $(which zsh)   # For zsh
```

#### Start Services

```bash
# Start sketchybar
brew services start sketchybar
```

## Tools Included

- **Shells**: Fish, Zsh with Starship prompt
- **Terminal**: Kitty, WezTerm, Ghostty configurations
- **Editor**: Neovim with LazyVim
- **Multiplexers**: Tmux, Zellij
- **Window Management**: Aerospace
- **System**: SketchyBar
- **History**: Atuin for shell history sync

## Usage

After installation, restart your terminal or source your shell configuration. Most tools will be automatically configured through the symlinked dotfiles.

## Troubleshooting

- Ensure all Homebrew packages are installed successfully
- Check that services are running: `brew services list`
