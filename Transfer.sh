#!/usr/bin/env sh

# Ensure both arguments (archive file and destination directory) are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Please provide <archive-file> <destination-directory>"
    exit 1
fi

ARCHIVE_FILE="$1"
DEST_DIR="$2"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Move only the file (not the full path) to the destination directory
mv "$ARCHIVE_FILE" "$DEST_DIR"

# Change to the destination directory
cd "$DEST_DIR" || exit 1

# Check if the archive exists in the destination directory
if [ ! -f "$(basename "$ARCHIVE_FILE")" ]; then
    echo "Error: Archive '$(basename "$ARCHIVE_FILE")' not found in '$DEST_DIR'."
    exit 1
fi

# Decompress the .pax.Z file using uncompress
uncompress "$(basename "$ARCHIVE_FILE")"

# Get the .pax file name (after decompression)
PAX_FILE="${ARCHIVE_FILE%.Z}"

# Check if the .pax file exists
if [ ! -f "$PAX_FILE" ]; then
    echo "Error: '$PAX_FILE' not found after decompression!"
    exit 1
fi

# Extract the .pax file using tar, since my pax command is not working.
tar --strip-components=2 -xvf "$PAX_FILE"

# Clean up by removing the .pax file after extraction
rm -f "$PAX_FILE"

echo "Directory '$(basename "$ARCHIVE_FILE")' successfully transferred, decompressed, and unpacked to '$DEST_DIR'."
