#!/bin/bash
echo '========================================================================'
echo 'Starting...!'
echo '========================================================================'
cd /usr/local/nginx/sbin/
./nginx
tail -f /usr/local/nginx/logs/access.log
