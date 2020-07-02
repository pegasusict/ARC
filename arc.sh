#!/bin/bash
####################################################################################################
## Pegasus' Linux Administration Tools                                   Audio Repository Cleaner ##
## Version 0.0.2 DEV, Build 2020-07-01                          https://github.com/pegasusict/arc ##
## Copyright 2020, Mattijs Snepvangers - Pegasus ICT Dienstverlening                 Licence: MIT ##
####################################################################################################
declare -gr ThisProg=${0##*/}

# bash strict mode
set -euo pipefail
IFS=$'\n\t'
declare -gr LOG=info
declare -gr dirs="/media/pegasus/PegsMusic*"
declare -igr COUNTDOWN=30;
declare -igr INTERVAL=1

die() { echo $@ >&2; exit 2; }
version() { help | less -n+2 | head -1 }
help() { grep "^##" "$0" | sed -e "s/^...//" -e "s/\$ThisProg/$ThisProg/g"; exit 0 }

function init() {
    clear; echo "Starting..."
    sleep 1s;
    tput init
    echo -e "diskspace at beginning:\n"; spaceCheck
}
#function countProgress() { echo $COUNT; COUNT=$(( $COUNT + 1 )); }

function cursorUp() { tput cuu $1 ;}
function clearLine() { tput el; }
function spaceCheck() { df -h "$1" }

function rmFile() { rm -f ${1}; }
function removeGarbage() {
  echo -e "Purging non-audio files...\n"
  local -a PATHS=$#
  for i in 0 1 2; do
    [ -d "/media/pegasus/PegsMusic${i}" ] && \
    find /media/pegasus/PegsMusic${i} \( -iname _____padding_file_\* -o -iname \*.bak -o -iname \*.jpg -o -iname \*.gif -o -iname \*.bmp -o -iname \*.db -o -iname \*.m3u -o -iname \*.pls -o -iname \*.xspf -o -iname \*.nfo \) -type f -delete &
    [ -d "/media/pegasus/PegsMusic${i}" ] && find /media/pegasus/PegsMusic${i} -iname .mediaart\* -print0 | xargs -0 -I {} /bin/rm -rf "{}"
  done
  wait
}
function removeDups() {
  echo -e "Purging duplicate audio files...\n"
  fdupes -rNdI /media/pegasus/PegsMusic*

  for j in {1..20..1}; do
    for i in 0 1 2; do
      [ -d "/media/pegasus/PegsMusic${i}" ] && \
      find /media/pegasus/PegsMusic${i} \( -iname \*\(${j}\).au -o -iname \*\(${j}\).fla -o -iname \*\(${j}\).flac -o -iname \*\(${j}\).mp2 -o -iname \*\(${j}\).mp3 -o -iname \*\(${j}\).mp4 -o -iname \*\(${j}\).wav -o -iname \*\(${j}\).wma \) -type f -delete &
    done
  done
  wait
}
function purgeEmpty() {
  echo -e "purging empty files & directories...\n"
  for i in 0 1 2; do
    [ -d "/media/pegasus/PegsMusic${i}" ] && find /media/pegasus/PegsMusic${i} * -empty -delete &
  done
  wait
}
function removeStuff() {
  SECS=${COUNTDOWN}
  clear
  echo -e "Current available space:\n"
  spaceCheck
  removeDups
  while [ $SECS -gt 0 ]; do
    cursorUp 1
    clearLine
    echo "running again in $SECS seconds"
    sleep ${INTERVAL}s
    SECS=$(( $SECS - $INTERVAL ))
  done
  cursorUp 3
  removeStuff
}
#function findStuff(){ find * | grep -i "${1}"; }
######################################################
init
removeGarbage
purgeEmpty
removeStuff
