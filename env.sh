#!/bin/bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
#export PEM_FILE=""
#export USER=ubuntu
#export Redis_IP=
export Redis_Password=
export Bucket_name=redisdbbackup

# ssh to redis server and to take backup
./redis-backup.sh $Redis_Password







