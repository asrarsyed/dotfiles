#!/usr/bin/env zsh

# Description: Comprehensive preview filter to preview files with color and structure in less using utilities like bat, jq, sqlite3, etc.
# Requirements: None - Used in .zshenv
# Instructions: None

set -euo pipefail
IFS=$'\n\t'

# Print usage information
usage() {
  cat <<EOF
Usage: ${0##*/} [--help] <file-or-directory>

Options:
  -h, --help    Show this help message and exit
EOF
  exit 0
}

# Ensure required commands exist
require_cmd() {
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Error: '$cmd' not found." >&2
      exit 1
    fi
  done
}

# Horizontal ruler function
hr() {
  local char="$1"
  local width=${COLUMNS:-80}
  printf "%${width}s\n" "" | tr ' ' "$char"
}

# Show help
[[ ${1-} =~ ^(-h|--help)$ ]] && usage

# Resolve MIME type and file info
file_path="$1"
mime=$(file -Lbs --mime-type "$file_path")
category=${mime%%/*}
kind=${mime##*/}
ext=${file_path##*.}

# Handle different file types
if [[ -d "$file_path" ]]; then
  # Directory listing with fallbacks
  if command -v eza &>/dev/null; then
    eza -hl --git --color=always --icons "$file_path"
  elif command -v exa &>/dev/null; then
    exa -hl --color=always --icons "$file_path"
  else
    ls -la --color=always "$file_path"
  fi
  exit 0
elif [[ "$kind" =~ (vnd.openxmlformats-officedocument.spreadsheetml.sheet|vnd.ms-excel) ]]; then
  # Spreadsheet preview (XLS/XLSX)
  if command -v in2csv &>/dev/null && command -v xsv &>/dev/null && command -v bat &>/dev/null; then
    in2csv "$file_path" | xsv table | bat -ltsv --color=always
  elif command -v csvtable &>/dev/null && command -v bat &>/dev/null; then
    csvtable "$file_path" | bat -ltsv --color=always
  else
    echo "Error: Required tools for spreadsheet preview not found." >&2
    exit 1
  fi
  exit 0
elif [[ "$ext" =~ ^(ya?ml)$ ]]; then
  # YAML files
  require_cmd yq bat
  yq eval-all . "$file_path" | bat -lyaml --color=always
  exit 0
elif [[ "$ext" == xml ]]; then
  # XML files
  require_cmd xmlstarlet bat
  xmlstarlet fo "$file_path" | bat -lxml --color=always
  exit 0
elif [[ "$ext" == md ]]; then
  # Markdown
  require_cmd bat
  bat --color=always -lmarkdown "$file_path"
  exit 0
elif [[ "$kind" == pdf ]]; then
  # PDF documents
  require_cmd pdftotext sed
  pdftotext -q "$file_path" - | sed "s/\f/$(hr ─)\n/g"
  exit 0
elif [[ "$kind" == json ]]; then
  # JSON and Jupyter Notebooks
  if [[ "$ext" == ipynb ]]; then
    require_cmd jupyter-nbconvert bat
    jupyter-nbconvert --to python --stdout "$file_path" | bat --color=always -plpython
  else
    require_cmd jq
    jq -Cr . "$file_path"
  fi
  exit 0
elif [[ "$kind" == javascript ]]; then
  # JavaScript
  require_cmd bat
  bat --color=always -ljs "$file_path"
  exit 0
elif [[ "$kind" == rfc822 ]]; then
  # Email files
  if command -v bat &>/dev/null; then
    bat --color=always -lEmail "$file_path"
  else
    cat "$file_path"
  fi
  exit 0
elif [[ "$kind" == vnd.sqlite3 ]]; then
  # SQLite databases
  require_cmd sqlite3 bat
  sqlite3 "$file_path" .schema | bat -plsql --color=always
  exit 0
elif [[ $(basename "$file_path") == events.out.tfevents.* ]]; then
  # TensorBoard event logs
  if command -v python3 &>/dev/null; then
    # Check for required Python libraries
    if python3 -c "import pandas, plotext, tensorboard" &>/dev/null; then
      python3 - <<EOF
import sys
from contextlib import suppress
from time import gmtime, strftime
import pandas as pd
import plotext as plt
from tensorboard.backend.event_processing.event_file_loader import EventFileLoader

df = pd.DataFrame(columns=["Step", "Value"])
df.index.name = "Timestamp"
for event in EventFileLoader("$file_path").Load():
    with suppress(IndexError):
        ts = strftime("%F %H:%M:%S", gmtime(event.wall_time))
        df.loc[ts] = [event.step, event.summary.value[0].tensor.float_val[0]]
plt.plot(df["Step"], df["Value"], marker="braille")
plt.title(event.summary.value[0].metadata.display_name)
plt.clc()
plt.show()
df.to_csv(sys.stdout, sep="\t")
EOF
    else
      echo "Error: Required Python libraries (pandas, plotext, tensorboard) not found." >&2
      exit 1
    fi
  else
    echo "Error: Python3 not found." >&2
    exit 1
  fi
  exit 0
elif [[ $(basename "$file_path") == data.mdb ]]; then
  # LMDB databases
  if command -v python3 &>/dev/null; then
    # Check for required Python libraries
    if python3 -c "import lmdb" &>/dev/null; then
      python3 - <<EOF
import lmdb
from os.path import dirname
env = lmdb.open(dirname("$file_path"))
with env.begin() as txn:
    for key, _ in txn.cursor():
        print(key.decode())
EOF
    else
      echo "Error: Required Python library (lmdb) not found." >&2
      exit 1
    fi
  else
    echo "Error: Python3 not found." >&2
    exit 1
  fi
  exit 0
elif [[ "$kind" == zip && "$ext" == pth ]]; then
  # PyTorch checkpoints
  if command -v python3 &>/dev/null; then
    # Check for required Python libraries
    if python3 -c "import torch" &>/dev/null; then
      python3 - <<EOF
import torch
try:
    obj = torch.load("$file_path")
    if hasattr(obj, 'shape'):
        print('Tensor shape:', obj.shape)
    else:
        print(obj)
except Exception as e:
    print(f"Error loading PyTorch file: {e}")
EOF
    else
      echo "Error: Required Python library (torch) not found." >&2
      exit 1
    fi
  else
    echo "Error: Python3 not found." >&2
    exit 1
  fi
  exit 0
elif [[ "$category" == image ]]; then
  # Images (terminal render + metadata)
  if command -v chafa &>/dev/null; then
    chafa -f symbols "$file_path"
  fi
  if command -v exiftool &>/dev/null && command -v bat &>/dev/null; then
    exiftool "$file_path" | bat --color=always -plyaml
  elif command -v exiftool &>/dev/null; then
    exiftool "$file_path"
  fi
  exit 0
elif [[ "$category" == text ]]; then
  # Plain text and other
  if command -v bat &>/dev/null; then
    bat --color=always "$file_path"
  elif command -v pygmentize &>/dev/null; then
    pygmentize "$file_path"
  else
    cat "$file_path"
  fi
  exit 0
else
  # Unsupported types
  echo "No preview available for: $mime" >&2
  exit 1
fi
