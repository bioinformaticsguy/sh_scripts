#!/bin/bash

# create_debug_files.sh — small debug FASTQ generator
# Purpose:
#   Produce small paired-end FASTQ test files by extracting the first N reads
#   from each sample's compressed <sample>.R1.fq.gz and <sample>.R2.fq.gz files.
#
# Usage:
#   ./create_debug_files.sh <source_dir> <dest_dir>
#   Example: ./create_debug_files.sh /data/raw_fastqs /data/debug_fastqs
#
# Behavior:
#   - Scans immediate subdirectories of SOURCE_DIR for sample folders.
#   - Looks for files named <sample>.R1.fq.gz and <sample>.R2.fq.gz.
#   - Writes truncated gzip-compressed FASTQs to DEST_DIR/<sample>/ with same names.
#   - Default NUM_READS = 100000 (adjust the variable below to change size).
#
# Requirements:
#   - bash, zcat, head, gzip
#   - Assumes 4 lines per read (standard FASTQ).
#
# Notes:
#   - Does not modify source files.
#   - Exits with code 1 on incorrect usage or missing SOURCE_DIR.


# Check if source and destination directories are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <source_dir> <dest_dir>"
    exit 1
fi

# Source directory from command line argument
SOURCE_DIR="$1"
# Destination directory from command line argument
DEST_DIR="$2"

# Validate source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist"
    exit 1
fi

# Number of reads to extract (adjust as needed)
NUM_READS=100000

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Loop through all sample directories
for sample_dir in "$SOURCE_DIR"/*/; do
    # Get sample name (e.g., GS608)
    sample_name=$(basename "$sample_dir")
    
    # Skip if it's not a sample directory (e.g., skip files like demux-metrics.txt)
    if [[ ! -d "$sample_dir" ]]; then
        continue
    fi
    
    echo "Processing $sample_name..."
    
    # Create sample directory in destination
    mkdir -p "$DEST_DIR/$sample_name"
    
    # Extract first N reads from R1 file
    if [[ -f "$sample_dir/${sample_name}.R1.fq.gz" ]]; then
        zcat "$sample_dir/${sample_name}.R1.fq.gz" | head -n $((NUM_READS * 4)) | gzip > "$DEST_DIR/$sample_name/${sample_name}.R1.fq.gz"
        echo "  Created debug R1 file for $sample_name"
    else
        echo "  Warning: R1 file not found for $sample_name"
    fi
    
    # Extract first N reads from R2 file
    if [[ -f "$sample_dir/${sample_name}.R2.fq.gz" ]]; then
        zcat "$sample_dir/${sample_name}.R2.fq.gz" | head -n $((NUM_READS * 4)) | gzip > "$DEST_DIR/$sample_name/${sample_name}.R2.fq.gz"
        echo "  Created debug R2 file for $sample_name"
    else
        echo "  Warning: R2 file not found for $sample_name"
    fi
done

echo "Debug FASTQ files created in $DEST_DIR"