# Dotfiles Base Configuration - Knowledge Base

**Analyzed by:** Claude Code
**Date:** 2025-12-09
**Project Version:** Open Source Base Configuration

## Quick Facts

- **Type:** Dotfiles/System Configuration
- **Primary Language:** Shell (Bash/ZSH)
- **Framework:** Dotbot (dotfiles installer)
- **Target Platform:** macOS (Apple Silicon & Intel)
- **Complexity:** Medium

## Purpose

This repository provides a foundational system configuration for PHP developers on macOS. It automates the installation of development tools, configures the ZSH shell environment, and sets up essential dotfiles for a productive development workflow.

## Key Features

- Automated software installation via Homebrew
- ZSH shell configuration with Antidote plugin manager
- Powerlevel10k prompt theme with minimal mode for Claude Code
- Extensive Git and Docker aliases
- Multi-architecture support (Apple Silicon arm64 / Intel x86_64)
- Modular configuration with shared/custom overlay system
- FZF integration with history database search

## Technology Stack

- **Shell:** ZSH with Antidote plugin manager
- **Installer:** Dotbot (git submodule)
- **Package Manager:** Homebrew (brew)
- **Node Management:** nodenv
- **Python Management:** pyenv
- **Editor:** Vim with IdeaVim for JetBrains IDEs

---

## Architecture Overview

```
dotfiles-base/
├── install                    # Main entry point - runs dotbot
├── install.conf.yaml          # Dotbot configuration (symlinks, shell commands)
├── autoinstall.sh             # One-liner bootstrap script
├── dotbot/                    # Git submodule - dotfiles installer
├── init/
│   ├── install.sh             # Package installation orchestrator
│   └── packages.default.sh    # Default package definitions
├── zsh/
│   ├── 10-zshenv.sh          # First: PATH reset, sources zprofile
│   ├── 20-zprofile.sh        # Environment variables, language configs
│   ├── 30-zshrc.sh           # Main config: Antidote, plugins
│   ├── 40-zlogin.sh          # Post-zshrc commands (empty)
│   ├── 50-zlogout.sh         # Logout commands (empty)
│   ├── zsh_plugins.txt       # Full plugin list
│   ├── zsh_plugins_minimal.txt # Minimal plugins for Claude Code
│   └── includes/             # Modular configuration
│       ├── alias/            # Shell aliases
│       ├── functions/        # Shell functions
│       ├── env/              # Environment variables
│       ├── custom.d/         # Custom plugin configs
│       └── plugins.config.d/ # Plugin-specific configs
├── vim/
│   ├── vimrc                 # Vim configuration
│   └── ideavimrc             # JetBrains IdeaVim configuration
├── ssh/
│   └── config                # SSH base configuration
├── multitail/
│   └── multitailrc           # Log viewer color schemes
└── bin/
    └── updateBaseConfig.sh   # Update script
```

## ZSH Loading Order

1. `~/.zshenv` (10-zshenv.sh) - Resets PATH, sources zprofile
2. `~/.zprofile` (20-zprofile.sh) - Sets environment variables
3. `~/.zshrc` (30-zshrc.sh) - Loads Antidote plugins
4. `~/.zlogin` (40-zlogin.sh) - Post-init (empty)
5. `~/.zlogout` (50-zlogout.sh) - Logout (empty)

---

## Installation

### Quick Install (One-liner)

```bash
curl https://raw.githubusercontent.com/mickaelperrin/dotfiles-machine-mac-opensource/master/autoinstall.sh | bash
```

### Manual Install

```bash
mkdir -p ~/.dotfiles.base
git clone mickaelperrin/dotfiles-machine-mac-opensource ~/.dotfiles.base
~/.dotfiles.base/install
```

### Update

```bash
~/.bin.base/updateBaseConfig.sh
```

---

## Component Details

### Dotbot Configuration (install.conf.yaml)

Creates symlinks for:
- `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.zlogin`, `~/.zlogout`
- `~/.vimrc`, `~/.ideavimrc`
- `~/.ssh/config`
- `~/.multitailrc`
- `~/.bin.base` (custom scripts)
- `~/.zsh/includes` (modular ZSH configs)
- `~/.zsh_plugins.txt`

### Package Installation (init/packages.default.sh)

**Homebrew Taps:**
- homebrew/core, homebrew/cask, homebrew/cask-fonts
- kaplanelad/tap (shellfirm)

**Key Packages:**
- Development: git, php, composer, node, nodenv, pyenv, go
- Docker: docker-compose, ctop, mutagen-compose-beta
- Tools: fzf, fd, jq, yq, vim, wget, tree, htop
- Security: blackbox, mkcert, nss, gpg-suite-no-mail, 1password-cli
- Git: git-lfs, git-filter-repo, tig

