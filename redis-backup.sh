#!/bin/sh
    AUTHPASS=$1
    #Redis_IP=$2
    echo "$AUTHPASS"
    #echo "$Redis_IP"
    DIR=$(date +%d-%m-%y)
    DEST=~/redis_backups

    if [ ! -d "$DEST" ]; then
      mkdir "$DEST"
    fi
    REDISCONFIGDIR=/var/lib/redis
    echo auth $AUTHPASS | redis-cli
    if [ $? -eq 0 ];then
      echo $REDISCONFIGDIR
      echo $i | redis-cli <<- EOF
                                auth $AUTHPASS
                                config set requirepass $AUTHPASS
                                bgsave
EOF
    wait $i
    fi
    cp "$REDISCONFIGDIR"/dump.rdb "$DEST"/dump."$DIR".rdb
    aws s3 cp "$DEST"/dump."$DIR".rdb s3://portwestredisdbbackup/"$DIR"/dump_"$DIR".rdb

