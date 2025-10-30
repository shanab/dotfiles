# Fish to ZSH Migration Analysis

**Analysis Date:** October 25, 2025

This document compares the Fish shell configuration with the ZSH configuration to identify functional differences (excluding cosmetic/appearance changes).

## Missing Functionality in ZSH

### 1. **pyenv Integration**

- **Fish**: Has `pyenv init - | source` which properly initializes pyenv with shell integration
- **ZSH**: Missing pyenv initialization entirely

### 2. **FZF Key Bindings**

- **Fish**: Has custom FZF key bindings with:
  - `Ctrl+T`: File/folder widget
  - `Ctrl+R`: History search widget
  - `Alt+C`: Directory change widget
- **ZSH**: Only sources `~/.fzf.zsh` but doesn't explicitly set up these bindings (they may work if fzf installed them, but not guaranteed)

### 3. **FZF Environment Variables**

- **Fish**: Explicitly sets:
  - `FZF_CTRL_T_COMMAND` with fd
  - `FZF_ALT_C_COMMAND` with fd for directories
  - `FZF_DEFAULT_COMMAND` with fd for files
- **ZSH**: Only sets `FZF_DEFAULT_COMMAND`, missing the other two

### 4. **Custom Functions**

Fish has these functions that are missing in ZSH:

#### `cdr` - Change to Git Repository Root

```fish
function cdr
  cd (git rev-parse --show-toplevel) $argv
end
```

#### `po` - Pull from Current Branch

```fish
function po
  git pull origin (git rev-parse --abbrev-ref HEAD) $argv
end
```

#### `nvm` - Node Version Manager Integration

```fish
function nvm
    bass source ~/.nvm/nvm.sh ';' nvm $argv
end
```

#### `bass` - Run Bash Scripts in Fish

Allows running bash scripts and sourcing bash environment in fish shell

#### `fish_aws_prompt` - AWS Profile Display

Shows current AWS profile in prompt

### 5. **JQ Colors Configuration**

- **Fish**: Sets `JQ_COLORS="2:31"` for custom jq output colors
- **ZSH**: Missing this configuration

### 6. **GOBIN Environment Variable**

- **Fish**: Explicitly sets `GOBIN=$HOME/go/bin`
- **ZSH**: Only sets `GOPATH`, missing `GOBIN`

### 7. **Architecture-Aware Homebrew Path**

- **Fish**: Detects ARM64 vs x86 and sets brew path accordingly:
  ```fish
  if [ (arch) = 'arm64' ]
      set -gx brew_path /opt/homebrew
  else
      set -gx brew_path /usr/local/Homebrew
  end
  ```
- **ZSH**: Hardcoded to `/opt/homebrew` (ARM64 only)

### 8. **Additional Path Entries**

- **Fish**: Has `/Users/amshanab/projects/customers/danske/cmas/demo-3/cli` in path
- **ZSH**: Missing this path

## Functionality Present in ZSH but Missing in Fish

### 1. **direnv Hook**

- **ZSH**: Has `eval "$(direnv hook zsh)"`
- **Fish**: Missing

### 2. **Atuin Integration**

- **ZSH**: Has `eval "$(atuin init zsh)"`
- **Fish**: Missing

### 3. **Amazon Q Integration**

- **ZSH**: Has pre and post blocks for Amazon Q
- **Fish**: Missing

### 4. **ZSH Autosuggestions with Custom Keybindings**

- **ZSH**: Has zsh-autosuggestions with custom bindings:
  - `Ctrl+W`: Execute suggestion
  - `Ctrl+E`: Accept suggestion
  - `Ctrl+U`: Toggle suggestions
  - `Ctrl+L`: Forward word
  - `Ctrl+K`: Up line or search
  - `Ctrl+J`: Down line or search
- **Fish**: Has built-in autosuggestions but different keybindings

## Summary

### Priority Items to Port to ZSH:

1. ✅ pyenv initialization
2. ✅ Complete FZF command configuration (CTRL_T and ALT_C commands)
3. ✅ `cdr` function (cd to git root)
4. ✅ `po` function (pull from current branch)
5. ⚠️ nvm integration (if using Node.js)
6. ✅ JQ_COLORS setting
7. ✅ GOBIN variable
8. ⚠️ Architecture-aware brew setup (optional, if supporting multiple architectures)
9. ⚠️ Specific project path (if still needed)

### Items Already Better in ZSH:

- direnv integration
- atuin history management
- Amazon Q integration
- Enhanced autosuggestions with custom keybindings

---

_Analysis Date: 2025-10-25_
