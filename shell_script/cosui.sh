#!/usr/bin/bash
#------------------------------------------------------------------------
# Script name:          cosui.sh
# Unix user:            Oracle
# Description:          This script is to send cosui weekly report.
# Written by:           Rajat Jadhav
# Date:                 20-JANUARY-2022
# Required Files:       cosui_email.html,cosui_email.txt
# Execution:            Execute the script with user 'maestro'.
# cosui_email.txt:      To add email recipients
#------------------------------------------------------------------------

#Variables
#env=${ENVIRONNEMENT}; export env
script_path="/prod/var/batchops/scripts/cosui"
cosui_email="${script_path}/cosui_email.txt"
cosui_html="${script_path}/cosui_email.html"
#typeset -u ENV_UPPER=${env}

startdate=`date --date "-8 days" +'%Y-%m-%d'`

biz_date=$startdate

#Email
to_mail="`grep -w 'to_recipient' $cosui_email|cut -d ':' -f2`"
cc_mail="`grep -w 'cc_recipient' $cosui_email|cut -d ':' -f2`"
from_mail="COSUI_Notification@suez.com"
subject="COSUI Weekly Report"

#HTML
echo "To: $to_mail" >$cosui_html
echo "Cc: $cc_mail" >>$cosui_html
echo "From: $from_mail" >>$cosui_html
echo "Subject: $subject" >>$cosui_html
echo "Content-Type: text/html;" >>$cosui_html
echo "<html lang="en">" >>$cosui_html

echo "    <style>" >>$cosui_html
echo "        table {" >>$cosui_html
echo "            border-collapse: collapse;" >>$cosui_html
echo "        }" >>$cosui_html
echo "        table, th, td {" >>$cosui_html
echo "            border: 1px solid black;" >>$cosui_html
echo "        }" >>$cosui_html
echo "        th, td {" >>$cosui_html
echo "            text-align: center;" >>$cosui_html
echo "                  padding: 10px;" >>$cosui_html
echo "        }" >>$cosui_html
echo "        th {" >>$cosui_html
echo "            text-align: center;" >>$cosui_html
echo "            background: lightblue;" >>$cosui_html
echo "            padding: 10px;" >>$cosui_html
echo "        }" >>$cosui_html
echo "    </style>" >>$cosui_html

echo "<body>" >>$cosui_html
echo "<p>Hi Team,</p>" >>$cosui_html
echo "<p>Please find below weekly report.</p>" >>$cosui_html
echo "<br>" >>$cosui_html

echo "    <table>" >>$cosui_html
echo "        <tr>" >>$cosui_html
echo "            <th>Date</th>" >>$cosui_html
echo "            <th>Debut CCB</th>" >>$cosui_html
echo "            <th>Fin CCB</th>" >>$cosui_html
echo "            <th>Debut BI</th>" >>$cosui_html
echo "            <th>Fin BI</th>" >>$cosui_html
echo "        </tr>" >>$cosui_html

for i in $(seq 1 6); do

awk -v night=$biz_date -F ";" '{ if ($1==night) print }' /prod/var/ordo/time.log > /prod/var/batchops/scripts/cosui/biz_date_logs_CCB.txt
awk -v night=$biz_date -F ";" '{ if ($1==night) print }' /prod/var/ordo/BI_LOGS/time.log > /prod/var/batchops/scripts/cosui/biz_date_logs_BI.txt

curr_d=$( date --date "$(date --date "$biz_date +1 day" +"%Y-%m-%d")" +"%Y-%m-%d")

d=$(date --date "$biz_date " +"%A")
if [ $d == Friday ]; then
curr_d=$( date --date "$(date --date "$biz_date +3 day" +"%Y-%m-%d")" +"%Y-%m-%d")
elif [ $d == Saturday ]; then
curr_d=$( date --date "$(date --date "$biz_date +2 day" +"%Y-%m-%d")" +"%Y-%m-%d")
elif [ $d == Sunday ]; then
curr_d=$( date --date "$(date --date "$biz_date +1 day" +"%Y-%m-%d")" +"%Y-%m-%d")
fi

