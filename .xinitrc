#!/usr/bin/env bash

setxkbmap

#if [ ! $(pgrep ssh-agent) ]
#then
#  eval $(ssh-agent)
#fi
#
#if [ ! $(ssh-add -L | grep id_dsa.archivas_weak$) ]
#then
#  ssh-add ~/.ssh/id_dsa.archivas_weak
#fi
#
#if [ ! $(ssh-add -L | grep upcnj.tvg.id_dsa$) ]
#then
#  ssh-add ~/.ssh/upcnj.tvg.id_dsa
#fi
#
if [ ! $(pgrep urxvtd) ]
then
  urxvtd -q -o -f
fi

rstatus &
lstatus &
unclutter -idle 1 -jitter 2 &
xcompmgr &
#krb5-auth-dialog &
#nm-applet &
#gnome-volume-control-applet &

eval $(cat ~/.fehbg) &
xsetroot -cursor_name left_ptr -bg black -fg slategray2
xset m 3 1
xset -dpms

wmname LG3D
exec ratpoison
