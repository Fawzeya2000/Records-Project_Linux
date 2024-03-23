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

    if [ "$_matched_records" -eq 1 ]; then
        add_to_existing_record $_existing_records "$2"
        return
    else
        # _records_to_present=$(cat <<EOF
        #     $_existing_records
        #     $1 $2
        #     EOF
        # )
        _records_to_present=$(cat <<EOF
$_existing_records
New record - $1,$2
EOF
            )
        print_menu "$_records_to_present"
        _chosen_line="$(show_menu "$_records_to_present")"
        _specific_line=$(echo "$_records_to_present" | sed -n "${_chosen_line}p")
        
        if ["$_chosen_line" -eq $(($_matched_records + 1)) ]; then
            echo "$1,$2" >> "$_file_path"
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
    get_existing_records "$1" "$2"
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

update_record() {
    echo "Not implemented"
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

exit() {
    return 0
}