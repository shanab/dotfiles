# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS (ARM64) dotfiles repository using GNU Stow for symlink management. Configurations target `~/.config/` (defined in `.stowrc`).

## Commands

```bash
make install        # Install brew packages AND stow dotfiles
make brew           # Install Brewfile dependencies only
make stow           # Symlink dotfiles to ~/.config
make unstow         # Remove symlinks
make themes         # Download/update Catppuccin Ghostty themes
make tpm            # Install/update Tmux Plugin Manager
```

Start services after install:
```bash
brew services start sketchybar
```

## Architecture

**Symlink Pattern**: Each top-level directory mirrors `~/.config/` structure. Running `stow .` creates symlinks from `repo/tool/.config/tool/` to `~/.config/tool/`.

**Primary Shell**: ZSH (fish also present, migration in progress - see `fish-to-zsh-migration-analysis.md`)

**Key Configurations**:
- `zsh/.config/zsh/.zshrc` - Shell config with aliases, keybindings, tool integrations
- `nvim/.config/nvim/` - LazyVim-based Neovim with Go, Docker, Helm, YAML, Markdown plugins
- `aerospace/.config/aerospace/aerospace.toml` - Tiling window manager
- `sketchybar/.config/sketchybar/` - Custom menu bar with items/ and plugins/
- `starship/.config/starship/starship.toml` - Cross-shell prompt
- `ghostty/.config/ghostty/config` - Terminal with Catppuccin themes in themes/

**Theme**: Catppuccin palette used across Ghostty, SketchyBar, and Starship.

**Private Config**: `.zshrc.private` is sourced but not tracked (work/sensitive settings).

## Stow Ignores

Files excluded from symlinking (see `.stowrc`): Brewfile, Makefile, setup.sh, .stowrc, DS_Store, zsh/.zcompdump, atuin/*
