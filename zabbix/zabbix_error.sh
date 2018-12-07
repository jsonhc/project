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

[root@aliyun ~]# systemctl start zabbix-agent
Job for zabbix-agent.service failed because the control process exited with error code. See "systemctl status zabbix-agent.service" and "journalctl -xe" for details.
[root@aliyun ~]# journalctl -xe
-- Unit zabbix-agent.service has failed.
-- 
-- The result is failed.
Dec 07 17:07:44 aliyun zabbix_agentd[13696]: zabbix_agentd [13696]: /usr/local/etc/zabbix_agentd.conf.d: [2] No such file or director
Dec 07 17:07:44 aliyun systemd[1]: Unit zabbix-agent.service entered failed state.
修改了配置文件，然后/usr/local/etc/zabbix_agentd.conf.d这个文件不存在所以报错
# mkdir /usr/local/etc/zabbix_agentd.conf.d

# systemctl start zabbix-agent
