#!/bin/bash

usage() {
    echo "Usage: $0 -d directory"
    exit 1
}

# Parse command line options
while getopts ":d:" opt; do
    case $opt in
        d)
            directory="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            usage
            ;;
    esac
done

# Check if the directory option is provided
if [ -z "$directory" ]; then
    echo "Error: Directory not provided."
    usage
fi

# Search for .md files in the specified directory and its subdirectories
fdfind --base-directory "$directory" --type f '\.md$' --color=never | while read -r file; do
    full_path=$(realpath "$directory/$file")
    rg -on --column '[#]+[[:space:]]*[^#]+' "$full_path" | while read -r line; do
        IFS=':' read -ra parts <<< $line
        row="${parts[0]}"
        col="${parts[1]}"

        text=""
        for ((i = 2; i < ${#parts[@]}; i++)); do
            text+="${parts[i]}:"
        done
        text="${text%:}"

        lead=""
        pointer=0
        while [ "$pointer" -lt "${#text}" ]; do
            if [ "${text:$pointer:1}" != "#" ] && [ "${text:$pointer:1}" != " " ]; then
                break
            fi
            lead="${lead}${text:$pointer:1}"
            ((pointer++))
        done

        col=$((col + ${#lead}))
        text=${text:${#lead}}
        text="${text//:/<COLON>}"

        echo "$text:$row:$col:$full_path"
    done
done
