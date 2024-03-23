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
            3)
                read -p "Enter a record name: " _name
                read -p "Enter a new record name: " _new_name
                update_record_name "$_name" "$_new_name"
                if [ $? -eq 0 ]; then
                    echo "Update record name action was performed successfully"
                    audit_event "$OPERATION_UPDATE" "$STATUS_SUCCESS"
                else
                    audit_event "$OPERATION_UPDATE" "$STATUS_FAILURE"
                fi
            ;;
            4)
                read -p "Enter a record name: " _name
                read -p "Enter the new number of instances: " _instances
                update_record_instances "$_name" "$_instances"
                if [ $? -eq 0 ]; then
                    echo "Update record instances action was performed successfully"
                    audit_event "$OPERATION_AMOUNTH" "$STATUS_SUCCESS"
                else
                    audit_event "$OPERATION_AMOUNTH" "$STATUS_FAILURE"
                fi
            ;;
            5)
                read -p "Enter a record name: " _name
                _results=$(search_record "$_name")

                _counter="$(echo "$_results" | wc -l)"
                if [ -z "$_results" ]; then
                    echo "No records found"
                    audit_event "$OPERATION_SEARCH" "$STATUS_FAILURE"
                    continue
                fi

                if [ "$_counter" -eq 0 ]; then
                    echo "No records found"
                    audit_event "$OPERATION_SEARCH" "$STATUS_FAILURE"
                else
                    printf "%s\n" "$_results"
                    audit_event "$OPERATION_SEARCH" "$STATUS_SUCCESS"
                fi
            ;;
            6) 
                print_record_summary 
            ;;
            7) 
                print_all
            ;;
            8) exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

main "$1"