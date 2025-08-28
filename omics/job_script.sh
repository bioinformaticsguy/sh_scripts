#!/bin/bash
#SBATCH --job-name=md5sum_check      # Job name
#SBATCH --output=md5sum_output.txt   # Standard output log
#SBATCH --error=md5sum_error.txt     # Error log
#SBATCH --cpus-per-task=1           # Number of CPU cores
#SBATCH --mem=10G                    # Memory allocation
#SBATCH --time=01:00:00              # Time limit (HH:MM:SS)
#SBATCH --partition=longterm         # Partition (change if needed)
#SBATCH --chdir=/data/humangen_kircherlab/hassan/scripts  # Working directory

# Load necessary modules (if needed)
module load parallel  # Load GNU Parallel (if available)

# Run the MD5 checksum script
./md5sum_parallel.sh
