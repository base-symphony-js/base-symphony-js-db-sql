#!/bin/bash

# =======================================
# Section to obtain environment variables
# =======================================
# Getting environment variables from the .env file.
echo "Getting environment variables from the .env file."

# Load environment variables from .env file
if [ -f .env ]; then
    # Add a line break if there is none at the end of the file
    if [ $(tail -c1 .env | wc -l) -eq 0 ]; then
        echo "" >> .env
    fi

    while IFS='=' read -r name value; do
        # Trim whitespace from both ends of the line
        name=$(echo "$name" | xargs)
        value=$(echo "$value" | xargs)

        # Ensure the line isn't a comment or empty
        if [[ ! "$name" =~ ^# && -n "$value" ]]; then
            export "$name"="$value"
        fi
    done < .env
else
    echo "ERROR: .env file not found!"
    exit 1
fi

# Verify the database connection data in the environment variables of the ".env" file.
count=0
if [ -z "$DB_SERVER_NAME" ]; then
    count=$((count + 1))
fi
if [ -z "$DB_DATABASE_NAME" ]; then
    count=$((count + 1))
fi
if [ -z "$DB_USERNAME" ]; then
    count=$((count + 1))
fi
if [ -z "$DB_PASSWORD" ]; then
    count=$((count + 1))
fi
if [ $count -gt 0 ]; then
    echo "ERROR: Some environment variables were not found in the .env file."
    exit 1
fi
clear


# ===========================
# Section to choose an option
# ===========================
menuTitle="Select the option:"
menuOptions=(
    "Create the entire database from 0." 
    "Update FUNCTIONS and STORED PROCEDURES."
    "Delete the entire database."
)
maxValue=$((${#menuOptions[@]} - 1))
selection=0
enterPressed=false

while [ "$enterPressed" == false ]; do
    # Print the menu title
    echo "$menuTitle"
    
    # Print each option with highlight for the selected one
    for i in $(seq 0 $maxValue); do
        if [ "$i" -eq "$selection" ]; then
            # Highlight the selected option with background color
            echo -e "\033[48;5;38m[ ${menuOptions[$i]} ]\033[0m"
        else
            echo "  ${menuOptions[$i]}  "
        fi
    done
    echo ""
    echo "Type Ctrl + C to exit."

    # Capture the user input (whole keypress sequence)
    read -rsn3 keyInput
    case $keyInput in
        "")  # Enter key (this is an empty string for enter)
            enterPressed=true
            ;;
        $'\x1B[A')  # Up arrow key
            echo "Up arrow key pressed"
            if [ "$selection" -eq 0 ]; then
                selection=$maxValue
            else
                selection=$((selection - 1))
            fi
            ;;
        $'\x1B[B')  # Down arrow key
            echo "Down arrow key pressed"
            if [ "$selection" -eq "$maxValue" ]; then
                selection=0
            else
                selection=$((selection + 1))
            fi
            ;;
        *)
            # In case of other keys, just redraw the screen
            echo "Other key pressed"
            ;;
    esac

    # Clear the screen and redraw the menu
    clear
done

# Confirming the selected option.
echo ""
echo "Your selected answer was:"
echo "> ${menuOptions[$selection]}"

read -p "Are you sure you want to execute this operation? (YES/NO): " confirm
if [ "$confirm" != "YES" ]; then
    echo ""
    echo "Your response was: $confirm"
    echo "The operation was aborted."
    exit 0
fi
clear


# ===========================
# Section to save script path
# ===========================
# SCHEMA: dbo
# ddl
PATH_dbo_ddl_create="src/dbo/ddl/create.sql"
PATH_dbo_ddl_drop="src/dbo/ddl/drop.sql"
# dml
PATH_dbo_dml_insert="src/dbo/dml/insert.sql"
# fn
PATH_dbo_fn_rn_roles="src/dbo/functions/rn_roles.sql"
PATH_dbo_fn_rn_users="src/dbo/functions/rn_users.sql"
PATH_dbo_fn_drop="src/dbo/functions/drop.sql"
# sp
PATH_dbo_sp_sp_roles="src/dbo/sp/sp_roles.sql"
PATH_dbo_sp_sp_users="src/dbo/sp/sp_users.sql"
PATH_dbo_sp_drop="src/dbo/sp/drop.sql"
# ==========================
# Section to run the scripts
# ==========================
if [ "$selection" -eq 0 ]; then
    echo "Create the entire database from 0."
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_ddl_create" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_dml_insert" -b -f 65001
    echo "Create FUNCTIONS and STORED PROCEDURES."
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_fn_rn_roles" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_fn_rn_users" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_sp_sp_roles" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_sp_sp_users" -b -f 65001
fi

if [ "$selection" -eq 1 ]; then
    echo "Update FUNCTIONS and STORED PROCEDURES."
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_fn_rn_roles" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_fn_rn_users" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_sp_sp_roles" -b -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_sp_sp_users" -b -f 65001
fi

if [ "$selection" -eq 2 ]; then
    echo "Delete the entire database."
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_sp_drop" -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_fn_drop" -f 65001
    sqlcmd -S "$DB_SERVER_NAME" -U "$DB_USERNAME" -P "$DB_PASSWORD" -d "$DB_DATABASE_NAME" -i "$PATH_dbo_ddl_drop" -f 65001
fi

echo "Execution completed."
echo ""
