#!/bin/bash

TARGET_DIR="/data/cephfs-1/home/users/alhassa_m/scratch"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory does not exist: $TARGET_DIR"
  exit 1
fi

# Touch files
find "$TARGET_DIR" -type f -exec touch {} \;

# Touch directories too
find "$TARGET_DIR" -type d -exec touch {} \;

echo "All files and directories in $TARGET_DIR have been touched."

