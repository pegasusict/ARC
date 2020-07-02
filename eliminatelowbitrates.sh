#!/bin/bash
# music file pruner
# ls sorts alphabetically, so lowest bitrate comes first conveniently ^^
set -x
#basepath=$(pwd)
#eval index=$(ls -Q -I *.sh)
#for indexkey in "${index[@]}"; do 
#  eval "artists=$(ls -1Q ${basepath}/${indexkey})"
#  for artist in "${artists[@]}"; do
#    eval "albums=$(ls -1Q ${basepath}/${indexkey}/${artist})"
#    for albums in "${albums[@]}"; do
#      eval "tracks=$(ls -1Q ${basepath}/${indexkey}/${artist}/${album})"
    declare -a tracks; eval "tracks=$(ls -Q */*)"
      declare tracklist=(); declare previousfile=''; declare previousbitrate=''
      for track in "${tracks[@]}";do
        part1="${track%[*}["
        part2a="${track##*[}"
        part2="${part2a% *}"
        part3="${part2a#* }"
        if [[ "${part1}${part3}" == "${previousfile}" ]];then 
#          rm "$basepath/$indexkey/$artist/$album${part1}[${previousbitrate} ${part3}";fi
           rm "${part1}${previousbitrate} ${part3}";fi
        previousfile="${part1}${part3}"; previousbitrate=${part2}
      done
#    done
#  done
#done

