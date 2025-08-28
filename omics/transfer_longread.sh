#!/bin/bash
src="/data/humangen_kircherlab/Users/hassan/bioscientia"
dest="/data/humangen_sfb1665_seqdata/long_read/raw"

# find all files starting with S###
find "$src" -type f -name "S[0-9][0-9][0-9]*" | while read file; do
    # extract sample ID (S001, S002, etc.)
    sample=$(basename "$file" | cut -d_ -f1)

    # create target directory if it doesn't exist
    mkdir -p "$dest/$sample"

    # copy with progress (rsync, resumable & efficient)
    rsync -ah --info=progress2 "$file" "$dest/$sample/"
done
