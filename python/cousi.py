from datetime import datetime,timedelta

#Variables
ccnb_jobs = ["ADM666-10ZU", "TEC721-10AU"]
bi_jobs = ["OBI010-10AU", "ODI704-10AU"]
bizdates=[]

def fetch_required_details_from_logfile (file_path,bizdates,ccnb_jobs):
     with open(file_path, 'r', encoding='ISO-8859-1') as file:
          for line in file:
                fileds=line.strip().split(';')
                if any(bizdate in fileds[0] for bizdate in bizdates):
                       if any(job in fileds[5] for job in ccnb_jobs):
                             print(fileds[0],fileds[1], fileds[2],fileds[4])

# Prepare the business dates
today_date=datetime.today()
start_date=today_date - timedelta(days=7)

for i in range(0,8):
     bizdate_start = (start_date + timedelta(days=i)).strftime('%Y-%m-%d')
     bizdates.append(bizdate_start)

# Call the function for the log file "E:/git/time.log"
file_path_time_log = "E:/git/time.log"
fetch_required_details_from_logfile(file_path_time_log, bizdates, ccnb_jobs)

# Call the function for the log file "E:/git/BI_LOGS/time.log"
file_path_bi_logs = "E:/git/BI_LOGS/time.log"
fetch_required_details_from_logfile(file_path_bi_logs, bizdates, bi_jobs)