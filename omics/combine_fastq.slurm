#!/bin/bash

#SBATCH --partition=longterm
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --mem=64GB
#SBATCH --time=7-00:00:00
#SBATCH --tmp=200G
#SBATCH --job-name=combine_fastq
#SBATCH --output=logs/%j_%u_%N_combine_fastq.out
#SBATCH --error=logs/%j_%u_%N_combine_fastq.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alihassan1697@gmail.com

# Usage: sbatch combine_fastq.slurm R1
#        sbatch combine_fastq.slurm R2

INPUT_DIR="/data/humangen_kircherlab/Users/hassan/data/combined_fq"
OUTPUT_DIR="/data/humangen_kircherlab/Users/hassan/data/combined_fq"

if [[ "$1" != "R1" && "$1" != "R2" ]]; then
    echo "Usage: sbatch combine_fastq.slurm [R1|R2]"
    exit 1
fi

READ_TYPE="$1"
if [[ "$READ_TYPE" == "R1" ]]; then
    SUFFIX="_1.fq.gz"
    OUTFILE="combined_R1.fq.gz"
else
    SUFFIX="_2.fq.gz"
    OUTFILE="combined_R2.fq.gz"
fi

mkdir -p "$OUTPUT_DIR"

FILES=$(find "$INPUT_DIR" -type f -name "*${SUFFIX}")
echo "${READ_TYPE} files to be combined:"
echo "$FILES"

zcat $FILES | pigz -p 32 -c > "$OUTPUT_DIR/$OUTFILE"