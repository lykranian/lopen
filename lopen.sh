#!/usr/bin/env bash

# default browser override to allow for programs
# run with `lopen <url>
# to add to the script, add a function for the program if needed, and add an entry in the case statement


proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${1/$proto/})"
host="$(echo ${url/} | cut -d/ -f1)"
path="$(echo $url | grep / | cut -d/ -f2-)"
ftype="${1##*.}"

input=$1
function fallback {
    firefox --new-tab $input
}
function img {
    feh $input
}
function txt {
    urxvt -e emacs -nw $input
}
function audio {
    mpv --force-window $input
}
function video {
    mpv $input
}

case "$ftype" in # begin filetype switch
    png|jpg|jpeg)
	img
	;;
    txt)
	txt
	;;
    mp3|m4a|flac|ogg)
	audio
	;;
    avi|flv|mp4|mkv|webm|gif)
	video
	;;
    *) case "$host" in # begin host switch
	   youtube.com|www.youtube.com)
	       video
	       ;;
	   *)
	       fallback
	       ;;
       esac
       ;;
esac
