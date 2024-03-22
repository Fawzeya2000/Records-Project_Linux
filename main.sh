#!/bin/sh

# Source the file_utils.sh file to import the check_valid_path function
. ./file_utils.sh

_file_path="$1"

_main_manu=$(cat << EOF
Add record
Delete record
Update record
Search record
Exit
EOF
)

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

add_record() {
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

    _existing_records=$(search_db "$_record_name")
    if [ -z "$_existing_records" ]; then
        echo "$1,$2" >> "$_file_path"
        return 0
    fi

    _num_rows=$(echo "$_existing_records" | wc -l)
    if [ "$_num_rows" -eq 1 ]; then
        add_to_existing_record $_existing_records $_number_of_records
        return
    else
        print_menu "$_existing_records"
        _chosen_line="$(show_menu "$_existing_records")"
        _specific_line=$(echo "$_existing_records" | sed -n "${_chosen_line}p")
        printf "Specific line: $_specific_line\n"
        add_to_existing_record $_specific_line $_number_of_records
    fi
   
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
        
    fi
}

delete_record() {
    echo "Not implemented"
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

main() {
    set_file_path "$1"
    _file_path="$1"
    # if ! check_valid_path "$_file_path"; then
    #     exit 1
    # fi

    while true; do
        print_menu "$_main_manu"
        _chosen_line="$(show_menu "$_main_manu")"
        echo "Chosen line: $_chosen_line"
        
        case $_chosen_line in
            1)  
                read -p "Enter a record name: " _name
                read -p "Enter the number of records: " _records
                add_record "$_name" "$_records"
                print_action_status "$?" "$OPERATION_INSERT"
            ;;
            2) delete_record ;;
            3) update_record ;;
            4) search_record ;;
            5) exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done

    # res=$(search_db "test")
    # show_menu "$res"
}

main "$1"