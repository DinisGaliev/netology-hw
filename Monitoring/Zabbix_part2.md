# Домашнее задание к занятию «Система мониторинга Zabbix. Часть 2» Галиев Д.Ф.

 ---

## Задание 1
Создайте свой шаблон, в котором будут элементы данных, мониторящие загрузку CPU и RAM хоста.

### Решение 1

![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part2_1.png)
 ---

## Задание 2
Добавьте в Zabbix два хоста и задайте им имена <фамилия и инициалы-1> и <фамилия и инициалы-2>. Например: ivanovii-1 и ivanovii-2.

## Задание 3
Привяжите созданный шаблон к двум хостам. Также привяжите к обоим хостам шаблон Linux by Zabbix Agent.

### Решение 2;3:

![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part2_2.png)
 
 ---

## Задание 4
Создайте свой кастомный дашборд.

### Решение 4

![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part2_4.png)

 ---

## Задание 5* со звёздочкой
Создайте карту и расположите на ней два своих хоста.

### Решение 5

![alt text](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part2_5.png)

 ---

## Задание 6* со звёздочкой
Создайте UserParameter на bash и прикрепите его к созданному вами ранее шаблону. Он должен вызывать скрипт, который:
- при получении 1 будет возвращать ваши ФИО,
- при получении 2 будет возвращать текущую дату.

Код скрипта:

#!/bin/bash

read a

if [[ "$a" -eq 1 ]]; then

    echo "Galiev Dinis"

elif [[ "$a" -eq 2 ]]; then

    echo $(date '+%Y-%m-%d')

else

    echo "I don't know what is it"

fi

---
