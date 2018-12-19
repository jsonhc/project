# install ansible
cd /etc/yum.repos.d
wget http://mirrors.neusoft.edu.cn/epel/epel-release-latest-6.noarch.rpm
rpm -ivh epel-release-latest-6.noarch.rpm
yum install ansible -y

# config hosts
[root@master ansible]# cat hosts|egrep -v "^#|^$"
[nodes]
172.16.23.129
172.16.23.130
[all_nodes]
172.16.23.128
172.16.23.129
172.16.23.130

# copy模块复制
# ansible nodes -m copy -a "src=/root/init_centos7.sh dest=/root/init_centos7.sh"

# shell模块执行命令
# ansible nodes -m shell -a "ls -l /root/init_centos7.sh"

# get_url代替curl命令
# ansible nodes -m get_url -a "url=http://172.16.23.132/index.html dest=/tmp"
# ansible nodes -m get_url -a "url=http://172.16.23.132/index.html dest=/tmp"|grep status_code    直接获取返回状态码

# 获取ip信息
# # ansible nodes -m shell -a "ip a|grep ens33|grep -Po '(?<=inet ).*(?=\/)'"


# 查看ansible上节点系统变量
[root@master vars]# ansible nodes -m setup -a "filter=ansible_all_ipv4_addresses"
172.16.23.129 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.16.23.129"
        ]
    },
    "changed": false
}
172.16.23.130 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.16.23.130"
        ]
    },
    "changed": false
}
[root@master vars]# ansible nodes -m setup -a "filter=ansible_hostname"
172.16.23.130 | SUCCESS => {
    "ansible_facts": {
        "ansible_hostname": "localhost"
    },
    "changed": false
}
172.16.23.129 | SUCCESS => {
    "ansible_facts": {
        "ansible_hostname": "localhost"
    },
    "changed": false
}
[root@master vars]# ansible nodes -m setup|grep address
[root@master vars]# ansible nodes -m setup|grep hostname
        "ansible_hostname": "localhost",
        "ansible_hostname": "localhost",


由于ansible_all_ipv4_addresses的结果是一个列表所以
[root@master tasks]# cat main.yaml
- name: execute system init script to nodes
  shell: /bin/bash /root/init_centos7.sh node1
  when: ansible_all_ipv4_addresses == "172.16.23.129"     # 这样进行判断是不会成功的
需要将上面的判断条件改为如下:
[root@master tasks]# cat main.yaml
- name: execute system init script to nodes
  shell: /bin/bash /root/init_centos7.sh node1
  when: inventory_hostname == "172.16.23.129"

- name: execute system init script to nodes
  shell: /bin/bash /root/init_centos7.sh node2
  when: inventory_hostname == "172.16.23.130"
上面才是真正的按照node的ip来进行执行init脚本

当然可以自定义变量:
[root@master tasks]# cat main.yaml
- name: execute system init script to nodes
  shell: echo "node1"
  when: inventory_hostname == node1_ip

- name: execute system init script to nodes
  shell: echo "node2"
  when: inventory_hostname == node2_ip

- name: debug
  debug: msg:{{ ansible_all_ipv4_addresses }}
[root@master tasks]# cat ../vars/main.yaml
node1_ip: 172.16.23.129
node1_hostname: node1
node2_ip: 172.16.23.130
node2_hostname: node2

[root@master ansible]# cat hosts|egrep -v "^#|^$"
[nodes]
172.16.23.129
172.16.23.130

# 只针对某一个节点ip来进行,下面一定要按照格式all,而不是nodes
[root@master ansible]# ansible -i "172.16.23.129," all -m shell -a "hostname"
172.16.23.129 | CHANGED | rc=0 >>
node1

[root@master ansible]# ansible all -i 172.16.23.129, -m shell -a "hostname"
172.16.23.129 | CHANGED | rc=0 >>
node1

[root@master ansible]# ansible all -i 172.16.23.129,172.16.23.130 -m shell -a "hostname"
172.16.23.129 | CHANGED | rc=0 >>
node1

172.16.23.130 | CHANGED | rc=0 >>
node2

[root@master ansible]# ansible 172.16.23.129,172.16.23.130 -m shell -a "hostname"
172.16.23.130 | CHANGED | rc=0 >>
node2

172.16.23.129 | CHANGED | rc=0 >>
node1

[root@master ansible]# ansible 172.16.23.129 -m shell -a "hostname"
172.16.23.129 | CHANGED | rc=0 >>
node1

[root@master ~]# ansible nodes -m shell -a "hostname;ip a|grep ens33|grep -Po '(?<=inet ).*(?=\/)'"
172.16.23.129 | CHANGED | rc=0 >>
node1
172.16.23.129
172.16.23.132

172.16.23.130 | CHANGED | rc=0 >>
node2
172.16.23.130
