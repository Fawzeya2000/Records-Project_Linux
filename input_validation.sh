#!/bin/bash

validate_record_name() {
    _record_name="$1"

    if [ -z "$_record_name" ]; then
        echo "Error: No record name was provided."
        return 1
    fi

    if ! [[ "$_record_name" =~ ^[[:alnum:][:space:]]+$ ]]; then
        echo "Error: Invalid record name. Only letters, digits, and spaces are allowed."
        return 1
    fi

    return 0
}

validate_record_numbers() {
    _number_of_records="$1"

    if [ -z "$_number_of_records" ]; then
        echo "Error: no numbers of records was provided."
        return 1
    fi

    if ! [[ "$_number_of_records" =~ ^[0-9]+$  ]]; then
        echo "Error: Invalid number of records."
        return 1
    fi

    return 0
}

validate_records_input() {
    _record_name="$1"
    _number_of_records="$2"
    validate_record_name "$_record_name"
    if [ $? -eq 1 ]; then
        return 1
    fi

    validate_record_numbers "$_number_of_records"
   return $?
}