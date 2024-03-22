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

# run_menu() {
#     echo "1. Add record"
#     echo "2. Delete record"
#     echo "3. Update record"
#     echo "4. Search record"
#     echo "5. Exit"

#     read -p "Enter your choice: " _choice
    
#     case "$_choice" in
#         1)  
#             read -p "Enter a record name: " _name
#             read -p "Enter the number of records: " _records
#             add_record "$_name" "$_records"
#         ;;
#         2) delete_record ;;
#         3) update_record ;;
#         4) search_record ;;
#         5) exit 0 ;;
#         *) echo "Invalid choice. Please try again." ;;
#     esac
# }

add_record() {
    _record_name="$1"
    _number_of_records="$2"

    # Input validation
    if [ -z "$_record_name" ]; then
        echo "Error: No file path provided."
        return 1
    fi

    if [ -z "$_number_of_records" ]; then
        echo "Error: No file path provided."
        return 1
    fi

    # Check if the record numbers is a number
    # if ! [[ "$_number_of_records" =~ ^[0-9]+$ ]]; then
    #     echo "Error: Invalid number of records."
    #     return 1
    # fi

    echo "$1,$2" >> "$_file_path"
    
    if [ $? -eq 0 ]; then
        audit_event OPERATION_INSERT STATUS_SUCCESS
    else
        audit_event OPERATION_INSERT STATUS_FAILURE
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