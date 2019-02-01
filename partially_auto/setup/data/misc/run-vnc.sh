#!/bin/bash
if [ $(id -u) != 0 ]; then
   echo "Please run this script as root or with sudo."
   exit 1
fi

x11vnc -shared -display :0 -auth /var/run/lightdm/root/:0 -forever -passwd IloveEMC &
