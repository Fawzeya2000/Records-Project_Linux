#!/bin/sh
. ./file_utils.sh
. ./record_actions.sh

_api_manu=$(cat << EOF
Add record
Delete record
Update record
Search record
Print records summary
Print all records
Exit
EOF
)

add_record() {
    get_existing_records "$1" "$2"
    _matched_records=$?

    if [ $_matched_records -eq 0 ]; then
        echo "$1,$2" >> "$_file_path"
        return 0
    fi

    printf "Matched records: $_matched_records\n"
    if [ "$_matched_records" -eq 1 ]; then
        add_to_existing_record $_existing_records $_number_of_records
        return
    else
        print_menu "$_existing_records"
        _chosen_line="$(show_menu "$_existing_records")"
        _specific_line=$(echo "$_existing_records" | sed -n "${_chosen_line}p")
        add_to_existing_record $_specific_line $_number_of_records
    fi
   
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
        
    fi
}

delete_records() {
    get_existing_records "$1" "$2"
    _matched_records=$?

    if [ "$_matched_records" -eq 1 ]; then
        substract_from_existing_record $_existing_records $_number_of_records
        return 0
    else
        print_menu "$_existing_records"
        _chosen_line="$(show_menu "$_existing_records")"
        _specific_line=$(echo "$_existing_records" | sed -n "${_chosen_line}p")
        substract_from_existing_record $_specific_line $_number_of_records
    fi
   
    if [ $? -eq 0 ]; then
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

update_record() {
    echo "Not implemented"
}

search_record() {
    _existing_records=$(search_db "$1")
    echo "$_existing_records"
}

print_all() {
    _records=$(search_db "")

    while IFS= read -r line; do
        num_records="${line#*,}"
        _counter=$((_counter + num_records))
    done < "$_file_path"
    
    for line in $_records; do
        record_name="${line%%,*}"
        num_records="${line#*,}"
        _record="$record_name $num_records"
        echo "$_record"
       
        audit_event "$OPERATION_PRINTALL" "$_record"
    done
}

exit() {
    return 0
}