**Cask Applications:**
- alfred, 1password, iterm2, jetbrains-toolbox

**Python Packages (pip):**
- pygments, pyotp, virtualenv

**Composer Packages:**
- davidrjonas/composer-lock-diff

### ZSH Plugin Configuration

**Full Mode Plugins (zsh_plugins.txt):**
- zsh-users/zsh-completions
- mattmc3/ez-compinit
- romkatv/powerlevel10k (prompt)
- b4b4r07/enhancd (navigation)
- Tarrasch/zsh-autoenv
- MichaelAquilina/zsh-autoswitch-virtualenv
- zdharma-continuum/fast-syntax-highlighting
- larkery/zsh-histdb
- ariaieboy/laravel-sail
- zsh-users/zsh-autosuggestions
- zsh-users/zsh-history-substring-search

**Minimal Mode (Claude Code):**
When `CLAUDECODE=1` is set:
- Simplified prompt: `%~ %# `
- Only essential plugins loaded
- No Powerlevel10k

### Modular Include System

The `~/.zsh/includes/` directory supports a 3-tier overlay:
1. `1-common/` - Base configuration (this repo)
2. `2-shared/` - Shared team configs (symlink, gitignored)
3. `3-custom/` - Personal configs (symlink, gitignored)

Files are loaded in alphabetical order within each tier.

---

## Key Aliases

### Git Aliases (alias.git.sh)

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gco` | `git checkout` | Checkout |
| `gbc` | `git checkout -b` | Create branch |
| `gc` | `git commit --verbose` | Commit |
| `gcm` | `git commit --message` | Commit with message |
| `gca` | `git commit --verbose --all` | Commit all |
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Force push (safe) |
| `gfr` | `git pull --rebase` | Pull rebase |
| `gfra` | `git pull --rebase --autostash` | Pull rebase autostash |
| `gs` | `git stash` | Stash |
| `gsp` | `git stash pop` | Stash pop |
| `gr` | `git rebase` | Rebase |
| `gri` | `git rebase --interactive` | Interactive rebase |
| `gl` | `git log` | Log |
| `glg` | `git log --graph` | Log graph |
| `gia` | `git add` | Add |
| `gir` | `git reset` | Reset |
| `gwcS` | `git status` | Status |
| `gwcd` | `git diff` | Diff |

### Docker Aliases (alias.docker.sh)

| Alias | Command | Description |
|-------|---------|-------------|
| `dk` | `docker` | Docker shorthand |
| `dkps` | `docker ps` | List containers |
| `dkpsa` | `docker ps -a` | List all containers |
| `dki` | `docker images` | List images |
| `dkE` | `docker exec -it` | Interactive exec |
| `dkR` | `docker run -it --rm` | Run interactive |
| `dkl` | `docker logs` | View logs |
| `dkc` | `docker compose` | Compose shorthand |
| `dkcu` | `docker compose up` | Compose up |
| `dkcU` | `docker compose up -d` | Compose up detached |
| `dkcd` | `docker compose down` | Compose down |
| `dkcl` | `docker compose logs` | Compose logs |

### Tool Aliases (alias.tools.sh)

| Alias | Command | Description |
|-------|---------|-------------|
| `del` | `trash -F` | Move to trash (safe delete) |
| `rm` | (disabled) | Shows warning to use `del` |
| `dud` | `du -d 1 -h \| sort -h` | Disk usage summary |
| `k9` | `kill -9` | Force kill |

---

## Custom Functions

### Helper Functions (functions.helpers.sh)

```bash
exists <command>     # Check if command exists
ask "<question>"     # Interactive yes/no prompt
title "<text>"       # Set terminal title
```

### Docker Functions (functions.docker.sh)

```bash
docker_context_show  # Show current Docker context
dstop                # Stop all containers (with confirmation)
drmall               # Remove all containers (with confirmation)
driall               # Remove all images (with confirmation)
dalias               # Show all docker aliases
dclean               # Clean dangling volumes
```

### Git Functions (functions.git.sh)

```bash
gdn                  # Git diff including untracked files
```

### Python Functions (functions.python.sh)

```bash
gpip <args>          # Run pip without virtualenv requirement
gpip3 <args>         # Run pip3 without virtualenv requirement
syspip <args>        # Run system pip with sudo
```

---

## Vim Configuration

### Key Mappings (vimrc)

- Leader key: `,`
- `,w` - Save file
- `Space` - Search
- `Ctrl+j/k/h/l` - Window navigation
- `,bd` - Close buffer
- `,tn` - New tab
- `,ss` - Toggle spell check
- `,pp` - Toggle paste mode
- `0` - Go to first non-blank character

### IdeaVim Configuration (ideavimrc)

- Leader key: `Space`
- `jk` - Exit insert mode
- `<leader>x` - Toggle NERDTree
- `<leader>ff` - Go to file
- `<leader>fc` - Search in path
- `<leader>gd` - Go to definition
- `<leader>gu` - Show usages
- `<leader>rn` - Rename element
- `<leader>rr` - Refactoring menu
- `<leader>gc` - Git commit dialog
- `<leader>gs` - Git status

Plugins enabled: surround, highlightedyank, sneak, nerdtree, easymotion, which-key

---

## Environment Variables

### Path Configuration (20-zprofile.sh)

Paths added to `$PATH`:
- `$HOME/{bin,.bin,.bin.base}`
- `$HOME/.composer/vendor/bin`
- `$HOME/.gem/bin`
- `$HOME/.rvm/bin`
- `$HOME/.cargo/bin`
- JetBrains Toolbox scripts
- `/opt/homebrew/bin` (Apple Silicon)

### Language-Specific

```bash
EDITOR='vim'
VISUAL='vim'
PAGER='less'
LANG='fr_FR.UTF-8'

