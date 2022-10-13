#!/bin/sh

DIR=$(cat /etc/redis/redis.conf |grep '^dir '|cut -d' ' -f2)

AOF=$(cat /etc/redis/redis.conf |grep 'appendonly '|cut -d' ' -f2)

BACKUP_FILE=$(date +%d-%m-%y)

/etc/init.d/redis-server stop

RDB=~/backup/redis


if [ ! -d "$RDB" ]; then
      mkdir "$RDB"
fi

aws s3 cp s3://portwestredisdbbackup/"$BACKUP_FILE"/dump_"$BACKUP_FILE".rdb  "$RDB"/

if [ "$AOF" = "no" ]; then
  cp "$DIR"/dump.rdb "$DIR"/dump.rdb.bak
  rm -f "$DIR"/dump.rdb
  cp $RDB "$DIR"/dump.rdb

  chown redis:redis "$DIR"/dump.rdb

  /etc/init.d/redis-server start
else
  cp "$DIR"/dump.rdb "$DIR"/dump.rdb.bak
  rm -f "$DIR"/dump.rdb "$DIR"/appendonly.aof

  cp /backup/redis/$RDB "$DIR"/dump.rdb

  chown redis:redis "$DIR"/dump.rdb

  sed -i "s/appendonly yes/appendonly no/g" /etc/redis/redis.conf

  /etc/init.d/redis-server start

  redis-cli BGREWRITEAOF

  RIP="aof_rewrite_in_progress:1"

  while [ RIP = "aof_rewrite_in_progress:1" ]; do
    RIP=$(redis-cli info | grep aof_rewrite_in_progress)
  done

  /etc/init.d/redis-server stop

  sed -i "s/appendonly no/appendonly yes/g" /etc/redis/redis.conf

  /etc/init.d/redis-server start
fi
