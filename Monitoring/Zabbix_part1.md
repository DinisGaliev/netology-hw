# Домашнее задание к занятию "Система мониторинга Zabbix" - `Галиев Д.Ф.`

---
## Задание 1 

Установите Zabbix Server с веб-интерфейсом.

### Решение 1

#### 1. Cкриншот авторизации:

![Скриншот настройки проекта](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part1_1.1.png)

#### 2. Используемые команды при инсталяции:
1.  Установка базы данных PostgreSQL:
apt install postgresql
2. Установка и распаковка репозитория:
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu22.04_all.deb
dpkg -i zabbix-release_7.0-2+ubuntu22.04_all.deb
apt update
3. Установка Zabbix сервер, веб-интерфейс и агента:
apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
4. Создание базы данных и пользователя:
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
5. Импорт начальной схемы и данных на хост Zabbix сервера:
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
6. Настройка пароля для базы данных
Редактируем файл /etc/zabbix/zabbix_server.conf
nano /etc/zabbix/zabbix_server.conf далее в файле напротив DBPassword= указываем наш пароль
7. Рестарт и добавление в автозагрузку веб сервера, Zabbix сервера и Zabbix агента:
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
8. Открываем веб-страницу Zabbix UI:
http://host/zabbix

---

## Задание 2 

Установите Zabbix Agent на два хоста.

### Решение 2
В качестве одного из хостов использована машина с Zabbix сервером, в качестве второго - ВМ c ОС Debian 12.04
1. Установка заббикс агента
sudo apt install zabbix-agent
2. Рестарт и добавление в автозагрузку Zabbix агента
systemctl restart zabbix-agent
systemctl enable zabbix-agent
3. Настраиваем параметры подключения заббикс агента к серверу (прописываем адреса хостов) на ВМ: 
sed -i 's/Server=127.0.0.1/Server=192.168.0.10/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.0.10/g' /etc/zabbix/zabbix_agentd.conf

#### Скриншот раздела configuration:

![Скриншот настройки проекта](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part1_2.1.png)

#### Cкриншот лога zabbix agent:

![Скриншот настройки проекта](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part1_2.2.png)

#### Cкриншот раздела Monitoring > Latest data для хостов:

![Скриншот настройки проекта](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part1_2.3.png)

![Скриншот настройки проекта](https://github.com/DinisGaliev/netology-hw/blob/main/Monitoring/img/Zabbix_part1_2.4.png)

---
