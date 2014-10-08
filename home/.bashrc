# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
. ~/.config/shell/exports
. ~/.config/shell/functions
. ~/.config/shell/aliases

shopt -s histappend

complete -cf sudo
complete -cf man
complete -cf p4
complete -cf git

if [ -f /etc/bash_completion ]
then
  . /etc/bash_completion
fi

export PS1='[\u@\h \W]\$ '
