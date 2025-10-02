#!/bin/bash

#SBATCH --partition=longterm
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH --mem=16GB
#SBATCH --time=3-00:00:00
#SBATCH --tmp=200G
#SBATCH --output=logs/%j_%u_%N_transfer_data.out
#SBATCH --error=logs/%j_%u_%N_transfer_data.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alihassan1697@gmail.com


# How to use this script:
# sbatch --job-name=<job_name> transfer_data.slurm <source_dir> <target_dir>
# Example:
# sbatch --job-name=transfer_hg002 transfer_data.slurm /data/humangen_kircherlab/Users/hassan/wdl_latest/HiFi-human-WGS-WDL/H
G002/ /data/humangen_sfb1665_seqdata/long_read/processed_data/temp/

source_dir="$1"
target_dir="$2"

# Check if both arguments are provided
if [ -z "$source_dir" ] || [ -z "$target_dir" ]; then
    echo "Error: Both source and target directories must be provided"
    echo "Usage: sbatch transfer_data.slurm <source_dir> <target_dir>"
    exit 1
fi

# command to transfer data with rsync and show detailed progress
rsync -avh --partial --info=progress2 --stats "$source_dir/" "$target_dir/"