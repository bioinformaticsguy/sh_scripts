#!/bin/bash

# Define the directory containing the downloaded files
DOWNLOAD_DIR="/data/humangen_kircherlab/hassan/bioscientia"

# Define the extensions to check
EXTENSIONS=("bam" "pbi")

# Define output files
MD5_FILE="$DOWNLOAD_DIR/md5sums.txt"
MD5_CHECK_RESULT="$DOWNLOAD_DIR/md5_check_result.txt"

# Number of parallel processes (adjust based on available CPU cores)
CPU_CORES=$(nproc)  # Automatically detect number of CPU cores
PARALLEL_JOBS=$((CPU_CORES / 2))  # Use half of the available cores for optimal performance

# Generate MD5 checksums in parallel
echo "Generating MD5 checksums using $PARALLEL_JOBS parallel jobs..."
find "$DOWNLOAD_DIR" -type f \( -name "*.${EXTENSIONS[0]}" -o -name "*.${EXTENSIONS[1]}" \) | parallel -j "$PARALLEL_JOBS" md5sum > "$MD5_FILE"

echo "MD5 checksums saved in $MD5_FILE."

# Compare with the original checksum file if it exists
if [[ -f "$DOWNLOAD_DIR/uksh.md5sums.txt" ]]; then
    echo "Comparing checksums with the reference file..."
    cd "$DOWNLOAD_DIR" || exit
    md5sum -c uksh.md5sums.txt > "$MD5_CHECK_RESULT" 2>&1

    echo "MD5 checksum comparison completed. Results saved in $MD5_CHECK_RESULT."
    echo "Check for mismatches using: cat $MD5_CHECK_RESULT | grep -v ': OK'"
else
    echo "No reference checksum file (uksh.md5sums.txt) found!"
fi
