#!/bin/sh

# Source the file_utils.sh file to import the check_valid_path function
. ./file_utils.sh
. ./api.sh

_file_path="$1"

main() {
    set_file_path "$1"
    _file_path="$1"
    # if ! check_valid_path "$_file_path"; then
    #     exit 1
    # fi

    while true; do
        print_menu "$_api_manu"
        _chosen_line="$(show_menu "$_api_manu")"
        echo "Chosen line: $_chosen_line"
        
        case $_chosen_line in
            1)  
                read -p "Enter a record name: " _name
                read -p "Enter the number of records: " _records
                add_record "$_name" "$_records"
                print_action_status "$?" "$OPERATION_INSERT"
            ;;
            2) 
                read -p "Enter a record name: " _name
                read -p "Enter the number of records: " _records
                delete_records "$_name" "$_records"
                print_action_status "$?" "$OPERATION_DELETE"
            ;;
            3) update_record ;;
            4)
                read -p "Enter a record name: " _name
                _results=$(search_record "$_name")

                _counter="$(echo "$_results" | wc -l)"
                if [ "$_counter" -eq 0 ]; then
                    audit_event "$OPERATION_SEARCH" "$STATUS_FAILURE"
                else
                    printf "%s\n" "$_results"
                    audit_event "$OPERATION_SEARCH" "$STATUS_SUCCESS"
                fi
            ;;
            5) exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

main "$1"