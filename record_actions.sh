#!/bin/sh
. ./file_utils.sh

get_existing_records() {
    _record_name="$1"
    _number_of_records="$2"
    validate_records_data "$_record_name" "$_number_of_records"
    _input_valid=$?

    if [ $_input_valid -eq 1 ]; then
        return 1
    fi

    _existing_records=$(search_db "$_record_name")
    if [ -z "$_existing_records" ]; then
        return 0
    fi

    _num_rows=$(echo "$_existing_records" | wc -l)

    return "$_num_rows"
}

add_to_existing_record() {
    _old_value="$1"
    printf "Old value: $_old_value\n"

    _new_addition=$2
    IFS=","
    read -ra _old_parts <<< "$_old_value"
    _old_number="${_old_parts[1]}"
   
    _new_value=$(($_old_number + $_new_addition))
    _new_record="${_old_parts[0]},$_new_value"
  
    echo $_old_value
    echo $_new_record
    sed -i.bak "s/$_old_value/$_new_record/g" "$_file_path"
    IFS=""
}

validate_records_data() {
    _record_name="$1"
    _number_of_records="$2"

    # Input validation
    if [ -z "$_record_name" ]; then
        echo "Error: No record name was provided."
        return 1
    fi

    if [ -z "$_number_of_records" ]; then
        echo "Error: no numbers of records was provided."
        return 1
    fi

    if ! [[ "$_number_of_records" =~ ^[0-9]+$  ]]; then
        echo "Error: Invalid number of records."
        return 1
    fi
}

substract_from_existing_record() {
    _old_value="$1"
    printf "Old value: $_old_value\n"

    _new_sub=$2
    IFS=","
    read -ra _old_parts <<< "$_old_value"
    _old_number="${_old_parts[1]}"
   
    _new_value=$(($_old_number - $_new_sub))
    
    if [ $_new_value -le 0 ]; then
        sed -i.bak "/$_old_value/d" "$_file_path"
        return $?
    fi

    _new_record="${_old_parts[0]},$_new_value"
  
    echo $_old_value
    echo $_new_record
    sed -i.bak "s/$_old_value/$_new_record/g" "$_file_path"
    IFS=""

    return $?
}