#!/bin/sh
# Undo what ./install set up. Installed packages (brew/apt) are left alone.
# Usage: ./teardown.sh [--asdf]   (--asdf also deletes asdf and every installed tool version)

set -e

REMOVE_ASDF=no
[ "$1" = "--asdf" ] && REMOVE_ASDF=yes

echo "This removes the dotfiles links, oh-my-zsh, tmux plugins and the git include line."
[ "$REMOVE_ASDF" = yes ] && echo "It also deletes ~/.asdf and ~/.local/bin/asdf (every installed tool version)."
printf "Continue? [y/N] "
read -r answer
case "$answer" in
  y | Y | yes | Yes) ;;
  *) echo "Aborted."; exit 1 ;;
esac

# Links made by install.conf.yaml. Only symlinks are removed, never real files.
for link in \
  "$HOME/.zshrc" \
  "$HOME/.p10k.zsh" \
  "$HOME/.tool-versions" \
  "$HOME/.tmux.conf" \
  "$HOME/.config/nvim" \
  "$HOME/.config/lazygit" \
  "$HOME/.config/karabiner/karabiner.json" \
  "$HOME/.config/alacritty/alacritty.toml"
do
  if [ -L "$link" ]; then rm "$link"; fi
done

# Things the shell steps installed
rm -rf "$HOME/.oh-my-zsh"
rm -f "$HOME/.zshrc.pre-oh-my-zsh"
rm -rf "$HOME/.tmux"

# The include line in ~/.gitconfig (name and email stay)
git config --global --fixed-value --unset-all include.path '~/dotfiles/.gitconfig' || true

# Only if it's empty, so your own scripts are kept
rmdir "$HOME/Scripts" 2>/dev/null || true

if [ "$REMOVE_ASDF" = yes ]; then
  rm -rf "$HOME/.asdf"
  rm -f "$HOME/.local/bin/asdf"
fi

echo "Done."
