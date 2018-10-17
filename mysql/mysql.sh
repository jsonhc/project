# 开启慢sql查询
mysql> SET GLOBAL slow_query_log = 1;      # 重启mysql服务会失效,写进到配置文件
mysql> SHOW VARIABLES LIKE '%slow_query_log%';    # 查看是否修改成功
mysql> SHOW VARIABLES LIKE '%slow_query_log%';  # 默认sql执行时长超过10s才定义为slow query
mysql> set global long_query_time=3;    # 修改sql执行时长超过3s就定义为慢查询,打开mysql另外一个session才会生效
打开另一个session执行:
mysql> select sleep(4);   # 测试slow query是否设置成功
mysql> SHOW GLOBAL STATUS LIKE '%Slow_queries%';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Slow_queries  | 1     |
+---------------+-------+
1 row in set (0.00 sec)

在日志中查询:
[root@master mysql]# cat master-slow.log 
/usr/sbin/mysqld, Version: 5.7.23 (MySQL Community Server (GPL)). started with:
Tcp port: 3306  Unix socket: /var/lib/mysql/mysql.sock
Time                 Id Command    Argument
# Time: 2018-10-16T14:22:49.811637Z
# User@Host: root[root] @ localhost []  Id:     5
# Query_time: 5.000858  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 0
SET timestamp=1539699769;
select sleep(5);
[root@master mysql]# pwd
/var/lib/mysql

将慢查询设置写进到配置文件中:
[root@master mysql]# grep "slow*" -A 5 /etc/my.cnf
# for slow query
slow_query_log = 1;
slow_query_log_file=/var/lib/mysql/master-slow.log
long_query_time=3;
log_output=FILE

修改上面的设置不需要进行重启mysql服务,可以直接生效

搭配日志分析工具mysqldumpslow
mysqldumpslow -s r -t 10 /var/lib/mysql/atguigu-slow.log     #得到返回记录集最多的10个SQL
mysqldumpslow -s c -t 10 /var/lib/mysql/atguigu-slow.log     #得到访问次数最多的10个SQL
mysqldumpslow -s t -t 10 -g "LEFT JOIN" /var/lib/mysql/atguigu-slow.log   #得到按照时间排序的前10条里面含有左连接的查询语句
mysqldumpslow -s r -t 10 /var/lib/mysql/atguigu-slow.log | more      #结合| more使用，防止爆屏情况

