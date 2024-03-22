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

    echo "$1,$2" >> "$_file_path"
    
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