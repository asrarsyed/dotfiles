#!/usr/bin/env sh

# Description: Uploads the specified file to 0x0.st and prints a shareable URL.
# Requirements: curl
# Instructions: fileshare <filepath>

set -e

print_usage() {
  cat <<'EOF'
Usage: fileshare <filepath>

Uploads the specified file to 0x0.st and prints a short URL.

Examples:
  fileshare ~/Downloads/example.txt
  fileshare ./report.pdf
EOF
}

# Check for argument
if [ "$#" -ne 1 ]; then
  print_usage
  exit 1
fi

FILE="$1"

# Check file exists and is a regular file
if [ ! -f "$FILE" ]; then
  echo "Error: File '$FILE' does not exist or is not a regular file." >&2
  exit 1
fi

# Check for curl
if ! command -v curl >/dev/null 2>&1; then
  echo "Error: 'curl' is required but not installed." >&2
  exit 1
fi

# Upload file
URL=$(curl -sf -F "file=@$FILE" https://0x0.st) || {
  echo "Error: Upload failed. Check your internet connection or file size." >&2
  exit 1
}

echo "Uploaded: $URL"
