#!/bin/bash

echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
echo "Process ID: $$"


show_help() {
cat << EOF
Usage:
./file_analyzer.sh -d <directory> -k <keyword>
./file_analyzer.sh -f <file> -k <keyword>
./file_analyzer.sh --help

Options:
-d   Directory to search
-f   File to search
-k   Keyword to search
--help  Display help menu
EOF
}


log_error() {
echo "$(date) : $1" | tee -a errors.log
}


search_recursive() {
local dir="$1"
local keyword="$2"

```
for item in "$dir"/*; do
    if [ -d "$item" ]; then
        search_recursive "$item" "$keyword"
    elif [ -f "$item" ]; then
        grep -Hn "$keyword" "$item"
    fi
done
```

}


while getopts ":d:f:k:-:" opt; do
case $opt in
d) directory="$OPTARG" ;;
f) file="$OPTARG" ;;
k) keyword="$OPTARG" ;;
-)
case "${OPTARG}" in
help)
show_help
exit 0
;;
esac ;;
?)
log_error "Invalid option: -$OPTARG"
show_help
exit 1 ;;
esac
done

if [[ -z "$keyword" ]]; then
log_error "Keyword cannot be empty"
exit 1
fi

if ! [[ "$keyword" =~ ^[a-zA-Z0-9_]+$ ]]; then
log_error "Invalid keyword format"
exit 1
fi



if [[ -n "$directory" ]]; then
if [[ ! -d "$directory" ]]; then
log_error "Directory not found: $directory"
exit 1
fi

```
echo "Searching '$keyword' in directory '$directory'"
search_recursive "$directory" "$keyword"
exit 0
```

fi


if [[ -n "$file" ]]; then
if [[ ! -f "$file" ]]; then
log_error "File not found: $file"
exit 1
fi

```
echo "Searching '$keyword' in file '$file'"
while read line
do
    grep "$keyword" <<< "$line"
done < "$file"
exit 0
```

fi


show_help
exit 1

