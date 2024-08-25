#!/bin/bash

# Set the file paths
LOG_FILE=/prod/var/ordo/time.log
NEW_LOG_FILE="/prod/var/batchops/CMIMPREL_Check/CIMPREL_Latest_Check_$(date +'%d%m%Y%H%M%S').Log"
EMAIL_SUBJECT="CIMPREL Run Check-Suez [PROD]"
EMAIL_RECIPIENT="sohan.jha@oracle.com,vidyasagar.reddi@oracle.com,dibyam.sahu@oracle.com,sagar.sangishetty@oracle.com,athul.chandran@oracle.com,suraj.r.mote@oracle.com,arjav.srivastava@oracle.com,avinash.kumar.mahor@oracle.com,shravani.v.v.r@oracle.com,rakesh.v.vasamsetti@oracle.com,ajay.dahiya@oracle.com"
TEMP_DIR="/tmp"

# Extract the last 10 grep entries from the log file and save them to the new log file
grep 'REL021-10' "$LOG_FILE" | tail -n 3 > "$NEW_LOG_FILE"

# Create the email body
EMAIL_BODY="Please check the below latest entries of CIMPREL and see if exit code 1 or 2. Please clear the resource to continue the chain, Ignore if already cleared.

$(cat "$NEW_LOG_FILE")"

# Send email with the log file contents and body
echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$EMAIL_RECIPIENT"


cd /prod/var/batchops/CMIMPREL_Check/
#rm CIMPREL_Latest_Check_*

