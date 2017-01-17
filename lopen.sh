#!/usr/bin/env bash

# default browser override to allow for programs
# run with `lopen <url>`
# add a function and/or add an entry in the case statement


proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${1/$proto/})"
host="$(echo ${url/} | cut -d/ -f1)"
path="$(echo $url | grep / | cut -d/ -f2-)"
ftype="${1##*.}"

input=$1

# begin functions
function fallback {
    firefox --new-tab $input
    #surf $input # suckless' surf
}
function img {
    notify-send "opening image" -t 500
    feh $input
}
function txt {
    # example rxvt-unicode + emacs combo
    curl $input -o /tmp/temp.txt
    urxvt -e emacs -nw /tmp/temp.txt
}
function audio {
    notify-send "opening audio" -t 500
    mpv --force-window $input
}
function video {
    notify-send "opening video" -t 500
    mpv $input
}

# begin rules
case "$ftype" in # begin filetype switch
    png|jpg|jpeg)
	img ;;
    txt)
	txt ;;
    mp3|m4a|flac|ogg)
	audio ;;
    avi|flv|mp4|mkv|webm|gif)
	video ;;
    *) case "$host" in # begin host switch
	   youtube.com|www.youtube.com|youtu.be|m.youtube.com)
	       video ;;
	   i.ufufu.moe|i.givemeyour.pw)
	       img ;;
	   *)
	       fallback ;;
       esac ;;
esac
