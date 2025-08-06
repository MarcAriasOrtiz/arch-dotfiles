#!/bin/bash

## Set GTK themes

THEME='Nordic-darker'
ICONS='Nordic-Darker'
# FONT=
# CURSOR=

SCHEMA='gsettings set org.gnome.desktop.interface'

apply_themes(){
    $SCHEMA gtk-theme "$THEME"
    $SCHEMA icon-theme "$ICONS"
}

apply_themes