#!/bin/sh
. ./file_utils.sh
. ./record_actions.sh

_api_manu=$(cat << EOF
Add record
Delete record
Update record name
Update record instances
Search record
Print records summary
Print all records
Exit
EOF
)

add_record() {
    validate_records_input "$1" "$2"
    _input_valid=$?
    if [ $_input_valid -eq 1 ]; then
        return 1
    fi

    get_existing_records "$1"
    _matched_records=$?

    if [ $_matched_records -eq 0 ]; then
        echo "$1,$2/n" >> "$_file_path"
        return 0
    fi

    if [ "$_matched_records" -eq 1 ]; then
        add_to_existing_record $_existing_records "$2"
        return
    else
        _records_to_present=$(cat <<EOF
$_existing_records
New record - $1,$2
EOF
            )
        print_menu "$_records_to_present"
        _chosen_line="$(show_menu "$_records_to_present")"
        _specific_line=$(echo "$_records_to_present" | sed -n "${_chosen_line}p")
        
        if [ "$_chosen_line" -eq $(($_matched_records + 1)) ]; then
            echo "$1,$2/n" >> "$_file_path"
        else
            add_to_existing_record "$_specific_line" "$2"
        fi
    fi
   
    if [ $? -eq 0 ]; then
        echo "Add record action was performed successfully"
        return 0
    else
        echo "Add record action was performed failed"
        return 1
        
    fi
}

delete_records() {
    validate_records_input "$1" "$2"
    _input_valid=$?
    if [ $_input_valid -eq 1 ]; then
        return 1
    fi

    get_existing_records "$1"
    _matched_records=$?

    if [ "$_matched_records" -eq 1 ]; then
        substract_from_existing_record "$_existing_records" "$2"
    else
        print_menu "$_existing_records"
        _chosen_line="$(show_menu "$_existing_records")"
        _specific_line=$(echo "$_existing_records" | sed -n "${_chosen_line}p")
        substract_from_existing_record "$_specific_line" "$2"
    fi
   
    if [ $? -eq 0 ]; then
        echo "Delete record action was performed successfully"
        return 0
    else
        return 1
        
    fi
}

print_record_summary() {
    _counter=0
    get_db_summary
    if [ $? -eq 0 ]; then
        echo "There are no records defined in the DB"
    else
        echo "There are $_counter records in the DB"
    fi

    audit_event "$OPERATION_SUMMARY" "$_counter"
}

search_record() {
    echo "$(search_db "$1")"
}

print_all() {
    _records=$(search_db "")

    for line in $_records; do
        record_name="${line%%,*}"
        num_records="${line#*,}"
        _record="$record_name $num_records"
        echo "$_record"
       
        audit_event "$OPERATION_PRINTALL" "$_record"
    done
}

update_record_name() {
    _old_name="$1"
    _new_name="$2"

    if [ -z "$_old_name" ] || [ -z "$_new_name" ]; then
        echo "Error: Both old and new record names must be provided."
        return 1
    fi

    _records=$(search_db "$_old_name")
    if [ -z "$_records" ]; then
        echo "Error: No records found in the DB."
        return 1
    fi

    _num_rows=$(echo "$_records" | wc -l)
    if [ "$_num_rows" -eq 0 ]; then
        echo "Error: No records found in the DB."
        return 1
    fi

    if [ "$_num_rows" -eq 1 ]; then
        num_records="${_records#*,}"
        sed -i.bak "s/$_records/$_new_name,$num_records/g" "$_file_path"
        return 0
    fi

    print_menu "$_records"
    _chosen_line="$(show_menu "$_records")"
    _specific_line=$(echo "$_records" | sed -n "${_chosen_line}p")
    num_records="${_specific_line#*,}"
    sed -i.bak "s/$_specific_line/$_new_name,$num_records/g" "$_file_path"

    return $?
}

update_record_instances() {
    _name="$1"
    _new_instances="$2"

    if [ -z "$_name" ] || [ -z "$_new_instances" ]; then
        echo "Error: both record name and new instances must be provided"
        return 1
    fi

     if [ "$_new_instances" -lt 1 ]; then
        echo "Error: Number of instances must be greater than 0"
        return 1
    fi

    _records=$(search_db "$_name")
    if [ -z "$_records" ]; then
        echo "Error: No records found in the DB"
        return 1
    fi

    _num_rows=$(echo "$_records" | wc -l)
    if [ "$_num_rows" -eq 0 ]; then
        echo "Error: No records found in the DB"
        return 1
    fi

    if [ "$_num_rows" -eq 1 ]; then
        record_name="${_records%%,*}"
        sed -i.bak "s/$_records/$record_name,$_new_instances/g" "$_file_path"
        return 0
    fi

    print_menu "$_records"
    _chosen_line="$(show_menu "$_records")"
    _specific_line=$(echo "$_records" | sed -n "${_chosen_line}p")
    record_name="${_specific_line%%,*}"
    sed -i.bak "s/$_specific_line/$record_name,$_new_instances/g" "$_file_path"

    return $?
}

exit() {
    return 0
}