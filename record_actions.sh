#!/bin/sh

. ./file_utils.sh
. ./input_validation.sh

get_existing_records() {
    _record_name="$1"

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

substract_from_existing_record() {
    _old_value="$1"
    _new_sub=$2

    IFS=","
    read -ra _old_parts <<< "$_old_value"
    _old_number="${_old_parts[1]}"
   
    _new_value=$(($_old_number - $_new_sub))
    
     if [ $_new_value -lt 0 ]; then
        echo "Error: The number of records to delete is greater than the existing number of records."
        return 1
    fi

    if [ $_new_value -eq 0 ]; then
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