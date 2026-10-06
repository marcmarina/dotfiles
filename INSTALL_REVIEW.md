# Install setup review

Review of `install`, `install.conf.yaml`, `Brewfile`, `asdf/setup_asdf.sh`, `teardown.sh` and related config, checked against the live state of this Mac (2026-10-07).

## TL;DR

On a fresh Mac, `./install` today would:

1. ~~**Delete your git identity.** It overwrites `~/.gitconfig`, and `[user]` isn't stored anywhere in the repo.~~ ✅ Fixed (#1)
2. ~~**Probably replace your `.zshrc` symlink** with the oh-my-zsh template.~~ ✅ Fixed (#2)
3. **Fail on any second run**, because the `git clone` steps aren't idempotent.
4. **Not install any software.** Homebrew, the `Brewfile`, asdf plugins and `asdf install` are all manual steps that aren't documented.

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

### 3. Shell steps aren't idempotent
A second run fails at the first `git clone` because the directory already exists. The oh-my-zsh installer also exits non-zero if `~/.oh-my-zsh` exists. dotbot reports the run as failed and you can't tell whether anything was skipped.

**Fix:** guard each step:
```yaml
- [test -d ~/.oh-my-zsh || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc, Installing oh-my-zsh]
- [test -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting]
# …same pattern for autosuggestions, powerlevel10k, tpm
```
Alternative: move the zsh plugins and tpm into git submodules (like `dotbot`), or use a plugin manager such as antidote or zinit.

---

## 🟠 Missing steps / ordering

### 4. No software gets installed
`install.conf.yaml` doesn't install Homebrew, run `brew bundle`, run `asdf/setup_asdf.sh` or run `asdf install`. On a fresh machine the shell config references `nvim`, `fzf`, `fd`, `zoxide`, `lazygit` and `gh`, and none of them would be present.

**Fix:** add a bootstrap section, ideally behind an OS check:
```yaml
- shell:
  - [command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)", Installing Homebrew]
  - [brew bundle --file=Brewfile, Installing Brewfile]
  - [sh asdf/setup_asdf.sh, Adding asdf plugins]
  - [asdf install, Installing tool versions]
  - [~/.tmux/plugins/tpm/bin/install_plugins, Installing tmux plugins]
```
(Homebrew on Apple Silicon also needs `eval "$(/opt/homebrew/bin/brew shellenv)"` in the same shell before `brew bundle`. It's also missing from `.zshrc`, so it currently comes from something like `/etc/paths.d`. Worth making explicit.)

### 5. `gh` credential helper with no `gh`
`.gitconfig` sets `!gh auth git-credential`, but `gh` only gets installed later through asdf. Any HTTPS git operation between those two steps fails, including the oh-my-zsh, powerlevel10k and tpm clones if they hit GitHub auth. Either add `brew "gh"` to the Brewfile and install it early, or add the include line after tools are installed.

### 6. `asdf/setup_asdf.sh` is out of sync with `.tool-versions`
- `.tool-versions` lists **uv**, but no `asdf plugin add uv` exists, so `asdf install` would fail for it.
- argocd, bun and golang plugins are installed locally but aren't in the script or `.tool-versions`. Either add them or remove them.
- The script has no shebang and no `set -e`, and `asdf plugin add` exits non-zero when the plugin already exists. Make it tolerant: `asdf plugin add X || true`, or loop over `cut -d' ' -f1 .tool-versions`.

### 7. tmux plugins are never installed
tpm is cloned, but the plugins need `prefix + I` or `~/.tmux/plugins/tpm/bin/install_plugins`.

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

### 11. Duplicated tooling: brew vs. asdf
- **asdf** is in the Brewfile and also at `~/.local/bin/asdf` (v0.20.2, which is the one being used). Keep one of them.
- **node** (brew) vs. **nodejs** (asdf), and **k9s** (brew) vs. **k9s** (asdf). The one that wins depends on PATH order, so pick one per tool.
- **iterm2**, **alacritty** and Hyper: three terminals. Remove the ones you don't use.

### 12. `lazygit/` folder
- `config.yml` is empty (0 bytes).
- `temp_lazygit.tar.gz` is a 6.4 MB committed release tarball (probably left over from an Ubuntu install). It's linked into `~/.config/lazygit` and adds about half of the 12.7 MB repo size. Delete it, add `*.tar.gz` to the ignore list, and optionally purge it from history with `git filter-repo`.

---

## 🟡 Brewfile hygiene

The Brewfile looks like a raw `brew bundle dump`:
- **`openssl@1.1`** has been disabled/removed in Homebrew, so `brew bundle` will error on it.
- **`authy`**: the Authy desktop app was discontinued (2024). Remove it.
- **`python@3.11`**: old, and you already manage Python tooling with `uv`.
- Library formulae such as `freetype`, `cairo`, `gnutls`, `guile`, `harfbuzz`, `libomp`, `libtiff`, `little-cms2`, `luv`, `newt` and `openldap` were probably pulled in as dependencies or for one-off builds. Brew installs real dependencies automatically, so trim them unless you need them directly.
- `tap "atlassian/acli"` is tapped, but no `acli` formula is listed.
- `npm "@findmypast/..."` packages are private or work-specific. On a personal machine without registry auth, `brew bundle` will fail on them. Move them to a separate `Brewfile.work`, or install them conditionally.
- Missing tools your config relies on: `git` (newer than Apple's), `gh` (see #5), and possibly `neovim`/`lazygit` if you drop asdf for them.

Use `brew bundle check --verbose` and `brew bundle cleanup` to keep the file in sync with the machine.

---

## 🟡 `.zshrc` issues
- `alias vimconf="nvim ~/.config/nvim/init.vim"`: the file is `init.lua`.
- The `ubuntu` oh-my-zsh plugin is loaded on macOS. Make it conditional, or drop it.
- `export PATH=$PATH:$HOME/.local/bin:...` *appends* user bins, so system binaries win over `~/.local/bin`. Prepending is usually what you want.
- The VS Code PATH is hardcoded. Use VS Code's “Install 'code' command in PATH” instead, or guard it with `[[ -d ... ]]`.
- No Homebrew `shellenv` (see #4).
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
- **macOS defaults:** a `macos/defaults.sh` (key repeat, Finder, Dock, screenshots dir) is one of the most useful things to have before a wipe.
- **Secrets / SSH / GPG:** you have `gnupg` installed, but no GPG/SSH setup is documented.
- **`[http] version = HTTP/1.1`** in `.gitconfig` is a global workaround (usually for large pushes or a flaky proxy). Leave a comment explaining why, or remove it.
- **Test the bootstrap** in a throwaway macOS user account, or in a Tart/UTM VM, before relying on it for a wipe.

---

## Suggested order of work
1. ~~Fix #1 (gitconfig identity) and #2 (`--keep-zshrc`). These two can lose data.~~ ✅
2. Make the shell steps idempotent (#3).
3. Add the brew → asdf → tpm bootstrap (#4–#7) and clean up the Brewfile so `brew bundle` succeeds.
4. Remove dead or duplicate things (#10–#12, the stale Brewfile entries).
5. Fix the `.zshrc` and `teardown.sh` issues, then write the README.
6. Do a dry run in a fresh user account.
