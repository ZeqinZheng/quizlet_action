#!/bin/bash -x
# detect new files and then format them

[[ -d "input" ]] || mkdir input
[[ -d "formatted" ]] || mkdir formatted

input="input"
formatted="formatted"
backup="backup"
tab=$'\t'
todate=$(date +%F)
src_path=( "$input/vocabulary/" "$input/basic_law/" )
backup_path=( "$backup/vocabulary/" "$backup/basic_law/" )
dest_files=( "$formatted/vocabulary" "$formatted/basic_law" )
targets=()
final_name=""

# detect new files
add_targets() {
    local src_path="$1"
    targets+=($(git status -uall | grep --color='never' $src_path | awk '{ print $NF }' | tr -d '[:blank:]'))
}

# rm old files
rm_old_dest_files() {
    local dest_file="$1"
    [[ -f "$dest_file" ]] && rm "$dest_file"
}

# format target files and output to dest_path
# targets, input
format() {
    local path="$1"
    local src_dir="$2"
    local dest_path="$3"
    if [[ -r $target ]]; then
        date=$(ls -lD %F $target | awk '{ print $6 }' )
        existed=$(ls -l $src_dir | grep $date | wc -l | awk '{ print $1 }')
        if [ $path == "${src_dir}${date}" ]; then
            :
        elif [[ $path =~ ${src_dir}${date}_([0-9])+ ]]; then
            :
        elif [ $existed -eq 0 ]; then
            mv $path "${src_dir}${date}"
            path="${src_dir}${date}"
        else
            # avoid duplicate filename
            suffix=1
            while [[ -e "${src_dir}${date}_${suffix}" ]]; do
                ((suffix++))
            done
            latest_path="${src_dir}${date}_${suffix}"
            mv $path $latest_path
            path=$latest_path
        fi
        cat $path | tr '[:upper:]' '[:lower:]' | sed -E -e "s/ *${tab}+( *${tab}*)*/${tab}/" | \
        grep -vE '^$' >> $dest_path
        echo "" >> $dest_path
    fi
}

# copy new files to backup
backup() {
    local src_path="$1"
    local backup_path="$2"
    if [ -e "${backup_path}${todate}" ]; then
        suffix=1
        while [[ -e "${backup_path}${todate}_${suffix}" ]]; do
            ((suffix++))
        done
        backup_path="${backup_path}${todate}_${suffix}"
    else
        backup_path="${backup_path}${todate}"
    fi
    cp $src_path $backup_path
}

commit() {
    git add .
    git commit -m "bot: update vocabulary on $todate"
    git push
}

len=$((${#src_path[@]}-1))
for i in $(seq 0 $len); do
    targets=()
    add_targets "${src_path[$i]}"
    if [ ${#targets[@]} -eq 0 ]; then
        continue
    else
        rm_old_dest_files "${dest_files[$i]}"
        for target in "${targets[@]}"; do
            format "$target" "${src_path[$i]}" "${dest_files[$i]}"
        done
        [[ -r ${dest_files[$i]} ]] && backup "${dest_files[$i]}" "${backup_path[$i]}"
    fi
done

commit