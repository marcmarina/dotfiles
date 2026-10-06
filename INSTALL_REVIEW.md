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

### 8. ✅ Redundant submodule step
**Done:** removed. `./install` already runs `git submodule update --init --recursive dotbot` before dotbot starts, and dotbot is the only submodule.

---

## 🟡 Drift between repo and machine

### 9. Configs in the repo that aren't linked
| Repo path | Live state | Action |
|---|---|---|
| `alacritty/.config/alacritty/alacritty.toml` | Already a symlink into the repo on this Mac, but made by hand; install didn't create it. (The first version of this review wrongly called it a copy.) | ✅ Added to the `link` section |
| `hyperjs/.hyper.js` | not linked, Hyper not installed, unchanged since Nov 2024 | ✅ Deleted (still in git history) |
| `.editorconfig` | not linked | Fine if it's only for this repo. Link to `~/.editorconfig` if you want a global default |

The `alacritty/.config/...` layout is stow-style, while everything else is dotbot-style. Harmless, but could be flattened to `alacritty/alacritty.toml`.

### 10. ✅ Dead step: vim-plug
**Done:** removed the `plug.vim` download (no `.vimrc` exists; you use Neovim) and the matching `rm -rf ~/.vim` in `teardown.sh`. The leftover `~/.vim` on existing machines is harmless; delete it by hand if you like.

### 11. ✅ Duplicated tooling: brew vs. asdf
Resolved by deleting the Brewfile: versioned tools (node, k9s, …) come only from asdf, and asdf itself comes from its release binary on both OSes.

### 12. ✅ `lazygit/` folder
**Done:** deleted `temp_lazygit.tar.gz`, a 6.4 MB lazygit release. It came from lazygit's self-updater, which downloads to `<config dir>/temp_lazygit.tar.gz` and never deletes it; since `~/.config/lazygit` links to the repo, `git-backup` committed it. `config.yml` now sets `update.method: never`, so the updater no longer runs (it would also overwrite asdf's pinned binary); lazygit is updated through `.tool-versions` instead.

Not done, by choice: purging the tarball from git history. It would need a full history rewrite, a force push and re-cloning on every machine, for about 6 MB of savings.

---

## ✅ Brewfile hygiene
The Brewfile was deleted (see #4).

---

## ✅ `.zshrc` issues
All fixed:
- `vimconf` now opens `init.lua` (it pointed at a non-existent `init.vim`).
- The `ubuntu` plugin (apt aliases) only loads where `apt` exists; `zsh-syntax-highlighting` and `zsh-autosuggestions` are still loaded last.
- `~/.local/bin`, `~/Scripts` and `~/dotfiles/scripts` are now *prepended* to PATH, so your own tools win over system ones (asdf shims still come first).
- The VS Code PATH entry is only added if the folder exists.
- Homebrew `shellenv` is set up in `.zshrc` (see #4).
- `kubectl` line indentation matches the rest of `plugins=(...)`.

---

## ✅ `teardown.sh`
**Done:** rewritten to match what `install` creates:
- Asks for confirmation first.
- Removes every link from `install.conf.yaml` (now including Karabiner and Alacritty), but only if it's still a symlink, so real files are never deleted.
- Removes oh-my-zsh, `~/.zshrc.pre-oh-my-zsh` and `~/.tmux` (tpm and plugins).
- Removes only the include line from `~/.gitconfig`; name and email stay.
- Removes `~/Scripts` only if it's empty.
- No longer touches `~/.fzf` (install never created it).
- `~/.asdf` and the asdf binary are only deleted with `./teardown.sh --asdf`.
- `$HOME` is quoted everywhere. brew/apt packages are left alone.

Verified in a throwaway HOME, including a second run.

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
4. ~~Remove dead or duplicate things (#10, #12).~~ ✅ (#8–#10, #12, Hyper config)
5. ~~Fix the `.zshrc` and `teardown.sh` issues~~ ✅, then write the README.
6. Do a dry run in a fresh user account.
