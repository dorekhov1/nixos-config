#!/bin/bash

# Output file path
output_file="my_nixos.txt"

# Remove the output file if it already exists
rm -f "$output_file"

# Find all files in the current directory and subdirectories
# Excluding hidden files/directories and the output file itself
find . -type f \
  ! -name ".*" \
  ! -name "$output_file" \
  ! -path "*/\.*" \
  ! -path "*/node_modules/*" \
  ! -path "*/__pycache__/*" \
  ! -path "*/venv/*" \
  ! -path "*/build/*" \
  ! -path "*/dist/*" |
  sort |
  while read -r file; do

    # Skip only known binary file extensions
    if [[ "$file" =~ \.(png|jpg|jpeg|gif|pdf|zip|tar|gz|bin|exe|o|so|dylib|dll|class)$ ]]; then
      echo "Skipping binary file: $file"
      continue
    fi

    # Common text files without extensions that we want to include
    if [[ "$file" =~ /(justfile|Dockerfile|Makefile|README)$ ]] ||
      [[ "$file" =~ \.(nix|lua|md|txt|toml|yaml|yml|json|js|py|sh|bash|zsh|fish|conf|ini|cfg)$ ]]; then
      # Add a header with the relative file path
      echo "### File: $file ###" >>"$output_file"
      echo "" >>"$output_file"

      # Add the file contents
      cat "$file" >>"$output_file"

      # Add two blank lines between files for better readability
      echo -e "\n\n" >>"$output_file"
      continue
    fi

    # For all other files, try to detect if they're text
    if LC_ALL=C grep -Iq . "$file" 2>/dev/null; then
      echo "### File: $file ###" >>"$output_file"
      echo "" >>"$output_file"
      cat "$file" >>"$output_file"
      echo -e "\n\n" >>"$output_file"
    else
      echo "Skipping unreadable or binary file: $file"
    fi
  done

# Check if any files were found and combined
if [ -s "$output_file" ]; then
  echo "Successfully combined files into $output_file"
  echo "Total size: $(du -h "$output_file" | cut -f1)"
else
  echo "No files found to combine"
  rm -f "$output_file"
fi
