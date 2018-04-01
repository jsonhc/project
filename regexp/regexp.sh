[root@VM_0_11_centos ~]# df | sed -n '/\/$/p'    # 将以/结尾的那一行打印出来 sed -n '//p'
/dev/vda1       51474024 6852520  42315428  14% /

[root@VM_0_11_centos ~]# df | sed -n '/\/$/p'|awk '{print $5}'|sed 's#%##g'   # 取出磁盘使用率
14


