import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime, timedelta

def fetch_job_times_from_logfile_ccb(bizdates, list_all_jobs):
    adm_list = []
    for job in list_all_jobs:
        if job[0]=="ADM666-10ZU":
            filepath = "E:/git/time.log"
        elif job[0] == "OBI010-20AU":
            filepath = "E:/git/BI_LOGS/time.log"

        with open(filepath, 'r', encoding='ISO-8859-1') as file:
            for i in bizdates:
                file.seek(0)  
                for line in file:
                    fields = line.strip().split(';')
                    
                    try:
                        error=fields[5]
                    except Exception as e:
                        continue
        
                    if i == fields[0] and job[0] == fields[5]:
                        adm_data={}
                        adm_data["start_time"]=fields[1]
                        adm_data["job_name"]=fields[5]
                        adm_data["bizdate"]=i
                        adm_list.append(adm_data)
                    if i == fields[0] and job[1] == fields[5]:
                        adm_data={}
                        adm_data["end_time"]=fields[2]
                        adm_data["job_name"]=fields[5]
                        adm_data["bizdate"]=i
                        adm_list.append(adm_data)

    return adm_list

def get_biz_date():
    bizdates = []
    # Prepare the business dates
    today_date = datetime.today()
    start_date = today_date - timedelta(days=8)

    for i in range(7):
        bizdate_start = (start_date + timedelta(days=i))
        if bizdate_start.weekday() in [5, 6]:
            continue
        bizdates.append(bizdate_start.strftime('%Y-%m-%d'))

    return bizdates

def generate_html_table_with_bizdate(job_data):
    html = '<table border="1">\n'
    html += '  <tr>\n'
    headers = ['Bizdate', 'Debut CCB', 'Fin CCB', 'Debut BI', 'Fin BI']
    
    # Generate header row
    for header in headers:
        html += f'    <th>{header}</th>\n'
    html += '  </tr>\n'
    
    # Group data by job name
    adm_start = [(entry["bizdate"], entry["start_time"]) for entry in job_data if entry.get("job_name") == "ADM666-10ZU" and "start_time" in entry]
    tec_end = [(entry["bizdate"], entry["end_time"]) for entry in job_data if entry.get("job_name") == "TEC721-10AU" and "end_time" in entry]
    obi_start = [(entry["bizdate"], entry["start_time"]) for entry in job_data if entry.get("job_name") == "OBI010-20AU" and "start_time" in entry]
    odi_end = [(entry["bizdate"], entry["end_time"]) for entry in job_data if entry.get("job_name") == "ODI704-10AU" and "end_time" in entry]

    # Find the max length to iterate dynamically
    max_len = max(len(adm_start), len(tec_end), len(obi_start), len(odi_end))
    
    # Generate table rows
    for i in range(max_len):
        bizdate = adm_start[i][0] if i < len(adm_start) else tec_end[i][0] if i < len(tec_end) else ""
        html += '  <tr>\n'
        html += f'    <td>{bizdate}</td>\n'
        html += f'    <td>{adm_start[i][1] if i < len(adm_start) else ""}</td>\n'
        html += f'    <td>{tec_end[i][1] if i < len(tec_end) else ""}</td>\n'
        html += f'    <td>{obi_start[i][1] if i < len(obi_start) else ""}</td>\n'
        html += f'    <td>{odi_end[i][1] if i < len(odi_end) else ""}</td>\n'
        html += '  </tr>\n'
    
    html += '</table>'
    return html

def send_email_with_html_body(sender_email, receiver_email, subject, html_content, smtp_server, smtp_port, login, password):
    # Create the email object
    msg = MIMEMultipart('alternative')
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject

    # Attach the HTML content to the email body
    msg.attach(MIMEText(html_content, 'html'))

    # Connect to the SMTP server and send the email
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()  # Secure the connection
        server.login(login, password)
        server.sendmail(sender_email, receiver_email, msg.as_string())

# Variables
ccnb_jobs = ["ADM666-10ZU", "TEC721-10AU"]
bi_jobs = ["OBI010-20AU", "ODI704-10AU"]

list_all_jobs = [ccnb_jobs, bi_jobs]

#Fetching all the bizdate
bizdates = get_biz_date()

# print(job_data)
job_data = fetch_job_times_from_logfile_ccb(bizdates, list_all_jobs)

# Generate the dynamic HTML table
html_table = generate_html_table_with_bizdate(job_data)

# SMTP server information
smtp_server = 'smtp.gmail.com'  # For Gmail
smtp_port = 587
sender_email = 'onedummy500@gmail.com'
receiver_email = 'onedummy500@gmail.com'
subject = 'COSUI Weekly Report'

# Send the HTML table directly in the email body
send_email_with_html_body(sender_email, receiver_email, subject, html_table, smtp_server, smtp_port, sender_email, 'ejfnqdtnnodkcabm')