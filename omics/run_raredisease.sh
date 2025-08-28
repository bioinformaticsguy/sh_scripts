#!/bin/bash

#Load Modules
module load singularity
module load nextflow

# Define variables
OUTDIR="/data/humangen_kircherlab/hassan/rare_disease_outputs/007_test-run/"
WORKDIR="/work/hassan/raredis/"
CMD="nextflow run nf-core/raredisease -revision dev -profile test,uzl_omics --outdir $OUTDIR -work-dir $WORKDIR"

# Create output directory if it doesn't exist
mkdir -p "$OUTDIR"

# Store native command and parameters used
PARAM_FILE="$OUTDIR/command_parameters.txt"
echo "Command: $CMD" > "$PARAM_FILE"
echo "Output Directory: $OUTDIR" >> "$PARAM_FILE"
echo "Work Directory: $WORKDIR" >> "$PARAM_FILE"

echo "Running Nextflow pipeline..."
# Execute Nextflow pipeline
$CMD
