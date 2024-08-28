#!/usr/bin/bash

#Varilables
fixed_part="rlv_"
CMIMPREL="/perf/echanges/IN/MICROREL/FLX-REL-CRREL/archive/"
#CMRENALF=/prod/echanges/ccnb/REN/CMRENALF/archive
#CMCONSEN="/prod/echanges/IN/TPMS/archive"
#CMCTTRA="/prod/echanges/ccnb/FAC/CMCTTRA/archive"
time_threshold="1930"

read -p "Enter the bizdate (YYYYMMDD): " bizdate

# Check if the user entered the date and if it's in the correct format
if [[ ! "$bizdate" =~ ^[0-9]{8}$ ]]; then
  echo "Invalid date format. Please enter the date in YYYYMMDD format."
  exit 1
fi

# Find and print files matching the specific date and time criteria
for file in "$CMIMPREL"/*; do
  # Extract the filename from the full path
  filename=$(basename "$file")

  # Check if the filename contains the fixed part and the specific date
  if [[ "$filename" == *"$fixed_part$bizdate"* ]]; then
    # Extract the timestamp portion after the specific date
    timestamp="${filename#*$fixed_part$specific_date}"
    timestamp="${timestamp:0:4}"  # Get HHMM part from the string

    # Check if timestamp is in HHMM format and compare with threshold
    if [[ $timestamp =~ ^[0-9]{4}$ ]]; then
      if [[ $timestamp -ge $time_threshold ]]; then
        echo "$file"
      fi
    fi
  fi
done