# Python
PIP_REQUIRE_VIRTUALENV=true
WORKON_HOME=$HOME/.virtualenvs.$(uname -m)
PYENV_ROOT="${HOME}/.pyenv.$(uname -m)"

# Node
NODENV_ROOT="${HOME}/.nodenv.$(uname -m)"

# Ruby
GEM_HOME="$HOME/.gem.$(uname -m)"

# Parallel
PARALLEL_HOME="$HOME/.parallel.$(uname -m)"
PARALLEL_SHELL=$(which zsh)
```

### FZF Configuration

```bash
FZF_COMPLETION_TRIGGER='@@'
FZF_DEFAULT_OPTS="--no-sort --reverse --prompt='>> ' --inline-info --no-height --exact"
```

---

## SSH Configuration

Base SSH configuration with security defaults:
- `IdentitiesOnly yes` - Only use specified keys
- `ServerAliveInterval 600` - Keep connection alive
- `ForwardAgent no` - Disabled for security
- Includes `~/.ssh/config.d/*` for additional configs

---

## Development Notes

### Multi-Architecture Support

The configuration handles both Apple Silicon and Intel Macs:
- Architecture-specific directories: `.pyenv.arm64`, `.pyenv.x86_64`
- Homebrew path: `/opt/homebrew/bin` for arm64, `/usr/local/bin` for x86_64

### Claude Code Integration

When running under Claude Code (CLAUDECODE=1):
- Uses minimal plugin set (`zsh_plugins_minimal.txt`)
- Simple prompt without Powerlevel10k
- Faster shell startup

### Extending Configuration

1. **Add shared configs:** Create symlinks in `2-shared/` directories
2. **Add personal configs:** Create symlinks in `3-custom/` directories
3. **Custom packages:** Create `init/packages.sh` (overrides default)
4. **Custom zprofile:** Create `~/.zprofile.custom`

---

## Troubleshooting

### Regenerate Plugin Cache

```bash
rm ~/.zsh_plugins.zsh
# Restart shell
```

### Update Antidote

```bash
cd ~/.antidote && git pull
```

### Reset Brew Path

The zshenv resets PATH to avoid Homebrew path issues:
```bash
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"
```

### Common Issues

- **Slow startup:** Check plugin count, use minimal mode
- **Missing commands:** Run `~/.dotfiles.base/install` to re-link
- **Pyenv issues:** Architecture mismatch, check `PYENV_ROOT`

---

## File Reference

| File | Symlink Target | Purpose |
|------|---------------|---------|
| `zsh/10-zshenv.sh` | `~/.zshenv` | PATH setup |
| `zsh/20-zprofile.sh` | `~/.zprofile` | Environment |
| `zsh/30-zshrc.sh` | `~/.zshrc` | Shell config |
| `zsh/40-zlogin.sh` | `~/.zlogin` | Login script |
| `zsh/50-zlogout.sh` | `~/.zlogout` | Logout script |
| `vim/vimrc` | `~/.vimrc` | Vim config |
| `vim/ideavimrc` | `~/.ideavimrc` | IdeaVim config |
| `ssh/config` | `~/.ssh/config` | SSH config |
| `multitail/multitailrc` | `~/.multitailrc` | Log colors |
| `bin/` | `~/.bin.base` | Custom scripts |
