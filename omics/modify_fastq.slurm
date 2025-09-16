#!/bin/bash

#SBATCH --partition=longterm
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH --mem=64GB
#SBATCH --time=7-00:00:00
#SBATCH --tmp=100G
#SBATCH --job-name=modify_fastq
#SBATCH --output=logs/modify_fastq_%j_%u_%N.out
#SBATCH --error=logs/modify_fastq_%j_%u_%N.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alihassan1697@gmail.com

# Usage: sbatch modify_fastq.slurm R1
#        sbatch modify_fastq.slurm R2

INPUT_DIR="/data/humangen_kircherlab/Users/hassan/novogene/01.RawData"
OUTPUT_DIR="/data/humangen_kircherlab/Users/hassan/data/temp/small_test_files/short_mod"

if [[ "$1" != "R1" && "$1" != "R2" ]]; then
    echo "Usage: sbatch combine_fastq.slurm [R1|R2]"
    exit 1
fi

READ_TYPE="$1"
if [[ "$READ_TYPE" == "R1" ]]; then
    SUFFIX="_1.fq.gz"
else
    SUFFIX="_2.fq.gz"
fi

mkdir -p "$OUTPUT_DIR"
OUTPUT_SUBDIR="$OUTPUT_DIR/$READ_TYPE"
mkdir -p "$OUTPUT_SUBDIR"

FILES=$(find "$INPUT_DIR" -type f -name "*${SUFFIX}")
echo "${READ_TYPE} files to be Modified:"
echo "$FILES"

TOTAL_FILES=$(echo "$FILES" | wc -w)
CURRENT_FILE=0
MAX_JOBS=32  # Number of parallel jobs (adjust based on your needs)
job_count=0

echo "Total files to process: $TOTAL_FILES"
echo "Starting parallel processing with max $MAX_JOBS jobs..."

for file in $FILES; do
    ((CURRENT_FILE++))
    filename=$(basename "$file")
    
    echo "[$CURRENT_FILE/$TOTAL_FILES] Starting: $filename"
    
    # Run in background
    (
        if [[ "$READ_TYPE" == "R1" ]]; then
            zcat "$file" | awk 'BEGIN{ OFS="\t"; count=0}{ if (count == 0) { split($2,a,":"); split(a[4],b,"+"); print $1 }; if (count == 1) { print $1""b[1] } if (count == 2) print; if (count == 3) { print $1"IIIIIIIIII"; } count+=1; if (count > 3) count = 0;}' | gzip -c > "$OUTPUT_SUBDIR/mod_${filename}"
        else
            zcat "$file" | awk 'BEGIN{ OFS="\t"; count=0}{ if (count == 0) { split($2,a,":"); split(a[4],b,"+"); print $1 }; if (count == 1) { print $1""b[2] } if (count == 2) print; if (count == 3) { print $1"IIIIIIIIII"; } count+=1; if (count > 3) count = 0;}' | gzip -c > "$OUTPUT_SUBDIR/mod_${filename}"
        fi
        echo "✓ Completed: $filename"
    ) &
    
    # Control number of parallel jobs
    ((job_count++))
    if [[ $job_count -ge $MAX_JOBS ]]; then
        wait  # Wait for all background jobs to finish
        job_count=0
    fi
done

# Wait for any remaining background jobs
wait
echo "All $TOTAL_FILES files processed successfully!"