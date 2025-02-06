#!/bin/bash

# Set the bucket name
BUCKET_NAME="erpnext-pdf-storage"

# Get the current date in epoch time (UTC) (seconds)
CURRENT_DATE_EPOCH=$(date -u +%s)

while true; do
    RESULTS=$(aws s3api list-objects --bucket "$BUCKET_NAME" --query "Contents[].[Key]" --output text)

    # Check if RESULTS is empty (no objects found)
    if [ -z "$RESULTS" ]; then
        echo "No more objects found. Exiting loop."
        break
    else
        # Loop through each object key (RESULTS contains space-separated object keys)
        for OBJECT_KEY in $RESULTS; do
            # Fetch the LastModified date for the current object key
            LAST_MODIFIED=$(aws s3api head-object --bucket "$BUCKET_NAME" --key "$OBJECT_KEY" | python3 -c "import sys, json; print(json.load(sys.stdin)['LastModified'])")

            # Convert the LastModified date to epoch time (UTC)
            LAST_MODIFIED_EPOCH=$(date -u -d "$LAST_MODIFIED" +%s)

            # Calculate the difference in seconds
            DATE_DIFF=$((CURRENT_DATE_EPOCH - LAST_MODIFIED_EPOCH))

            # Calculate the difference in days (86400 seconds in a day)
            DATE_DIFF_DAYS=$((DATE_DIFF / 86400))

            # Display the result
            echo "The difference between the current date and the LastModified date is: $DATE_DIFF_DAYS days."

            # Check if the object is older than 7 days (7 days = 604800 seconds)
            if [ "$DATE_DIFF_DAYS" -gt 0 ]; then
                echo "Object: $OBJECT_KEY - Last modified date: $LAST_MODIFIED ----- > Delete !" >> /home/frappe15/ansible_shellScript_project/data.txt
            else
                echo "Object: $OBJECT_KEY - Last modified date: $LAST_MODIFIED ----- > Keep this Object!"
            fi
        done
        break
    fi
done

##hdkshfkhk
      


# # Calculate the difference in seconds
# DATE_DIFF=$((CURRENT_DATE_EPOCH - LAST_MODIFIED_EPOCH))

# # Calculate the difference in days
# DATE_DIFF_DAYS=$((DATE_DIFF / 86400))  # 86400 seconds in a day

# # Display the result
# echo "The difference between the current date and the LastModified date is: $DATE_DIFF_DAYS days."

# # Check if the object is older than 7 days (7 days = 604800 seconds)
# if [ "$DATE_DIFF_DAYS" -gt 7 ]; then
#     echo "This Object should be deleted !"
# else
#     echo "Keep this Object Object ... !" 
# fi
