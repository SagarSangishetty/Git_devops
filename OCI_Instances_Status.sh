#!/bin/bash
input_file="/sys1/var/BATCHOPS_SPACE/BATCHOPS/test/script/compute_output.txt"
compute_instance_running_html="/sys1/var/BATCHOPS_SPACE/BATCHOPS/test/script/compute_instance_running.html"

#Email
to_mail="sagar.sangishetty@oracle.com"
subject="SUEZ OCI Instances Status $(date +'%d-%m-%Y')"

#HTML
echo "To: $to_mail" >$compute_instance_running_html
echo "Subject: $subject" >>$compute_instance_running_html
echo "Content-Type: text/html;" >>$compute_instance_running_html
echo "<html lang="en">" >>$compute_instance_running_html

echo "    <style>" >>$compute_instance_running_html
echo "        table {" >>$compute_instance_running_html
echo "            border-collapse: collapse;" >>$compute_instance_running_html
echo "        }" >>$compute_instance_running_html
echo "        table, th, td {" >>$compute_instance_running_html
echo "            border: 1px solid black;" >>$compute_instance_running_html
echo "        }" >>$compute_instance_running_html
echo "        th, td {" >>$compute_instance_running_html
echo "            text-align: center;" >>$compute_instance_running_html
echo "                  padding: 10px;" >>$compute_instance_running_html
echo "        }" >>$compute_instance_running_html
echo "        th {" >>$compute_instance_running_html
echo "            text-align: center;" >>$compute_instance_running_html
echo "            padding: 10px;" >>$compute_instance_running_html
echo "        }" >>$compute_instance_running_html
echo "    </style>" >>$compute_instance_running_html

echo "<body>" >>$compute_instance_running_html
echo "<p>Hi Team,</p>" >>$compute_instance_running_html
echo "<p>Below is the status of OCI instances which are in RUNNING state.</p>" >>$compute_instance_running_html
echo "<br>" >>$compute_instance_running_html

# Read the input file line by line
while IFS= read -r line
do
    # Remove leading and trailing whitespace
    line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Skip lines with only + or | (table borders)
    if [[ $line =~ ^[\+\|]+$ ]]; then
        continue
    fi

    # Replace | with </td><td> and add table row tags
    line=$(echo "$line" | sed -e 's/^|/<tr><td>/' -e 's/|$/<\/td><\/tr>/' -e 's/|/<\/td><td>/g')

    # Write line to output file
    echo "$line" >> $compute_instance_running_html
done < "$input_file"

echo "    </table>" >>$compute_instance_running_html
echo "  <br>" >>$compute_instance_running_html
echo "  <p> $(date) </p>" >>$compute_instance_running_html
echo "  <p> Thanks<br>Oracle Batchops Team </p>" >>$compute_instance_running_html
echo "  </body>" >>$compute_instance_running_html
echo "  </html>" >>$compute_instance_running_html

#/usr/sbin/sendmail -t < $compute_instance_running_html



#grep -v '+' compute_output.txt | awk -F'|' '{print $2,$3,$4}' | while read line;do echo $line|awk -F'|' '{print $2}' done < /sys1/var/BATCHOPS_SPACE/BATCHOPS/test/script/output.txt
