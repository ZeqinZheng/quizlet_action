#!/bin/bash -x

[[ -d "input" ]] || mkdir input
[[ -d "formatted" ]] || mkdir formatted

input="input"
formatted="formatted"
tab=$'\t'

for path in $(git status -uall | grep --color='never' $input/ | awk '{ print $1 }' | tr -d '[:blank:]'); do
    if [[ -r $path ]]; then
        date=$(ls -lD %F $path | awk '{ print $6 }' )
        existed=$(ls -l $input | grep $date | wc -l | awk '{ print $1 }')
        if [ $existed -eq 0 ]; then
            mv $path input/$date
            path="$input/$date"
        else
            # ensure no duplicate filename
            while [[ -e "$input/${date}_${existed}" ]]; do
                existed=$((existed+1))
            done
            latest_path="$input/${date}_${existed}"
            mv $path $latest_path
            path=$latest_path
        fi
        dest_path="$formatted/$(basename $path)"
        cat $path | sed -E -e "s/ *${tab}+( *${tab}*)*/${tab}/" > $dest_path
    fi
done