1:zabbix_server
  hostname: zabbix_server
  install mysql
    wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
    rpm -ivh mysql57-community-release-el7-7.noarch.rpm
    yum install mysql-community-server
  rpm -ivh http://repo.webtatic.com/yum/el6/latest.rpm
  yum install httpd php56w php56w-gd php56w-mysql php56w-bcmath php56w-mbstring php56w-xml php56w-ldap


# install mysql5.7 for yum
# wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
# rpm -ivh mysql57-community-release-el7-7.noarch.rpm
# yum install mysql-community-server mysql
# systemctl start mysqld
# grep "password" /var/log/mysqld.log
    A temporary password is generated for root@localhost: oklzu!Mo/46W
# mysql -uroot -p
mysql> SET PASSWORD = PASSWORD('HHq123456*');
mysql> ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
mysql> flush privileges;

mysql> grant all privileges on *.* to root@"%" identified by "HHq123456*";
mysql> grant all privileges on *.* to root@"localhost" identified by "HHq123456*";
mysql> flush privileges;


# 忘记密码时，可用如下方法重置：
service mysqld stop
mysqld_safe --user=root --skip-grant-tables --skip-networking &
mysql -u root
# 进入MySQL后
use mysql;
update user set password=password("new_password") where user="root";
flush privileges;

# 一些配置文件路径
ls -l /etc/my.cnf
ls -l /var/lib/mysql
ls -l /var/log/mysqld.log
ls -l /usr/lib/systemd/system/mysql.service
ls -l /var/run/mysqld/mysqld.pid

