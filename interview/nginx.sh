nginx常见负载均衡算法:
    1:轮询,默认的算法,健康检查超时都会剔除后端服务器
    2:weight,加权轮询
    3:ip_hash,每一个源ip访问都固定到一个后端服务器,可以解决session的问题
    4:url_hash,根据请求的相同的url固定分配给后端的服务器
    5:fair,按后端服务器的响应时间来分配请求,响应时间短的优先分配
    upstream myapp {
        server1 192.168.1.1 8080;
	server2 192.168.1.2 8080;
    }
    负载均衡需要用到proxy_pass和upstream两个模块,还需要加上上面的一些调度算法

nginx做反向代理
    使用的主要是proxy_pass模块
    proxy_pass http://myapp;

nginx做动静分离
    缩短用户访问的时间

nginx虚拟主机:
    将两个域名部署在同一台服务器上,部署不同的端口提供服务
    server {
        listen 80;
        server_name www.aaa.com; # www.aaa.com域名
        location / {
            proxy_pass http://localhost:8080; # 对应端口号8080
        }
    }
    server {
        listen 80;
        server_name www.bbb.com; # www.bbb.com域名
        location / {
            proxy_pass http://localhost:8081; # 对应端口号8081
        }
    }

404页面不存在，403权限不足拒绝提供服务，500服务器内部错误，502连接超时，503 客户端到服务器，但是服务器没有响应，301和302基本属于一种情况，rewrite地址重写，falg标记的原因

# 返回给客户端限流,限制客户端下载速度
limit_rate rate;   # Limits the rate of response transmission to a client.
limit_rate_after size; # Sets the initial amount after which the further transmission of a response to a client will be rate limited.
	# 当发送给客户端的响应长度超过指定的值才给限制速度
    location /flv/ {
        flv;
        limit_rate_after 500k; # 设置初始值,当响应给客户端的速度超过500k,那么限制速度为50k
        limit_rate       50k;
    }

# nginx可以使用ngx_http_limit_req_module模块的limit_req_zone指令进行限流访问，防止用户恶意攻击刷爆服务器。
# nginx对同一源ip进行限流
http {
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
    server {
        location /search/ {
            limit_req zone=one burst=5;
        }
    }
}
$binary_remote_addr是$remote_addr（客户端IP）的二进制格式
上面是对请求的path路径/search/进行限流
其中zone=one和前面的定义对应,burst缓冲队列的长度,limit_req zone=one burst=5  nodelay; 如果设置了nodelay表示不延迟,即马上处理,多个请求来了也是马上处理
burst=5 表示最大延迟请求数量不大于5。  如果太过多的请求被限制延迟是不需要的 ，这时需要使用nodelay参数，服务器会立刻返回503状态码。
加上 nodelay之后超过 burst大小的请求就会直接返回503，如果没有该字段会造成大量的tcp连接请求等待。

这里用到的$binary_remote_addr是在客户端和nginx之间没有代理层的情况。如果你在nginx之前配置了CDN，那么$binary_remote_addr的值就是CDN的IP地址。这样限流的话就不对了。需要获取到用户的真实IP进行限流。


# limit_req_conn 用来限制同一时间连接数，即并发限制
# http字段设置如下
limit_conn_log_level error;
limit_conn_status 503;
limit_conn_zone $binary_remote_addr zone=one:10m;   # 表示设置了名为"one"或"perserver"的存储区，大小为10兆字节
limit_conn_zone $server_name zone=perserver:10m;
# server字段进行设置如下
limit_conn  one  100表示最大并发连接数100
limit_conn perserver 1000表示该服务提供的总连接数不得超过1000,超过请求的会被拒绝


Nginx 从1.9.0开始发布ngx_stream_core_module模块，该模块支持tcp代理及负载均衡。
ngx_stream_core_module这个模块并不会默认启用，需要在编译时通过指定--with-stream参数来激活这个模块。
$ yum -y install proc* openssl* pcre*
$ wget http://nginx.org/download/nginx-1.9.4.tar.gz
$ tar zxvf nginx-1.9.4.tar.gz
$ cd nginx-1.9.4
$ ./configure  --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-mail --with-mail_ssl_module --with-file-aio --with-ipv6 --with-http_spdy_module 
$ make
$ make install

实例一：测试MYSQL负载均衡
stream模块必需在nginx.conf中配置
$ mv nginx.conf{,.bak}
$ vim  /etc/nginx/nginx.conf
worker_processes auto;
events {
    worker_connections  1024;
}
error_log /var/log/nginx_error.log info;

stream {
    upstream mysqld {
        hash $remote_addr consistent;
        server 192.168.1.42:3306 weight=5 max_fails=1 fail_timeout=10s;
        server 192.168.1.43:3306 weight=5 max_fails=1 fail_timeout=10s;
    }

    server {
        listen 3306;
        proxy_connect_timeout 1s;
        proxy_timeout 3s;
        proxy_pass mysqld;
    }

}

#静态分离:
location / {
    proxy_next_upstream http_502 http_504 error timeout invalid_header;
    proxy_pass http://mycluster;
    # 真实的客户端IP
    proxy_set_header   X-Real-IP        $remote_addr; 
    # 请求头中Host信息
    proxy_set_header   Host             $host; 
    # 代理路由信息，此处取IP有安全隐患
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    # 真实的用户访问协议
    proxy_set_header   X-Forwarded-Proto $scheme;
}

#静态文件交给nginx处理
location ~ .*\.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
{
    root /usr/local/webapps;
    expires 30d;
}
#静态文件交给nginx处理
location ~ .*\.(js|css)?$
{
    root /usr/local/webapps;
    expires 1h;
}

root /usr/local/webapps; 这段代码的意思是指定Nginx访问的目录，即静态资源所在的目录。
expires 30d; 指定这些资源文件在客户端浏览器的缓存时间。30d指的是30天，1h指的是1小时。

location ~ .*\.(js|css)?$
{
    root /usr/local/webapps;
    expires 1h;
}
