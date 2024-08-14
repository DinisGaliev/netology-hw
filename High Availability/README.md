# Домашнее задание к занятию 1 «Disaster recovery и Keepalived» - Галиев Д.Ф.

## Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

### Решение 1

Скриншот процесса настройки маршрутизатора:
![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/High%20Availability/img/Keepalived_1.1.png)

Скриншот прохождения пакета:
![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/High%20Availability/img/Keepalived_1.2.png)

Получившаяся схема Cisco Packet Tracer [схема](https://github.com/DinisGaliev/netology-hw/blob/main/High%20Availability/hsrp_advanced_DiGaliev.pkt)

------


## Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

### Решение 2

Скрипт

``````
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
```````
Конфигурационный файл

``````
vrrp_script check_apache2 {
        script "/home/digaliev/apache2-server.sh"
        interval 3
}

vrrp_instance VI_1 {
        state MASTER
        interface enp0s8
        virtual_router_id 15
        priority 255
        advert_int 1

        virtual_ipaddress {
              192.168.0.20/24
        }
        track_script {
        check_apache2
        }
}
``````
Скриншот работы основного web сервера apache2 на плавающем ip адресе
![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/High%20Availability/img/Keepalived_2.1.png)

Скриншот с демонстрацией переезда плавающего ip на резервный web сервер apache2
![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/High%20Availability/img/Keepalived_2.2.png)

------
