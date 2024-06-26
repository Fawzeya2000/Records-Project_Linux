#!/bin/bash

OPERATION_INSERT="Insert"
OPERATION_DELETE="Delete"
OPERATION_SEARCH="Search"
OPERATION_SUMMARY="PrintAmount"
OPERATION_PRINTALL="PrintAll"
OPERATION_UPDATE="UpdateName"
OPERATION_AMOUNTH="UpdateAmount"
STATUS_SUCCESS="Success"
STATUS_FAILURE="Failure"

# Set the file path and the audit file path for this file
set_file_path() {
    _file_path="$1"
    _audit_file_path="$_file_path"_log
}

# validates the file path is indeed a path of a text file
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

    # If all checks pass, return success
    return 0
}

# Add audit record to the log file
audit_event() {
    _audit_message="$1"
    _status="$2"
    echo "$(date +"%d/%-m/%Y ")$(date +"%T") $_audit_message $_status" >> "$_audit_file_path"
}

# searches for a record in the DB
# the function first looks for the exact match of the search term
# if no exact match is found, it looks for partial matches
search_db() {
    _search_term="$1"
    _res=$(grep -c "^$_search_term\>," "$_file_path")
    if [ "$_res" -eq 0 ]; then
         grep "$_search_term" "$_file_path" | sort
    fi

    if [ "$_res" -eq 1 ]; then
        grep -w "$_search_term" "$_file_path"
    fi
}

# Responsible for printing a menu
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

get_db_summary() {
    _counter=0

    while IFS= read -r line; do
        num_records="${line#*,}"
        _counter=$((_counter + num_records))
    done < "$_file_path"
    
    return $_counter
}
