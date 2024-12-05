#!/bin/bash

# ========================
# Image Resizing Script
# ========================
# This script resizes images from the "before" directory into the "after" directory.
# Requirements:
# - Resize images to two widths: 1800px (@2x suffix) and 900px (no suffix).
# - Convert all output images to .jpg format.
# - Compatible with .jpg, .png, and .psd input files.
#
# Prerequisites:
# - ImageMagick must be installed. Install it using:
#   brew install imagemagick
# ========================

# Configuration
INPUT_DIR="before"
OUTPUT_DIR="after"
LOG_FILE="resize_log.txt"

# Ensure required tools are installed
check_imagemagick_installed() {
    if ! command -v convert &> /dev/null; then
        echo "ImageMagick is not installed. Please run 'brew install imagemagick'." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Create the output directory if it does not exist
prepare_output_dir() {
    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir "$OUTPUT_DIR"
        echo "$(date): Created output directory '$OUTPUT_DIR'." >> "$LOG_FILE"
    fi
}

# Process a single image file
process_image() {
    local input_file="$1"
    local base_name=$(basename "$input_file" | sed -E 's/\.(jpg|png|psd)$//i')
    local output_2x="$OUTPUT_DIR/${base_name}@2x.jpg"
    local output_900="$OUTPUT_DIR/${base_name}.jpg"

    # Resize to 1800px
    magick "$input_file" -resize 1800x "$output_2x" && echo "$(date): Resized to 1800px: $output_2x" >> "$LOG_FILE"

    # Resize to 900px
    magick "$input_file" -resize 900x "$output_900" && echo "$(date): Resized to 900px: $output_900" >> "$LOG_FILE"
}

# Process all images in the input directory
process_images() {
    # Enable nullglob to prevent issues when no files match the pattern
    shopt -s nullglob

    # Gather all matching files
    local files=("$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.png "$INPUT_DIR"/*.psd)

    # Disable nullglob after the file gathering
    shopt -u nullglob

    # Check if files are found
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found in '$INPUT_DIR'. Exiting." | tee -a "$LOG_FILE"
        exit 1
    fi

    # Process each file
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            process_image "$file"
        fi
    done
}

# Main script execution
main() {
    echo "$(date): Starting image resizing process." > "$LOG_FILE"

    check_imagemagick_installed
    prepare_output_dir
    process_images

    echo "$(date): Image resizing process completed." >> "$LOG_FILE"
    echo "Log saved to $LOG_FILE."
}

# Run the main function
main