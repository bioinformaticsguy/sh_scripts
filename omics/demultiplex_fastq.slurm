#!/bin/bash
#SBATCH --partition=longterm
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --mem=64GB
#SBATCH --time=7-00:00:00
#SBATCH --job-name=demux
#SBATCH --output=demux_%j.out
#SBATCH --error=demux_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alihassan1697@gmail.com

# Load environment
module load singularity
source ~/.bashrc
conda activate demulti

# Input arguments
BARCODE_FILE=$1     # e.g. barcodes_KIGS24.tsv
DATA_DIR=$2
OUTPUT_DIR=$3
MODE=$4		# optional: "all" (default) or "last"

# Extract sample name from barcode file name (remove prefix/suffix)
BASENAME=$(basename "$BARCODE_FILE")
SAMPLE_NAME=${BASENAME#barcodes_}
SAMPLE_NAME=${SAMPLE_NAME%.tsv}

# Define sample-specific output dir
SAMPLE_OUT="${OUTPUT_DIR}/${SAMPLE_NAME}"
mkdir -p "$SAMPLE_OUT"

# Logging
echo "-----------------------------------"
echo " Barcode file   : $BARCODE_FILE"
echo " Sample name    : $SAMPLE_NAME"
echo " Data directory : $DATA_DIR"
echo " Output root    : $OUTPUT_DIR"
echo " Sample output  : $SAMPLE_OUT"
echo " Mode	      : ${MODE:-all}"
echo "-----------------------------------"


# Collect all R1 files
R1_FILES=$(ls -v "$DATA_DIR"/*_1.fq.gz)


# Decide processing mode
if [[ "$MODE" == "last" ]]; then
    R1_FILES=$(echo "$R1_FILES" | tail -n 1)
fi

# Run demultiplex on all R1/R2 pairs in DATA_DIR

# Run demultiplex
for r1 in $R1_FILES; do
    r2="${r1/_1.fq.gz/_2.fq.gz}"

    echo "Processing pair:"
    echo "  R1 = $r1"
    echo "  R2 = $r2"

    demultiplex demux "$BARCODE_FILE" "$r1" "$r2" -m 2 -d -p "$SAMPLE_OUT"
done
