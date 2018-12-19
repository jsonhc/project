[root@VM_0_11_centos ~]# df | sed -n '/\/$/p'    # 将以/结尾的那一行打印出来 sed -n '//p'
/dev/vda1       51474024 6852520  42315428  14% /

[root@VM_0_11_centos ~]# df | sed -n '/\/$/p'|awk '{print $5}'|sed 's#%##g'   # 取出磁盘使用率
14

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh 
a1b2c

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po ".*(?=b)"
a1                     # -P:支持perl正则    -o:表示仅仅打印出匹配到的结果

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po ".*(?<=b)"
a1b

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(?<=b).*"
2c

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(?=b).*"
b2c

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ echo "Hello, my name is aming."|grep -Po "(?<=Hello, ).*(?= aming.)"
my name is


wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh
a1b2cbc

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(b).*\1"
b2cb
wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |egrep -o "(b).*\1"
b2cb                 # \1是括号(b)的分组,代替为这个括号内的内容

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(?P<var>c)b(?P=var)"
cbc                  # 将匹配的c作为var这个分组,后面引用var这个分组

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(?P<var>c)b\1"
cbc                  # 将匹配的c作为var这个分组,后面引用分组\1

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po ".*(?P<var>c)b\1"
a1b2cbc

wadeson@wadeson-Inspiron-7460:~/shell_demo/re$ cat re.sh |grep -Po "(\w)b\1"
cbc                  # 引用\w这个匹配到的分组

[root@aliyun grep]# cat access.log 
12/May/2018:12:19:45 GET

[root@aliyun grep]# cat access.log |grep -Po "12\/May\/2018(:\d{2}){3}"
12/May/2018:12:19:45

[root@aliyun grep]# cat access.log |grep -Po "\s.*(GET)"
 GET
[root@aliyun grep]# cat access.log |grep -Po ".*\s.*(GET)"
12/May/2018:12:19:45 GET             # \s是指空格字符

[root@aliyun grep]# cat access.log |grep -Po "12\/May\/2018(:\d+){3}"
12/May/2018:12:19:45

[root@aliyun grep]# cat access.log |grep -Po "12\/May\/2018(:)\d+\1"
12/May/2018:12:              # 将(:)冒号作为分组，\1引用前面定义得分组

[root@aliyun grep]# cat access.log 
12/May/2018:12:19:45 GET
12/May/2018:12:19:45GET
Iraq fighting

[root@aliyun grep]# cat access.log |grep -Po '.*\d{2}(?!\s)GET'
12/May/2018:12:19:45GET
