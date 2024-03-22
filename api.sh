#!/bin/sh
. ./file_utils.sh
. ./record_actions.sh

_api_manu=$(cat << EOF
Add record
Delete record
Update record
Search record
Exit
EOF
)

add_record() {
    get_existing_records "$1" "$2"
    if [ $? -eq 0 ]; then
        echo "$1,$2" >> "$_file_path"
        return 0
    fi

    _matched_records=$?

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

update_record() {
    echo "Not implemented"
}

search_record() {
    echo "Not implemented"
}

exit() {
    return 0
}