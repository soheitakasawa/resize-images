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
# Size configuration options
SIZES=(
    "1800,900"  # Original sizes
    "1880,940"  # New sizes
)

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
    local size_option="$2"
    IFS=',' read -r large_size small_size <<< "$size_option"
    
    local base_name=$(basename "$input_file" | sed -E 's/\.(jpg|png|psd)$//i')
    local output_2x="$OUTPUT_DIR/${base_name}_${large_size}@2x.jpg"
    local output_small="$OUTPUT_DIR/${base_name}_${small_size}.jpg"

    # Resize to large size
    magick "$input_file" -resize "${large_size}x" "$output_2x" && echo "$(date): Resized to ${large_size}px: $output_2x" >> "$LOG_FILE"

    # Resize to small size
    magick "$input_file" -resize "${small_size}x" "$output_small" && echo "$(date): Resized to ${small_size}px: $output_small" >> "$LOG_FILE"
}

# Let user select size option
select_size_option() {
    while true; do
        read -p "サイズオプションを選択してください (1 または 2): " choice
        case $choice in
            1) echo "${SIZES[0]}"; return ;;
            2) echo "${SIZES[1]}"; return ;;
            *) echo "無効な選択です。1 または 2 を入力してください。" ;;
        esac
    done
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

    # Get size option from user
    echo "利用可能なサイズオプション:"
    echo "1) 1800px(@2x) / 900px"
    echo "2) 1880px(@2x) / 940px"
    local selected_size=$(select_size_option)

    # Process each file with selected size option
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "Processing $file..."
            process_image "$file" "$selected_size"
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