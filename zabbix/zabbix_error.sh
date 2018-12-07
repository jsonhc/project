1、确保10051、10050开放了端口访问

2、-bash: zabbix_get: command not found
# yum list all |grep zabbix|grep get
# yum install zabbix-get

[root@aliyun yum.repos.d]# zabbix_get -s 39.106.219.238 -p 10050 -k "system.cpu.load[all,avg1]"
zabbix_get [13231]: Check access restrictions in Zabbix agent configuration
修改/etc/zabbix/zabbix_agentd.conf将Server从127.0.0.1改为39.106.219.238

# systemctl restart zabbix-agent
[root@aliyun yum.repos.d]# zabbix_get -s 39.106.219.238 -p 10050 -k "system.cpu.load[all,avg1]"
0.250000


