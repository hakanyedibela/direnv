#!/bin/bash

# Define the root .envrc file
ROOT_ENVRC=".envrc"

# Ensure the root .envrc exists
if [[ ! -f "$ROOT_ENVRC" ]]; then
    echo "Error: $ROOT_ENVRC not found in the root directory."
    exit 1
fi

# Loop through all subdirectories (excluding hidden ones)
for dir in */; do
    # Remove trailing slash
    dir="${dir%/}"

    # Check if it's a directory and not a symlink
    if [[ -d "$dir" && ! -L "$dir/.envrc" ]]; then
        # Remove existing .envrc if it's a regular file (not a symlink)
        if [[ -f "$dir/.envrc" ]]; then
            echo "Removing existing $dir/.envrc"
            rm "$dir/.envrc"
        fi

        # Create a symlink to the root .envrc
        ln -s "../$ROOT_ENVRC" "$dir/.envrc"
        echo "Symlink created in $dir/.envrc -> ../$ROOT_ENVRC"
    fi
done

echo "✅ All subfolders are now linked to the root .envrc!"