#!/bin/bash

# to judge if there is reids image in local repository
ret=`docker images|grep redis`
if [ $? -eq 0 ];then
    docker run --name redis-6380 -p 6380:6379 -d redis
    docker run --name redis-6381 -p 6381:6379 -d redis
    docker run --name redis-6382 -p 6382:6379 -d redis
else
    docker pull redis
    docker run --name redis-6380 -p 6380:6379 -d redis
    docker run --name redis-6381 -p 6381:6379 -d redis
    docker run --name redis-6382 -p 6382:6379 -d redis
fi
