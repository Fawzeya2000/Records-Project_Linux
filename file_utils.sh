#!/bin/sh

OPERATION_INSERT="Insert"
OPERATION_DELETE="Delete"
OPERATION_SEARCH="Search"
STATUS_SUCCESS="Success"
STATUS_FAILURE="Failure"

set_file_path() {
    _file_path="$1"
    _audit_file_path="$_file_path _log"
}

check_valid_path() {
    # Check if the argument is provided
    if [ -z "$_file_path" ]; then
        echo "Error: No file path provided."
        return 1
    fi

    # Check if the file exists
    if [ ! -f "$_file_path" ]; then
        echo "Error: File '$_file_path' not found or is not a regular file."
        return 1
    fi

    # # Check if the file is a text file
    # if ! file -b "$_file_path" | grep -q "text"; then
    #     echo "Error: File '$_file_path' is not a text file."
    #     return 1
    # fi

    # If all checks pass, return success
    return 0
}

# Add audit record to the log file
audit_event() {
    _audit_message="$1"
    _status="$2"
    echo "$(date +"%d/%-m/%Y ") $(date +"%T") $_audit_message $_status" >> "$_audit_file_path"
}

search_db() {
    echo "$(grep "$1" "$_file_path" | sort)"
}

print_menu() {
    _lines="$1"
    _counter=1

    while IFS= read -r line; do
        printf "%s. %s\n" "$_counter" "$line"
        _counter=$((_counter + 1))
    done <<< "$_lines"
}

show_menu() {
    _lines="$1"
    _counter="$(echo "$_lines" | wc -l)"

    # Prompt the user to choose a line
    read -p "Enter the number of the line you want to choose: " _choice

    # Check if the input is a valid number
    if [[ ! "$_choice" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid input. Please enter a valid number."
        return 1
    fi

    # Check if the chosen line number is within the range of available lines
    if [ "$_choice" -lt 1 ] || [ "$_choice" -gt "$_counter" ]; then
        echo "Error: Invalid input. Please enter a number within the range of available lines."
        return 1
    fi

    # Print the chosen line
    echo "$_choice"
}

print_action_status() {
    _status="$1"
    _operation="$2"
    if [ "$_status" -eq 0 ]; then
        audit_event "$_operation" "$STATUS_SUCCESS"
    else
        audit_event "$_operation" "$STATUS_FAILURE"
    fi
}
