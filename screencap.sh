#!/bin/sh

# See http://andytaylor.me/2014/05/21/better-os-x-screenshots-with-shell-scripts/

filename=/Users/cam/Dropbox/Screenshots/Screenshot_`date '+%Y-%m-%d_%H.%M.%S'`.png
screencapture -R150,250,1190,460 $filename
