NR：表示行数
NF：表示列数
$NR：表示行数的参数
$NF：表示最后一列的所有参数


#打印第一个参数和第二个
[root@aliyun awk_demo]# cat emp.txt |awk '{print $1;print $2}'
Beth
4.00

[root@aliyun awk_demo]# cat emp.txt |awk '{print $1"\n"$2}'
Beth
4.00

#当行数大于2，打印第一列参数
[root@aliyun awk_demo]# cat emp.txt |awk '{if(NR>=2){print $1}}'
Dan
kathy
Mark
Mary
Susie

#当第三列参数大于0，将第一列参数打印出来
[root@aliyun awk_demo]# cat emp.txt |awk '$3>0{print $1}'
kathy
Mark
Mary
Susie

#awk结合if用法
[root@aliyun awk_demo]# cat emp.txt |awk '{if($3>0){print $1}}'
kathy
Mark
Mary
Susie
[root@aliyun awk_demo]# cat emp.txt |awk '{if($3>0)print $1}'
kathy
Mark
Mary
Susie

#计算一列的总和
[root@aliyun awk_demo]# cat emp.txt |awk '{total=total+$2}END{print total}'
26.5

#结合if/else用法
[root@aliyun awk_demo]# cat emp.txt |awk '{if($2>5)print $2;else print $3}'

#结合变量用法
[root@aliyun awk_demo]# cat emp.txt |awk 'v=100{if($2>5)print v}'

#忽略大小写
[root@aliyun awk_demo]# cat emp.txt |awk '{IGNORECASE=1} /beth/'
Beth	4.00	0

#增加一列
[root@aliyun awk_demo]# cat emp.txt |awk '{$4=$2+$3}{print}'
[root@aliyun awk_demo]# cat emp.txt |awk '{$4="hello"}{print}'
[root@aliyun awk_demo]# cat emp.txt |awk '{$3=$3+1}{print}'   #第三列参数都增加1

[root@aliyun awk_demo]# cat emp.txt |awk '{if($NF==0) $NF="hello"}{print}'
Beth 4.00 hello
Dan 3.75 hello
kathy	4.00	10

[root@aliyun awk_demo]# cat emp.txt |awk '{if($NF==0) $NF="hello"}{if($NF==10) $NF="ok";if($NF==20) $NF="false"}{print}'

#将文件中的某一列添加到另一个文件中的第一列
[root@aliyun awk_demo]# awk '{print $0}' emp.txt | paste - emp1.txt   # 将emp.txt的全部数据添加到emp1.txt文件的第一列

#打印全部数据
[root@aliyun awk_demo]# cat emp.txt |awk '1'
[root@aliyun awk_demo]# cat emp.txt |awk '{print $0}'
[root@aliyun awk_demo]# cat emp.txt |awk '{print}'
