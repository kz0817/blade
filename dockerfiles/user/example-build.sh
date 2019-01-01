#!/bin/sh

user_line=`cat /etc/passwd | grep ^$USER:`
uid=`echo $user_line | awk '{ print $3 }' FS=:`
gid=`echo $user_line | awk '{ print $4 }' FS=:`
docker build ./ -t user-name-ex --build-arg USER=$USER --build-arg UID=$uid --build-arg GID=$gid
