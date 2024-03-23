#!/bin/bash

_file_path="$1"

# Check if the file exists
if [ -f "$_file_path" ]; then
    current_date=$(date +"%d/%m/%Y")

    # Check if there is a line with "Failure"
    if grep -q "Failure" "$_file_path"; then
        # Send email notification for failure
        echo "Failure detected in the log file: $_file_path" | mail -s "Failure Notification $current_date" tom.weiss.t@gmail.com
    fi
else
    # Send email notification for file not found error
    echo "Error: File $_file_path was not found." | mail -s "Error Notification" tom.weiss.t@gmail.com
fi