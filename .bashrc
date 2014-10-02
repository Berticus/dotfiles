# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# Source arc-deploy definitions
if [ -f ~/bin/.bashrc-arcDeployFunctions ]; then
	. ~/bin/.bashrc-arcDeployFunctions
fi
if [ -f ~/bin/.bashrc-vpnFunctions ]; then
	. ~/bin/.bashrc-vpnFunctions
fi

if [ -f ~/bin/.bashrc-arcDevFunctions ]; then
	. ~/bin/.bashrc-arcDevFunctions
fi

if [ -f ~/bin/.bashrc-automationFunctions ]; then
	. ~/bin/.bashrc-automationFunctions
fi

if [ -f ~/bin/.bashrc-adminFunctions ]; then
	. ~/bin/.bashrc-adminFunctions
fi

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

#. ~/bin/adev.sh "godzilla/godzilla_int" 2&> /dev/null
#cd - > /dev/null
