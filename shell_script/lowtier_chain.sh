#!/usr/bin/bash

#Varilables
fixed_part="rlv_"
time_threshold="1930"

read -p "Enter the bizdate (YYYYMMDD): " bizdate

# Check if the user entered the date and if it's in the correct format
if [[ ! "$bizdate" =~ ^[0-9]{8}$ ]]; then
  echo "Invalid date format. Please enter the date in YYYYMMDD format."
  exit 1
fi

# Directories to search and their corresponding fixed parts
declare -A directories
directories=(
  ["/perf/echanges/IN/MICROREL/FLX-REL-CRREL/archive/"]="rlv_"
  ["/perf/echanges/IN/TPMS/archive"]="xml_"
  ["/perf/echanges/ccnb/FAC/CMCTTRA/archive"]="dat_"
)

# Time threshold in HHMM format
time_threshold="1930"

# Loop through each directory and search for files
for directory in "${!directories[@]}"; do
  fixed_part="${directories[$directory]}"
  echo "Searching in directory: $directory with fixed part: $fixed_part"

  for file in "$directory"/*; do
    # Extract the filename from the full path
    filename=$(basename "$file")

    # Check if the filename contains the fixed part and the specific date
    if [[ "$filename" == *"$fixed_part$bizdate"* ]]; then
      # Extract the timestamp portion after the specific date
      timestamp="${filename#*$fixed_part$bizdate}"
      timestamp="${timestamp:0:4}"  # Get HHMM part from the string

      # Check if timestamp is in HHMM format and compare with threshold
      if [[ $timestamp =~ ^[0-9]{4}$ ]]; then
        if [[ $timestamp -ge $time_threshold ]]; then
          echo "$file"
        fi
      fi
    fi
  done
done