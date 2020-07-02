#!/bin/sh
## $PROG 1.0 - Print logs [2017-10-01]
## Compatible with bash and dash/POSIX
## 
## Usage: $PROG [OPTION...] [COMMAND]...
## Options:
##   -i, --log-info         Set log level to info (default)
##   -q, --log-quiet        Set log level to quiet
##   -l, --log MESSAGE      Log a message
## Commands:
##   -h, --help             Displays this help and exists
##   -v, --version          Displays output version and exists
## Examples:
##   $PROG 
##   $PROG 
PROG=${0##*/}
LOG=info
die() { echo $@ >&2; exit 2; }

log_info() {
  LOG=info
}
log_quiet() {
  LOG=quiet
}
log() {
  [ $LOG = info ] && echo "$1"; return 1 ## number of args used
}
help() {
  grep "^##" "$0" | sed -e "s/^...//" -e "s/\$PROG/$PROG/g"; exit 0
}
version() {
  help |  head -1
}

[ $# = 0 ] && help
while [ $# -gt 0 ]; do
  CMD=$(grep -m 1 -Po "^## *$1, --\K[^= ]*|^##.* --\K${1#--}(?:[= ])" $PROG | sed -e "s/-/_/g")
  if [ -z "$CMD" ]; then echo "ERROR: Command '$1' not supported"; exit 1; fi
  shift; eval "$CMD" $@ || shift $? 2> /dev/null
done
