# CentOS/RHEL 7:
rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

# yum install zabbix zabbix-agent
报错：
Transaction check error:
  file /etc/zabbix/zabbix_agentd.conf conflicts between attempted installs of zabbix-agent-3.4.15-1.el7.x86_64 and zabbix30-3.0.22-2.el7.x86_64

解决办法：禁用epel源
# cd /etc/yum.repos.d/
# mv epel-Aliyun.repo epel-Aliyun.repo.bak
# yum install zabbix zabbix-agent

# config /etc/zabbix/zabbix_agentd.conf
Server=127.0.0.1
Hostname=aliyun

# systemctl start zabbix-agent
# systemctl status zabbix-agent

zabbix-agent服务监听在10050端口上

查看报错信息：
# tail -f /var/log/zabbix/zabbix_agentd.log

