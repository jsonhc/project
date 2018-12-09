import smtplib
from email.mime.text import MIMEText
import sys

from_mail = "json_hc@163.com"
mail_passwd = "HHq123456"


def send_mail(to_mail, subject, content):
    msg = MIMEText(content, 'plain', 'utf-8')
    msg['Subject'] = subject
    msg['From'] = from_mail
    msg['To'] = to_mail
    try:
        s = smtplib.SMTP()
        s.connect('smtp.163.com')
        s.login(from_mail, mail_passwd)
        s.sendmail(from_mail, to_mail, msg.as_string())
        print("OK")
    except Exception as e:
        print(e)
    finally:
        s.quit()


if __name__ == '__main__':
    send_mail(sys.argv[1], sys.argv[2], sys.argv[3])

# [root@zabbix-server zabbix_python_demo]# python send_mail.py 346165580@qq.com "critical" "this is a mail"
# OK
# [root@zabbix-server zabbix_python_demo]# python send_mail.py 346165580@qq.com test "this is a mail"
# (554, 'DT:SPM 163 smtp10,
# dont use test
