#!/bin/sh
transmission-remote -l | grep 100\% | grep Done | awk '{print $1}' | xargs -n 1 -I \% /usr/bin/transmission-remote -t \% -r
