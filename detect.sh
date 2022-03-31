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
        if [ $path == "${input}/${date}" ]; then
            :
        elif [[ $path =~ $input/${date}_([0-9])+ ]]; then
            :
        elif [ $existed -eq 0 ]; then
            mv $path "$input/$date"
            path="$input/$date"
        else
            # avoid duplicate filename
            suffix=1
            while [[ -e "$input/${date}_${suffix}" ]]; do
                ((suffix++))
            done
            latest_path="$input/${date}_${suffix}"
            mv $path $latest_path
            path=$latest_path
        fi
        dest_path="$formatted/$(basename $path)"
        cat $path | sed -E -e "s/ *${tab}+( *${tab}*)*/${tab}/" > $dest_path
    fi
done