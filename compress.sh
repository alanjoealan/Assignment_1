#!/usr/bin/env sh

# Checks if directory is provided
if [ -z "$1" ]; then
    echo "Please provide <directory-to-compress>"
    exit 1
fi

SOURCE_DIR="$1"
ARCHIVE_NAME="$(basename "$SOURCE_DIR").pax.Z"

# Check if the directory actually exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Check if archive already exists to prevent overwriting
if [ -e "$ARCHIVE_NAME" ]; then
    echo "Error: Archive '$ARCHIVE_NAME' already exists. Please remove or rename it before running the script."
    exit 1
fi

# Compress using pax
if ! pax -w "$SOURCE_DIR" | compress -c > "$ARCHIVE_NAME"; then
    echo "Error: Compression failed."
    exit 1
fi

# Confirm success
echo "Directory '$SOURCE_DIR' compressed to '$ARCHIVE_NAME' in current location."
