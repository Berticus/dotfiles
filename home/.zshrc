# Check for an interactive session
# I should really color this...
[ -z "$PS1" ] && return
#
. ~/.config/shell/exports
. ~/.config/shell/functions
. ~/.config/shell/aliases

function precmd() {
  _git=$(git branch 2>/dev/null | sed -e "/^\s/d" -e "s/^\*\s//")
  if [ "$_git" != '' ]; then

    tracked_files="$(git status --porcelain -uno)"
    untracked_files="$(git status --porcelain)"
    stashed_files="$(git stash list)"
    if [ "$tracked_files" != '' ]; then
      # changes
      _color='\e[1;31m'
    elif [ "$untracked_files" != '' ]; then
      # only new files
      _color='\e[0;33m'
    elif [ "$stashed_files" != '' ]; then
      # stashed files
      _color='\e[0;34m'
    else
      # no changes
      _color='\e[0;32m'
    fi

    _git_info=$(echo -e "(%{$_color%}$_git%{\e[0m%})")

    export PS1="[%* %n@%M %c ${_git_info}]%# "
  else
    export PS1="[%* %n@%M %c]%# "
  fi

  unset _git
  unset tracked_files
  unset untracked_files
  unset stashed_files
  unset _color
  unset _git_info
}

HISTSIZE=200000
SAVEHIST=$HISTSIZE
HISTFILE=~/.local/share/zsh_history

#set -o vi

# zsh specific autoloads
autoload -U compinit && compinit
autoload -U colors && colors
autoload -U zmv
autoload -U zcalc
autoload -U zargs

setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
#setopt hist_save_no_dups
setopt nobeep
setopt autocd
setopt autopushd
setopt pushdignoredups
setopt nohup
setopt listpacked
setopt listtypes
setopt extendedglob
setopt completeinword
setopt alwaystoend
setopt correct
setopt correctall
setopt nopromptcr
setopt histverify
setopt interactivecomments
setopt automenu
setopt autolist
setopt chaselinks

bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# for guake
bindkey "\eOF" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "\e[3~" delete-char # Del

if [ "$TERM" = "linux" ]
then
#    automatically get from .Xdefaults
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xdefaults | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}')
    do
        echo -en "$i"
    done

#    manually set
    echo -en "\e]P0000000"
    echo -en "\e]P7aaaaaa"
    clear
fi

if [ -f ~/.dir_colors ]
then
    eval $(dircolors -b ~/.dir_colors)
elif [ -f/etc/DIR_COLORS ]
then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

for keymap in v a; do
    bindkey -$keymap '^r' history-incremental-search-backward
done

eval $(keychain --eval --nogui -Q -q upcnj.tvg.id_dsa id_dsa.achang id_dsa_archivas_weak)

# if in tty1, on login startx
#if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]
#then
#    nohup startx > /dev/null &
#    vlock
#fi

typeset -U path
typeset -U pythonpath
