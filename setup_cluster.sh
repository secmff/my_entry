#!/bin/bash

# the redis-trib create script doesn't handle multiple machines right. It
# will happily create the slave on the same server as the master
# hence the extra code
echo yes | /opt/redis-src/src/redis-trib.rb create \
    192.168.33.10:6379 192.168.33.11:6379 192.168.33.12:6379

masters=$(/opt/redis-src/src/redis-trib.rb check 192.168.33.10:6379 | \
    awk '$1 == "M:" {print $3,$2}' | sort | awk '{print $2}')

slaves[1]=192.168.33.11:6380
slaves[2]=192.168.33.12:6380
slaves[3]=192.168.33.10:6380

count=1
for master in ${masters}; do
    /opt/redis-src/src/redis-trib.rb add-node --slave --master-id ${master} \
	${slaves[$count]} 192.168.33.10:6379
    count=$(( $count + 1 ))
done



