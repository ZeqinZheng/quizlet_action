#!/bin/bash 

[[ -d "input" ]] || mkdir input

for path in $(git status -uall | grep --color='never' input/ | awk '{ print $1 }' | tr -d '[:blank:]'); do
    if [ -r $path ]; then
        date=$(ls -lD %F $path | awk '{ print $6 }' )
        existed=$(ls -l input | grep $date | wc -l | awk '{ print $1 }')
        if [ $existed -eq 1 ]; then
            mv $path input/$date
        else
            existed=$((existed+1))
            mv $path input/$date_$existed
        fi
    fi
done