# Check for an interactive session
# I should really color this...
[ -z "$PS1" ] && return

# change this as XDG variables are changed
. ~/.config/shell/exports
. ~/.config/shell/functions
. ~/.config/shell/aliases

# TODO: consider using git hooks and templates to have git push status to save
# git status calculation every time a command is executed in a git working
# directory.
function precmd() {
  local _git_status
  local _git_branch
  local _git_stashed_files
  local _git_info
  local _git_remote_state
  local _color
  local _color_icon

  _git_status=$(git status --porcelain -b 2> /dev/null)

  if [ $? -eq 0 ]; then

    _git_branch=$(git branch | sed -e "/^\s/d" -e "s/^\*\s//")
    _git_stashed_files=$(git stash list)

    if [ -n "$(echo $_git_status | egrep '^([AD]?U+[AD]?|AA|DD)')" ]; then
      # unmerged
      _color=$_GIT_UNMERGE_COLOR
    elif [ -n "$(echo $_git_status | egrep '^[ MARC][MD]')" ]; then
      # changes to working directory (regardless of index's changes)
      _color=$_GIT_CHANGES_UNSTAGED_COLOR
    elif [ -n "$(echo $_git_status | egrep '^[MARCD][ MD]')" ]; then
      # changes in index (working directory match)
      _color=$_GIT_CHANGES_INDEXED_COLOR
    elif [ -n "$(echo $_git_status | egrep '^\?\?')" ]; then
      # untracked files exist, but nothing else
      _color=$_GIT_UNTRACKED_COLOR
    else
      # no changes
      _color=$_GIT_NO_CHANGES_COLOR
    fi

    if [ "$(echo $_git_status | grep "^## $_git_branch$")" ]; then
      # local only
      _color_icon=$_GIT_LOCAL_COLOR
      _git_remote_state=$_GIT_LOCAL_CHAR
    elif [ "$(echo $_git_status | grep "^## $_git_branch\.\{3\}.* \[ahead [0-9]*\]")" ]; then
      # ahead
      _color_icon=$_GIT_AHEAD_COLOR
      _git_remote_state=$_GIT_AHEAD_CHAR
    elif [ "$(echo $_git_status | grep "^## $_git_branch\.\{3\}.* \[behind [0-9]*\]")" ]; then
      # behind
      _color_icon=$_GIT_BEHIND_COLOR
      _git_remote_state=$_GIT_BEHIND_CHAR
    elif [ "$(echo $_git_status | grep "^## $_git_branch\.\{3\}.* \[ahead [0-9]*, behind [0-9]*\]")" ]; then
      # diverging
      _color_icon=$_GIT_DIVERGE_COLOR
      _git_remote_state=$_GIT_DIVERGE_CHAR
    else
      _color_icon=$_GIT_OK_COLOR
      _git_remote_state=$_GIT_OK_CHAR
    fi

    # TODO: fix zero width characters (and env)
    _git_info=$(echo "%{$_GIT_SEP_COLOR%}$_GIT_SEP%{$_color%}$_git_branch%{\e[0m%} %{$_color_icon%}$_git_remote_state%{\e[0m%}")

    if [ $_git_stashed_files ]; then
      _git_info=$_git_info*
    fi

    export PS1="$(echo '\u251c')%* %n@%M %c${_git_info}$(echo '\u2502')%# "
  else
      export PS1="$(echo '\u251c')%* %n@%M %c$(echo '\u2524')%# "
  fi
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

eval $(keychain --eval --nogui -Q -q upcnj.tvg.id_dsa id_dsa.achang)

# if in tty1, on login startx
#if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]
#then
#    nohup startx > /dev/null &
#    vlock
#fi

typeset -U path
typeset -U pythonpath
