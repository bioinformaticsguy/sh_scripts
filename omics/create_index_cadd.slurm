#!/bin/bash

#SBATCH --partition=longterm
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH --mem=128GB
#SBATCH --time=7-00:00:00
#SBATCH --tmp=200G
#SBATCH --job-name=create_index_cadd
#SBATCH --output=logs/%j_%u_%N_create_index_cadd.out
#SBATCH --error=logs/%j_%u_%N_create_index_cadd.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alihassan1697@gmail.com


# Load required modules (adjust as needed for your cluster)
module load htslib

# Input and output files
INPUT_FILE="/data/humangen_kircherlab/Users/hassan/run_rare/rare-disease-pipeline/data/grch38/vcfanno/cadd/whole_genome_SNVs.tsv.gz"


# Generate output filename dynamically
BASE_NAME=$(basename "$INPUT_FILE" .tsv.gz)
DIR_NAME=$(dirname "$INPUT_FILE")
OUTPUT_FILE="${DIR_NAME}/${BASE_NAME}_noheader.tsv.gz"


echo "Processing CADD file: $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"

# Remove first two lines, bgzip compress, and create index
echo "Removing first two lines and creating bgzipped file..."
zcat "$INPUT_FILE" | tail -n +3 | bgzip -c > "$OUTPUT_FILE"

echo "Creating tabix index..."
tabix -s 1 -b 2 -e 2 "$OUTPUT_FILE"

echo "Process completed!"
echo "Files created:"
echo "  - $OUTPUT_FILE"
echo "  - ${OUTPUT_FILE}.tbi"

# Verify the output
echo "First few lines of processed file:"
zcat "$OUTPUT_FILE" | head -5


