#!/bin/sh

which git > /dev/null
if [ "$?" = "1" ]; then
  echo "ERROR: Git is not installed or is not on the system path!"
  exit 1
fi

DOTS_SHELL_ALIAS=${1:-"dots"}
DOTS_GIT_DIR=${2:-"$HOME/.dotfiles"}

if [ -z "$SHELL" ]; then
  echo "ERROR: Type of the default shell cannot be determined, exiting."
  exit 1
fi

# construct path to shell rc file
SHELL_TYPE="$(echo $SHELL | awk -F '/' '{print $NF}')"
RCFILE="$HOME/"".$SHELL_TYPE""rc"

# append alias to rc file if necessary
ALIASCMD="alias $DOTS_SHELL_ALIAS=\"git --git-dir=$DOTS_GIT_DIR --work-tree=$HOME\""
grep -Fq "$ALIASCMD" $RCFILE
if [ "$?" = "1" ]; then
  # check for alias collision
  grep -Fq "alias $DOTS_SHELL_ALIAS" $RCFILE
  if [ "$?" = "0" ]; then
    echo "ERROR: A different alias named '$DOTS_SHELL_ALIAS' already exists!"
    exit 1
  fi

  echo "$ALIASCMD" >> $RCFILE
  echo "* added alias '$DOTS_SHELL_ALIAS' to $RCFILE"
  # add alias to current shell
  eval $ALIASCMD
fi

# validate git repo path
if [ -d "$DOTS_GIT_DIR" -a ! -f "$DOTS_GIT_DIR/config" ]; then
  echo "ERROR: The directory at '$DOTS_GIT_DIR' already exists, but is not a git repository!"
  exit 1
fi

# create git repo if necessary
if [ ! -d "$DOTS_GIT_DIR" ]; then
  echo "* init git repo: "$DOTS_GIT_DIR
  git init --bare $DOTS_GIT_DIR
fi

# verify git config for the repo
CFGCMD="git --git-dir=$DOTS_GIT_DIR config --bool status.showUntrackedFiles"
SHOW_UNTRACKED="$($CFGCMD)"
if [ -z "$SHOW_UNTRACKED" -o "$SHOW_UNTRACKED" = "true" ]; then
  echo "* set status.showUntrackedFiles to false for repo at '$DOTS_GIT_DIR'"
  eval "$CFGCMD no"
fi

