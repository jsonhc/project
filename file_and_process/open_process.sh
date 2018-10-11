# 查询僵尸进程
# ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'
[root@localhost root]# ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'
#如果有输出，就说明有僵尸进程
Z     5493  5525 [Xsession] <defunct>    # 僵尸进程带有defunct
清除上面的父进程5493才会彻底kill掉这个僵尸进程

# 查询僵尸进程是由什么进程造成的
# pstree -ap |grep defunct

# 查看系统的默认最大可以创建的进程数
# cat /proc/sys/kernel/pid_max

# 如果僵尸进程过多，导致进程数超过默认设置的数量，那么系统负载将会很高，造成系统访问慢，甚至可能宕机

# 修改进程数
ulimit -u 65535

# sysctl -w  kernel.pid_max=65535   # 或者临时修改该参数

# echo 65535 > /proc/sys/kernel/pid_max  # 或者临时修改该参数

# 永久生效这个参数
# sysctl -p /etc/sysctl.conf
