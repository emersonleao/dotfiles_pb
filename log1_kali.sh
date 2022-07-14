#!/bin/bash

sudo apt-get install bspwm sxhkd ranger scrot xbacklight polybar dmenu
mkdir -p /home/$USER/.config/bspwm && touch /home/$USER/.config/bspwm/bspwmrc
sudo chmod 774 /home/$USER/.config/bspwm/bspwmrc
cat <<EOF > /home/$USER/.config/bspwm/bspwmrc
#! /bin/sh

pgrep -x sxhkd > /dev/null || sxhkd &

bspc monitor -d I II III IV V VI VII VIII IX X

bspc config border_width         1
bspc config window_gap           2
bspc config top_padding          32

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a firefox desktop='^1'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

$HOME/.config/polybar/launch.sh
EOF
mkdir -p /home/$USER/.config/sxhkd/ && touch /home/$USER/.config/sxhkd/sxhkdrc
sudo chmod 774 /home/$USER/.config/sxhkd/sxhkdrc
cat <<EOF > /home/$USER/.config/sxhkd/sxhkdrc
#
# wm independent hotkeys
#

# terminal emulator
super + Return
	x-terminal-emulator	

# program launcher
super + @space
	dmenu_run

# open ranger
super + v
	x-terminal-emulator -e ranger

# open firefox
super + b
	firefox

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#
# bspwm hotkeys
#

# quit/restart bspwm
super + alt + {q,r}
	bspc {quit,wm -r}

# close and kill
super + {_,shift + }w
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local

# swap the current node and the biggest window
super + g
	bspc node -s biggest.window

#
# state/flags
#

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

#
# focus/swap
#

# focus the node in the given direction
super + {_,shift + }{h,j,k,l}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous window in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local.!hidden.window

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#
# preselect
#

# preselect the direction
super + ctrl + {h,j,k,l}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel

# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#
# move/resize
#

# expand a window by moving one of its side outward
super + alt + {h,j,k,l}
	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# contract a window by moving one of its side inward
super + alt + shift + {h,j,k,l}
	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# move a floating window
super + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}

# volume
XF86AudioRaiseVolume
	pactl set-sink-volume 0 +5%
XF86AudioLowerVolume
	pactl set-sink-volume 0 -5%
XF86AudioMute
	pactl set-sink-mute 0 toggle

# brightness
XF86MonBrightnessDown
        xbacklight -dec 10%
XF86MonBrightnessUp
        xbacklight -inc 10%

# Printscreen
Print
        scrot -s $HOME/Pictures/Screenshots/'%d-%m-%Y_%H-%M-%S.png'

# Keyboard layout
XF86Tools
	~/Scripts/keyboard_layout

EOF
mkdir -p /home/$USER/.config/polybar/scripts
wget -O /home/$USER/.config/polybar/config https://raw.githubusercontent.com/emersonleao/dotfiles_pb/main/kali_polybar_config 
wget -O /home/$USER/.config/polybar/launch.sh https://raw.githubusercontent.com/emersonleao/dotfiles_pb/main/polybar/launch.sh
wget -O /home/$USER/.config/polybar/scripts/launch.sh https://raw.githubusercontent.com/emersonleao/dotfiles_pb/main/polybar/scripts/launch.sh
wget -O /home/$USER/.config/polybar/scripts/pavolume.sh https://raw.githubusercontent.com/emersonleao/dotfiles_pb/main/polybar/scripts/pavolume.sh
sudo chmod 774 /home/$USER/.config/polybar/config
sudo chmod 774 /home/$USER/.config/polybar/launch.sh
sudo chmod 774 /home/$USER/.config/polybar/scripts/launch.sh
sudo chmod 774 /home/$USER/.config/polybar/scripts/pavolume.sh
wget -O /home/$USER/.tmux.conf https://raw.githubusercontent.com/emersonleao/dotfiles_pb/main/.tmux.conf
tmux source-file /home/$USER/.tmux.conf
sudo cat << EOF >> /etc/environment
"_JAVA_AWT_WM_NONREPARENTING=1"
EOF
