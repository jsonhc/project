# ERROR 1044 (42000): Access denied for user 'root'@'%' to database 'zabbixdb'

# 该环境是docker启动的mysql镜像实例mysql5.7

# 利用该环境进行给zabbix用户授权时出现上面报错：
# 下面时解决的办法：
MySQL [(none)]> select current_user() from dual;
+----------------+
| current_user() |
+----------------+
| root@%         |
+----------------+
查询当前给zabbix用户授权的账号以及权限：
MySQL [(none)]> select host,user from mysql.user where user='root';
+-----------+------+
| host      | user |
+-----------+------+
| %         | root |
| localhost | root |
+-----------+------+
MySQL [(none)]> show grants for root@localhost
    -> ;
+---------------------------------------------------------------------+
| Grants for root@localhost                                           |
+---------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION |
| GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION        |
+---------------------------------------------------------------------+
MySQL [(none)]> show grants for root@'%';
+-------------------------------------------+
| Grants for root@%                         |
+-------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' |
+-------------------------------------------+

由上面信息可以看出，'root'@'%'这个账号没有WITH GRANT OPTION这个权限，所以不能授权到zabbix账号，所以会报错
现在使用root@localhost这个账号登录，给'root'@'%'这个账号授权WITH GRANT OPTION权限：
root@f0467d2a95a2:/# mysql -hlocalhost -uroot -predhat
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
mysql> flush privileges;

[root@aliyun ~]# mysql -h127.0.0.1 -uroot -predhat
MySQL [(none)]> show grants for root@'%';
+-------------------------------------------------------------+
| Grants for root@%                                           |
+-------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION |
+-------------------------------------------------------------+
MySQL [(none)]> GRANT ALL PRIVILEGES on zabbixdb.* to zabbix@localhost IDENTIFIED BY 'password';
MySQL [(none)]> flush privileges;


