# 参考文档：https://tecadmin.net/install-zabbix-network-monitoring-on-centos-rhel-and-fedora/
# install environment
yum install httpd httpd-devel
mkdir -p /data/mysql5.7
docker run -d --name=mysql5.7 -p3306:3306 -v /data/mysql5.7:/var/lib/mysql mysql:5.7-myself
yum install php php-devel php-bcmath  php-pear php-gd php-mbstring php-mysql php-xml

systemctl start httpd

# CentOS/RHEL 7:
rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

yum install zabbix-server-mysql zabbix-web-mysql zabbix-proxy-mysql

# config /etc/httpd/conf.d/zabbix.conf for date.timezone
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Shanghai/g' /etc/httpd/conf.d/zabbix.conf

systemctl restart httpd

# 进入到容器进行授权
# docker exec -it mysql5.7 bash
root@5aa0a0895387:/# mysql -hlocalhost -uroot -predhat
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
mysql> flush privileges;

mysql -uroot -p -h127.0.0.1    # yum install -y mariadb
mysql> CREATE DATABASE zabbixdb CHARACTER SET UTF8;
mysql> GRANT ALL PRIVILEGES on zabbixdb.* to zabbix@localhost IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON zabbixdb.* TO 'zabbix'@'%' IDENTIFIED BY 'redhat';
mysql> FLUSH PRIVILEGES;
mysql> quit

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uroot -p zabbixdb
zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uroot -p zabbixdb

# config /etc/zabbix/zabbix_server.conf for zabbixdb
DBHost=127.0.0.1
DBName=zabbixdb
DBUser=zabbix
DBPassword=password

systemctl start zabbix-server

# config zabbix 
http://39.106.219.238/zabbix/

# zabbix user and zabbix password
Username:  admin
Password:  zabbix


# zabbix-server启动不成功排查：
查看日志：/var/log/zabbix/zabbix_server.log
报错1：zabbix_server [12708]: cannot open log: cannot create semaphore set: [28] No space left on device
解决：
[root@aliyun zabbix]# cat /proc/sys/kernel/sem
250	32000	32	128
# vim /etc/sysctl.conf 新增下面一行：
kernel.sem = 500  64000  64  256
# sysctl -p

报错2：zabbix-server.service: main process exited, code=exited, status=1/FAILURE
解决：
降级gnutls
rpm -Uvh --force  gnutls-3.1.18-8.el7.x86_64.rpm
# rpm -Uvh --force gnutls-3.1.18-8.el7.x86_64.rpm


zabbix_server服务监听在10051端口上
