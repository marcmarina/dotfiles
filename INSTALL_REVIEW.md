# Install setup review

Review of `install`, `install.conf.yaml`, `Brewfile`, `asdf/setup_asdf.sh`, `teardown.sh` and related config, checked against the live state of this Mac (2026-10-07).

## TL;DR

On a fresh Mac, `./install` today would:

1. ~~**Delete your git identity.** It overwrites `~/.gitconfig`, and `[user]` isn't stored anywhere in the repo.~~ ✅ Fixed (#1)
2. ~~**Probably replace your `.zshrc` symlink** with the oh-my-zsh template.~~ ✅ Fixed (#2)
3. ~~**Fail on any second run**, because the `git clone` steps aren't idempotent.~~ ✅ Fixed (#3)
4. ~~**Not install any software.** Homebrew, the `Brewfile`, asdf plugins and `asdf install` are all manual steps that aren't documented.~~ ✅ Fixed (#4)

---

## 🔴 Critical

### 1. ✅ `cp .gitconfig-base ~/.gitconfig` wiped `[user]`
Every run of `./install` copied `.gitconfig-base` over `~/.gitconfig`, which erased the name and email (they aren't stored in the repo).

**Done:** `.gitconfig-base` is gone. Its `[credential]` and `[http]` settings moved into the shared `.gitconfig`, and install now only adds an include line to `~/.gitconfig`:
```yaml
- [git config --global include.path '~/dotfiles/.gitconfig', Linking shared git config]
```
`~/.gitconfig` stays machine-specific (include line + name/email); every shared setting lives in the repo's `.gitconfig`. Other machines can optionally remove their now-duplicated `[credential]`/`[http]` sections after pulling.

### 2. ✅ oh-my-zsh installer clobbered the linked `~/.zshrc`
The order is `link` → `shell`. Running `install.sh --unattended` without `--keep-zshrc` moved the linked `~/.zshrc` to `~/.zshrc.pre-oh-my-zsh` and wrote its own template in its place.

**Done:** the installer now runs with `--unattended --keep-zshrc` (`--unattended` already implies `RUNZSH=no CHSH=no`), so the symlink is kept. Verified in a throwaway HOME: without the flag the link became a plain template file; with it, `~/.zshrc` stays linked to the repo.

### 3. ✅ Shell steps weren't idempotent
A second run hit "already exists" errors on the four `git clone` steps and the oh-my-zsh installer. Dotbot still ran every step, but ended with "Some tasks were not executed successfully", which hid any real failure.

**Done:** each of those steps is now guarded with `test -d <folder> || …` and has a description. Verified by running the full `./install` twice against a throwaway HOME: both runs end with "All tasks executed successfully".

Not covered: existing plugins aren't updated on rerun (they never were). If that matters later, consider submodules or a plugin manager (antidote, zinit).

---

## 🟠 Missing steps / ordering

### 4. ✅ No software got installed
`install.conf.yaml` didn't install any packages or tools, so on a fresh machine `nvim`, `fzf`, `fd`, `zoxide`, `lazygit` and `gh` were all missing.

**Done:** install now runs, in order:
1. **System packages** (before oh-my-zsh, which needs `zsh`, `git` and `curl`), picked by `uname`:
   - macOS: `macos/install_dependencies.sh` installs Homebrew if missing, then only the missing ones of `zsh tmux git fzf fd ripgrep zoxide wget gnupg btop`.
   - Ubuntu: `ubuntu/install_dependencies.sh` adds the git PPA and `apt-get install`s `zsh tmux git curl fzf fd-find ripgrep zoxide wget gnupg btop gcc g++ unzip`.
2. **tmux plugins** via tpm's `install_plugins`.
3. **asdf** via `asdf/setup_asdf.sh` (see #6), then `asdf install`.

`.zshrc` now sets up Homebrew's PATH itself (`brew shellenv`, if brew exists) instead of relying on `~/.zprofile`, which isn't in the repo.

The Brewfile (Mac apps, VS Code extensions, work npm packages) was deleted: apps are installed by hand, and VS Code extensions come from Settings Sync.

Verified with the full `./install`, run twice, on macOS (throwaway HOME) and in a fresh Ubuntu 24.04 container; both end with "All tasks executed successfully" and all tools resolve in zsh.

### 5. ✅ `gh` credential helper with no `gh`
Less of a problem than first described: git only asks the credential helper when GitHub requires a login, so the public clones during install aren't affected. `gh` is installed by the asdf step; run `gh auth login` once afterwards for private repos and pushes.

### 6. ✅ `asdf/setup_asdf.sh` was out of sync with `.tool-versions`
**Done:** the script now downloads the asdf binary (pinned `v0.20.2`) to `~/.local/bin` if missing, on macOS and Linux; adds each plugin only if it isn't already added (now including `uv`); and runs `asdf install` from `$HOME`. It also puts `~/.local/bin` on PATH, because the nodejs plugin calls `asdf` itself (this broke the first Ubuntu test).

Still open: argocd, bun and golang plugins are installed on this Mac but aren't in `.tool-versions`. Add them there (and to the script) or remove them.

### 7. ✅ tmux plugins were never installed
**Done:** see #4.

### 8. Redundant submodule step
`./install` already runs `git submodule update --init --recursive dotbot`. The extra `[git submodule update --init --recursive]` shell step does nothing unless you add more submodules, which you might (see #3).

---

## 🟡 Drift between repo and machine

### 9. Configs in the repo that aren't linked
| Repo path | Live state | Action |
|---|---|---|
| `alacritty/.config/alacritty/alacritty.toml` | `~/.config/alacritty` is a **copy**, not a link (identical today) | Add `~/.config/alacritty/alacritty.toml: alacritty/.config/alacritty/alacritty.toml` |
| `hyperjs/.hyper.js` | not linked, Hyper not in Brewfile | Link it + add cask, or delete it |
| `.editorconfig` | not linked | Fine if it's only for this repo. Link to `~/.editorconfig` if you want a global default |

The `alacritty/.config/...` layout is stow-style, while everything else is dotbot-style. Pick one (you have `stow` in the Brewfile and don't use it).

### 10. Dead step: vim-plug
`install.conf.yaml` downloads `plug.vim` into `~/.vim`, but no `.vimrc` exists in the repo and you use Neovim (lazy.nvim via kickstart). Remove that step and the `rm -rf ~/.vim` in `teardown.sh`.

### 11. ✅ Duplicated tooling: brew vs. asdf
Resolved by deleting the Brewfile: versioned tools (node, k9s, …) come only from asdf, and asdf itself comes from its release binary on both OSes.

### 12. `lazygit/` folder
- `config.yml` is empty (0 bytes).
- `temp_lazygit.tar.gz` is a 6.4 MB committed release tarball (probably left over from an Ubuntu install). It's linked into `~/.config/lazygit` and adds about half of the 12.7 MB repo size. Delete it, add `*.tar.gz` to the ignore list, and optionally purge it from history with `git filter-repo`.

---

## ✅ Brewfile hygiene
The Brewfile was deleted (see #4).

---

## 🟡 `.zshrc` issues
- `alias vimconf="nvim ~/.config/nvim/init.vim"`: the file is `init.lua`.
- The `ubuntu` oh-my-zsh plugin is loaded on macOS. Make it conditional, or drop it.
- `export PATH=$PATH:$HOME/.local/bin:...` *appends* user bins, so system binaries win over `~/.local/bin`. Prepending is usually what you want.
- The VS Code PATH is hardcoded. Use VS Code's “Install 'code' command in PATH” instead, or guard it with `[[ -d ... ]]`.
- ~~No Homebrew `shellenv` (see #4).~~ ✅
- Indentation mixes tabs and spaces in `plugins=(...)` (the `kubectl` line).

---

## 🟡 `teardown.sh`
- It doesn't remove things `install` creates: `~/.config/karabiner/karabiner.json`, `~/.gitconfig`, `~/.tmux/plugins` (it removes `~/.tmux`, which is fine), `~/Scripts`.
- It removes things `install` never creates: `~/.fzf`.
- `rm -rf ~/.asdf` deletes **every installed tool version**. That's more than a dotfiles teardown should do. Make it opt-in.
- Quote `"$HOME"`, and consider a confirmation prompt.

---

## 🟡 `scripts/git-backup`
The recent history is all `Backup <date>` commits. This loop runs `git add -A` and pushes every 60s, which means:
- Anything dropped into the repo gets committed and pushed, including secrets, tarballs (see #12) and this review file.
- Commit history is useless for finding *why* something changed.

Suggestions: run it only on specific paths (e.g. `.p10k.zsh`, `karabiner/`, `lazygit/`, which are app-managed files that change on their own), keep a `.gitignore`, or drop it and commit by hand.

---

## 🟢 Nice-to-haves
- **README.md** with a one-line bootstrap (`git clone --recursive … && ./install`) and the manual steps (Karabiner permissions, `gh auth login`, `p10k configure`, font selection).
- **OS split:** `install.conf.yaml` is macOS-only in practice, while `ubuntu/install_dependencies.sh` and `scripts/update` (apt) are Linux-only. `scripts/update` is still on your macOS PATH. Consider `install.conf.macos.yaml` / `install.conf.linux.yaml`, or `if [ "$(uname)" = Darwin ]` guards.
- **Default shell on Ubuntu:** install doesn't make zsh the login shell, so a new Ubuntu machine starts in bash until you run `chsh -s $(which zsh)` once. Could be automated at the end of `ubuntu/install_dependencies.sh`, reusing sudo's cached password from the apt step and skipping when already set:
  `[ "$(getent passwd "$USER" | cut -d: -f7)" = "$(command -v zsh)" ] || sudo chsh -s "$(command -v zsh)" "$USER"`
- **macOS defaults:** a `macos/defaults.sh` (key repeat, Finder, Dock, screenshots dir) is one of the most useful things to have before a wipe.
- **Secrets / SSH / GPG:** you have `gnupg` installed, but no GPG/SSH setup is documented.
- **`[http] version = HTTP/1.1`** in `.gitconfig` is a global workaround (usually for large pushes or a flaky proxy). Leave a comment explaining why, or remove it.
- **Test the bootstrap** in a throwaway macOS user account, or in a Tart/UTM VM, before relying on it for a wipe.

---

## Suggested order of work
1. ~~Fix #1 (gitconfig identity) and #2 (`--keep-zshrc`). These two can lose data.~~ ✅
2. ~~Make the shell steps idempotent (#3).~~ ✅
3. ~~Add the brew → asdf → tpm bootstrap (#4–#7) and clean up the Brewfile so `brew bundle` succeeds.~~ ✅ (Brewfile deleted instead)
4. Remove dead or duplicate things (#10, #12).
5. Fix the `.zshrc` and `teardown.sh` issues, then write the README.
6. Do a dry run in a fresh user account.
