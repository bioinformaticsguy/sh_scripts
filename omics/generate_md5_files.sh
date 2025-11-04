#!/bin/bash
# ...existing code...

# Usage: ./generate_md5_files.sh <input_md5sums.txt> [output_dir]
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_md5sums.txt> [output_dir]"
    exit 1
fi

input_file="$1"
output_dir="${2:-}"   # optional: if set, write all .md5 files under this directory

# if no output_dir given, default to the directory containing the input file
if [ -z "$output_dir" ]; then
    if [ "$input_file" = "-" ]; then
        output_dir="."
    else
        output_dir="$(dirname "$input_file")"
    fi
fi

# allow reading from stdin with '-'
if [ "$input_file" = "-" ]; then
    input_stream="/dev/stdin"
elif [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file" >&2
    exit 2
else
    input_stream="$input_file"
fi

while IFS= read -r line || [ -n "$line" ]; do
    # skip empty lines
    [ -z "${line//[[:space:]]/}" ] && continue

    # extract checksum (first token) and filepath (the rest)
    checksum=$(awk '{print $1; exit}' <<<"$line")
    filepath=$(awk '{$1=""; sub(/^ /,""); print}' <<<"$line")

    # remove leading './' if present
    clean_path="${filepath#./}"

    # derive relative .md5 filename from .bam name
    md5_rel="${clean_path%.bam}.md5"

    # place md5 files under the determined output directory, preserving subdirs
    target="$output_dir/$md5_rel"

    # ensure target directory exists
    mkdir -p "$(dirname "$target")"

    # create the md5 file with checksum and filename
    printf "%s  %s\n" "$checksum" "$clean_path" > "$target"
done < "$input_stream"