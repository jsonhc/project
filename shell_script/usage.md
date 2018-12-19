## usage for shell
### rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm 2>/dev/null &>/dev/null 完全不输出
### [root@zabbix-server tmp]# cat usage_if.sh 
### #!/bin/bash
### res=$1
### if [[ $res -eq 1 ]];then
###     echo "OK"
### elif [[ $res -eq 0 ]];then 
###     echo "0"
### else
###     exit 1
### fi
### 
### [root@aliyun grep]# cat arr.sh
### #!/bin/bash
### 
### arr=("a", "b", "c")
### echo "arr includes " ${arr[@]}
### echo "arr includes " ${arr[*]}    
### #${arr[@]}与${arr[*]}同等
### echo "the length of arr is " ${#arr[*]}
### echo "the length of arr is " ${#arr[@]}
### 
### for i in ${arr[@]};
### do
###     echo $i
### done
### sh arr.sh
### arr includes  a, b, c
### arr includes  a, b, c
### the length of arr is  3
### the length of arr is  3
### a,
### b,
### c,
