#!/bin/bash

# Параметры веб-сервера
server="192.168.0.10"
port=80

# Проверка доступности порта
nc -z -w5 $server $port
if [ $? -eq 0 ]; then
echo "$port $server the server is available"
else
echo "$port $server the server is not available"
exit 1
fi

# Проверка существования файла index.html
if curl --output /dev/null --silent --head --fail "http://$server/index.html"; then
echo "fail index.html exist in the root  directory of the $server"
else
echo "fail index.html does not exist in the root  directory of the  $server"
fi

