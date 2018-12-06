# -n1
[root@aliyun ~]# echo "1 2 3 4"|xargs -n1
1
2
3
4

[root@aliyun ~]# echo "1 2 3 4"|xargs 
1 2 3 4
[root@aliyun ~]# echo "1 2 3 4"|xargs -n2
1 2
3 4

[root@aliyun ~]# find ./ -maxdepth 1 -name "test.tx*"|xargs -n1 du -sh 
0	./test.txt
[root@aliyun ~]# find ./ -maxdepth 1 -name "test.tx*"|xargs -i du -sh {} 
0	./test.txt

[root@aliyun ~]# find ./ -name "test.tx*"|xargs -n1 du -sh 
0	./test.txt
4.0K	./script/test.txt
4.0K	./script/data/test.txt
[root@aliyun ~]# find ./ -name "test.tx*"|xargs du -sh 
0	./test.txt
4.0K	./script/test.txt
4.0K	./script/data/test.txt
[root@aliyun ~]# find ./ -name "test.tx*"|xargs -i du -sh {} 
0	./test.txt
4.0K	./script/test.txt
4.0K	./script/data/test.txt


