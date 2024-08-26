# Домашнее задание к занятию 2 «Кластеризация и балансировка нагрузки» Галиев Д.Ф.
---
## Задание 1
- Запустите два simple python сервера на своей виртуальной машине на разных портах
- Установите и настройте HAProxy, воспользуйтесь материалами к лекции по [ссылке](2/)
- Настройте балансировку Round-robin на 4 уровне.
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

### Решение 1

[файл конфигурации HAProxy](HAProxy/haproxy_1.cfg)

- Запустил два simple python сервера:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy1.1.png)

- Балансировка Round-robin на 4 уровне:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy1.2.png)

- Страница статистики:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy1.3.png)


---

## Задание 2
- Запустите три simple python сервера на своей виртуальной машине на разных портах
- Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
- HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

### Решение 2

[файл конфигурации HAProxy](HAProxy/haproxy_2.cfg)

 Запустил три simple python сервера:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy2.1.png)

- Балансировка Round-robin на 7 уровне. Балансировка только http-трафика, который адресован домену example.local:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy2.2.png)

- Страница статистики:

![image](https://github.com/DinisGaliev/netology-hw/blob/main/HAProxy/img/HAProxy2.3.png)

---

