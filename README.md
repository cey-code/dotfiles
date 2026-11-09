# dotfiles

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

```
zsh/        # ~/.zshrc — starship, fzf, zoxide, mise, atuin, aliases
starship/   # Starship prompt
ghostty/    # Ghostty config
zed/        # Zed editor settings (settings, keymap, themes)
agents/     # Shared agent skills + commands + global AGENTS.md (~/.agents; used by Claude Code)
git/        # ~/.gitconfig (delta pager) + global gitignore
lazygit/    # lazygit config + delta split script
mise/       # mise global tools (node lts)
television/ # television config + cable channels
claude/     # Claude Code (~/.claude: explorer subagent + Twilight themes — settings stay local for secrets)
rectangle/  # Rectangle window manager (exported config, not stowed — import via app)
scripts/    # Helper scripts (Biome format hook used by Claude Code settings)
Brewfile    # Homebrew packages and casks (`brew bundle dump` output)
```

## Setup on a new machine

```bash
brew bundle            # install everything in Brewfile
stow zsh starship ghostty zed agents claude git lazygit mise television

# Claude Code shares the same global rules — point its file at the stowed one:
ln -sf ~/.agents/AGENTS.md ~/.claude/CLAUDE.md
```

Rectangle isn't stow-shaped — import `rectangle/RectangleConfig.json` from the app's settings.

## Usage

From the repo root, `stow <name>` symlinks a package into `$HOME`
(e.g. `stow ghostty` → `~/.config/ghostty/*`). Remove with `stow -D <name>`.

After installing/removing brew packages, refresh the Brewfile:

```bash
brew bundle dump --file=Brewfile --force
```

## CLI stack

- **Prompt/shell**: starship, fzf (Ctrl+T files, Alt+C cd), zoxide (`z`), atuin (Ctrl+R history)
- **Runtimes**: mise (reads `.nvmrc` / `mise.toml`), bun
- **Git**: gh, lazygit, git-delta, graphite, worktrunk (`wt`)
- **Modern coreutils**: ripgrep, fd, bat (`cat`), eza (`ls`/`ll`/`lt`)
- **Multiplexer**: zellij
- **Editor**: Zed (`$EDITOR`)