#bizd=`cut -d ';' -f 1 biz_date_logs_CCB.txt | tail -1`
ccb_f=`grep ADM666ZUJ /prod/var/batchops/scripts/cosui/biz_date_logs_CCB.txt | cut -d ';' -f 2 | tail -1`
ccb_l=`grep TEC721AUQ /prod/var/batchops/scripts/cosui/biz_date_logs_CCB.txt | cut -d ';' -f 3 | tail -1`
bi_f=`grep OBI010AUQ /prod/var/batchops/scripts/cosui/biz_date_logs_BI.txt | cut -d ';' -f 2 | head -1`
bi_l=`grep ODI704AUQ /prod/var/batchops/scripts/cosui/biz_date_logs_BI.txt | cut -d ';' -f 3 | tail -1`

if [ -z "$ccb_f" ] && [ -z "$ccb_l" ] && [ -z "$bi_f" ] && [ -z "$bi_l" ]; then #ccb_f has no data
ccb_f="Weekend"
ccb_l="Weekend"
bi_f="Weekend"
bi_l="Weekend"
elif [ ! -z "$ccb_f" ] && [ ! -z "$ccb_l" ] && [ ! -z "$bi_f" ] && [ -z "$bi_l" ]; then
biz_date=$( date --date "$(date --date "$biz_date +1 day" +"%Y-%m-%d")" +"%Y-%m-%d")
awk -v night=$biz_date -F ";" '{ if ($1==night) print }' /prod/var/ordo/BI_LOGS/time.log > /prod/var/batchops/scripts/cosui/biz_date_logs_BI.txt
bi_l=`grep ODI704AUQ /prod/var/batchops/scripts/cosui/biz_date_logs_BI.txt | cut -d ';' -f 3 | tail -1`
fi


timings+="${curr_d};${ccb_f};${ccb_l};${bi_f};${bi_l};. "
biz_date=$( date --date "$(date --date "$biz_date +1 day" +"%Y-%m-%d")" +"%Y-%m-%d")

done

echo $timings | sed -e 's/\.  */.\n/g' -e 's/\.$/.\n/g' > /prod/var/batchops/scripts/cosui/output.txt
sed -i '/Weekend/d' /prod/var/batchops/scripts/cosui/output.txt
sed -i '${/^$/d}' /prod/var/batchops/scripts/cosui/output.txt
sleep 5
while read line;do
echo "        <tr>" >>$cosui_html
echo "            <td >$(echo $line|awk -F ";" '{print $1}')</td>" >>$cosui_html
echo "            <td >$(echo $line|awk -F ";" '{print $2}')</td>" >>$cosui_html
echo "            <td >$(echo $line|awk -F ";" '{print $3}')</td>" >>$cosui_html
echo "            <td >$(echo $line|awk -F ";" '{print $4}')</td>" >>$cosui_html
echo "            <td >$(echo $line|awk -F ";" '{print $5}')</td>" >>$cosui_html
echo "        </tr>" >>$cosui_html
done < /prod/var/batchops/scripts/cosui/output.txt

echo "    </table>" >>$cosui_html
echo "  <br>" >>$cosui_html
echo "  <p> Thanks<br>Oracle Batchops Team </p>" >>$cosui_html
echo "  <br>" >>$cosui_html
echo "  <br>" >>$cosui_html
echo "  <p><strong>Note:</strong>This is an auto-generated email. Please do not reply. If any query, contact to 'gdch_lmsbatchops_in_grp@oracle.com'.</p>" >>$cosui_html
echo "</body>" >>$cosui_html
echo "</html>" >>$cosui_html

/usr/sbin/sendmail -t < $cosui_html

exit $?

