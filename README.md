# ·⦁•⚫● DOTS ●⚫•⦁·

Creates a CLI environment for managing dotfiles using git on Linux. It adds an alias called `dots` to the shell to interact with a git repository located at `$HOME/.dotfiles`.

Run the setup script using wget:

```sh
wget -qO - https://raw.githubusercontent.com/atomgomba/dots/master/setup.sh | sh
```

Or curl:

```sh
curl -s https://raw.githubusercontent.com/atomgomba/dots/master/setup.sh | sh
```

What the setup script does is basically the following:

```sh
git init --bare ~/.dotfiles
git --git-dir=~/.dotfiles config status.showUntrackedFiles no
alias dots=git --git-dir=~/.dotfiles
```

## Example usage

```sh
# push a change in vim settings
dots add ~/.vimrc
dots commit -m "vimrc: show line numbers by default"
dots push
```

