#!/bin/bash

set -o errexit

export RUNFOLDER="$1"
export NGS2COUNTS_EXECUTABLE="$2"
export NGS2COUNTS_EXTRA_ARGS="${3:-}"
export NGS2COUNTS_VERSION_FILE="ngs2counts_version.txt"
export NGS2COUNTS_LOG="ngs2counts_log.txt"
export OUTPUT_DIR="$RUNFOLDER/ngs2counts"

"$NGS2COUNTS_EXECUTABLE" -V > "$RUNFOLDER/$NGS2COUNTS_VERSION_FILE"

args=( "$RUNFOLDER" --output-dir "$OUTPUT_DIR" )

if [[ -n "$NGS2COUNTS_EXTRA_ARGS" ]]; then
    args+=( $NGS2COUNTS_EXTRA_ARGS )
fi

if echo "$NGS2COUNTS_EXTRA_ARGS" | grep -qE '(--output-dir|-o\b)'; then
    echo "ERROR: Do not pass --output-dir/-o in extra_args. The pipeline manages the output directory." >&2
    exit 1
fi

"$NGS2COUNTS_EXECUTABLE" "${args[@]}" | tee "$RUNFOLDER/$NGS2COUNTS_LOG"
