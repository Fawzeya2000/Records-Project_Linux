#!/bin/bash

_file_path="$1"

# Check if the file exists
if [ -f "$_file_path" ]; then
    current_date=$(date +"%d/%m/%Y")
    twenty_four_hours_ago=$(date -d "24 hours ago" +"%d/%m/%Y")
    
    if grep -q "Failure" "$_file_path" | awk -v start="$twenty_four_hours_ago" -v end="$current_date" '$0 >= start && $0 <= end'; then
        # Send email notification for failure
        echo "Failure detected in the log file: $_file_path" | mail -s "Failure Notification $current_date" tom.weiss.t@gmail.com
    fi
else
    # Send email notification for file not found error
    echo "Error: File $_file_path was not found." | mail -s "Error Notification" tom.weiss.t@gmail.com
fi