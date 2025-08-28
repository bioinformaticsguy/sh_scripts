#!/bin/bash

# Define the directory where the files are located
source_dir="/data/humangen_kircherlab/hassan/pipline/PacBio/smrtcells/ready"

# Define the mapping for old names to new names
declare -A rename_map
rename_map=(
  ["S001_X29-24_WGS-Rv-0150.hifi_reads.bam"]="m00001_123456_654321.hifi_reads.bam"
  ["S002_X30-24_WGS-Rv-0150.hifi_reads.bam"]="m00002_234567_765432.hifi_reads.bam"
  ["S005_X32-24_WGS-Rv-0150.hifi_reads.bam"]="m00005_345678_876543.hifi_reads.bam"
  ["S006_X33-24_WGS-Rv-0150.hifi_reads.bam"]="m00006_456789_987654.hifi_reads.bam"
  ["S007_X34-24_WGS-Rv-0150.hifi_reads.bam"]="m00007_567890_098765.hifi_reads.bam"
)

# Loop through and rename files in the source directory
for old_name in "${!rename_map[@]}"; do
  new_name="${rename_map[$old_name]}"
  if [[ -f "$source_dir/$old_name" ]]; then
    mv "$source_dir/$old_name" "$source_dir/$new_name"
    echo "Renamed $source_dir/$old_name to $source_dir/$new_name"
  else
    echo "File $source_dir/$old_name not found, skipping."
  fi
done