# 查看某一个进程所打开的文件个数
# ps -ef|grep    获得服务的进程id，pid
# lsof -p pid|wc -l   通过pid来查询打开的文件数

# 修改文件数：
打开文件/etc/security/limits.conf文件,追加下面两行内容: * soft nofile 65535 * hard nofile 65535

# 统计进程所打开的文件数
# lsof -n |awk '{print $2}'|sort|uniq -c |sort -nr    # 第二列就是pid，进行排序并统计个数，并且以多数排序

# 查看系统默认能打开的最大文件数
# cat /proc/sys/fs/file-max

# 修改这个值
# echo 1000000 > /proc/sys/fs/file-max  # 临时修改这个参数

# sysctl -w net.ipv4.ip_forward=1    # 临时修改这个参数

# 永久生效这个参数
# sysctl -p /etc/sysctl.conf 
