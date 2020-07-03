#!/bin/env bash
################################################################################
## Audio Repository Cleaner            # Version 0.1.0-DEV, Build 2020-07-02  ##
## https://github.com/pegasusict/arc   # © 2020 Mattijs Snepvangers           ##
## Licence: MIT                        # Please keep my name in the credits   ##
################################################################################

declare -gr Command="$0"
declare -gr Script=${0##*/}
declare -gr ScriptTitle="Audio Repository Cleaner"
declare -gr website="https://github.com/pegasusict/arc"
declare -agr ScriptVersion=( 0 1 0 "DEV" 20200702 )
declare -g VERBOSITY=5
# load BashBox framework
source PBFL/bashbox.bash

declare -gr dirs="/media/pegasus/PegsMusic*"
declare -ig ARC_COUNTDOWN_DEFAULT=60;
declare -ig ARC_INTERVAL_DEFAULT=5

# parse ini if present
bb_ini_parse

die() { echo $@ >&2; exit 2; }
version() { help | less -n+2 | head -1 }
help() { grep "^##" "$0" | sed -e "s/^...//" -e "s/\$ThisProg/$ThisProg/g"; exit 0 }

function init() {
    clear; echo "Starting..."
    sleep 1s;
    tput init
    echo -e "diskspace at beginning:\n"; spaceCheck
}
function countDown() { 
  [[ -n $1 ]] && local _countdown=$1 || local _countdown=$ARC_COUNTDOWN_DEFAULT
  [[ -n $2 ]] && local _interval=$2 || local _interval=$ARC_DEFAULT_INTERVAL
  for (( local _count=$_countdown; $_count > 0; _count=$( $_count-$_interval ))); do
    echo $_count
    sleep ${_interval}s
  done
}

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
