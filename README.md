# dotfiles

My shell and editor setup for macOS and Ubuntu, installed with [dotbot](https://github.com/anishathalye/dotbot).

## Install

The repo must live at `~/dotfiles` (the git include and PATH entries point there).

```sh
git clone --recursive git@github.com:marcmarina/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

No SSH key yet? Clone over HTTPS instead: `https://github.com/marcmarina/dotfiles.git`.

`./install` is safe to rerun. It:

1. Links the configs into `~` (`.zshrc`, `.p10k.zsh`, `.tmux.conf`, `.tool-versions`, and `nvim`, `lazygit`, `karabiner` and `alacritty` under `~/.config`).
2. Adds `[include] path = ~/dotfiles/.gitconfig` to `~/.gitconfig`, which keeps your name and email.
3. Installs system packages:
   - **macOS:** Homebrew if missing, then `zsh tmux git fzf fd ripgrep zoxide wget gnupg btop`.
   - **Ubuntu:** the git PPA, then the same tools plus `curl gcc g++ unzip` via apt. It asks for your sudo password.
4. Installs oh-my-zsh, zsh-syntax-highlighting, zsh-autosuggestions, powerlevel10k, tpm and the tmux plugins.
5. Installs asdf to `~/.local/bin`, adds the plugins, and installs every version in `.tool-versions`.

## After installing

These are one-time manual steps:

- **Open a new terminal** so the new `.zshrc` and PATH are loaded.
- **Git identity**, if `~/.gitconfig` doesn't have it yet:
  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```
- **GitHub login:** `gh auth login`. It's needed for private repos and pushing over HTTPS.
- **Ubuntu only: make zsh the login shell.** Run `chsh -s "$(command -v zsh)"` and enter your password, then log out and back in.
- **Font:** install a Nerd Font (e.g. MesloLGS NF) and select it in your terminal, or the prompt icons won't render. In iTerm2, `p10k configure` can install it for you.
- **macOS only:** open Karabiner-Elements and grant the permissions it asks for. Karabiner itself and the other apps (Alacritty, VS Code) are installed by hand.

## Updating

- **Configs:** `git pull`. The links already point into the repo.
- **Tool versions:** edit `.tool-versions`, then run `asdf install` from `~`.
- **New plugin or link:** add it to `asdf/setup_asdf.sh` or `install.conf.yaml`, then rerun `./install`.

## Uninstall

```sh
./teardown.sh          # links, oh-my-zsh, tmux plugins, git include line
./teardown.sh --asdf   # also deletes asdf and every installed tool version
```

It asks before deleting anything. It only removes links that are still symlinks, and it leaves brew/apt packages alone.

## Layout

| Path | What |
|---|---|
| `install`, `install.conf.yaml` | dotbot entry point and config |
| `macos/`, `ubuntu/` | system package installers |
| `asdf/setup_asdf.sh` | asdf binary, plugins and tool versions |
| `.gitconfig` | shared git settings, included from `~/.gitconfig` |
| `scripts/` | on PATH; `update` (apt upgrade), `git-backup` |
| `teardown.sh` | undoes `./install` |
