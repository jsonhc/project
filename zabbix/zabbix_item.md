# 查看系统模板下面的监控项
## 搜索Template OS Linux，找到item，然后找到system.swap.size[,free]这个监控项
### 手动获取这个监控项的值：
### yum install zabbix_get -y
### [root@aliyun ~]# zabbix_get -s 172.16.23.131 -p 10050 -k "system.swap.size[,free]"
### 0
## 自定义创建item
### 打开zabbix-agent这个服务下配置文件：/etc/zabbix/zabbix_agentd.conf下面的配置：
### Include=/usr/local/etc/zabbix_agentd.conf.d/      没有这个文件就创建
### 打开服务器端的配置文件：/etc/zabbix/zabbix_server.conf
### AlertScriptsPath=/usr/lib/zabbix/alertscripts     将自定义item的脚本放在这里
### 将这个/usr/local/etc/zabbix_agentd.conf.d目录下面创建：userparameter_script.conf
### 下面是一个案例：UserParameter=<key>,<command>
### UserParameter=script.getQueryCountFromMysql.py,/usr/lib/zabbix/alertscripts/getQueryCountFromMysql.py

### 注意：/usr/lib/zabbix/alertscripts/getQueryCountFromMysql.py这个脚本一定要有执行权限chmod +x /usr/lib/zabbix/alertscripts/getQueryCountFromMysql.py

### 手动测试拿到相应的值：（检测格式zabbix_get -s host -k key）
### zabbix_get -s 172.16.23.131 -k script.getQueryCountFromMysql.py

### 然后在zabbix页面进行自定义item配置：

