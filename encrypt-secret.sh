#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <input-file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.yaml}.enc.yaml"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

echo "Encrypting $INPUT_FILE -> $OUTPUT_FILE"

sops encrypt --gcp-kms projects/kbs610/locations/global/keyRings/sops/cryptoKeys/sops-key "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Successfully encrypted to $OUTPUT_FILE"
