# Домашнее задание к занятию «Ansible.Часть 2» Галиев Д.Ф.

---

## Задание 1

**Выполните действия, приложите файлы с плейбуками и вывод выполнения.**

Напишите три плейбука. При написании рекомендуем использовать текстовый редактор с подсветкой синтаксиса YAML.

Плейбуки должны: 

1. Скачать какой-либо архив, создать папку для распаковки и распаковать скаченный архив. Например, можете использовать [официальный сайт](https://kafka.apache.org/downloads) и зеркало Apache Kafka. При этом можно скачать как исходный код, так и бинарные файлы, запакованные в архив — в нашем задании не принципиально.
2. Установить пакет tuned из стандартного репозитория вашей ОС. Запустить его, как демон — конфигурационный файл systemd появится автоматически при установке. Добавить tuned в автозагрузку.
3. Изменить приветствие системы (motd) при входе на любое другое. Пожалуйста, в этом задании используйте переменную для задания приветствия. Переменную можно задавать любым удобным способом.

### Решение 1

```
---
- name: PLAY 1
  hosts: cloud-server
  become: yes
  tasks:
  - name: Download and Unarchive
    unarchive:
      src: https://downloads.apache.org/kafka/3.8.0/kafka-3.8.0-src.tgz
      dest: /usr/local
      remote_src: yes

- name: PLAY 2
  hosts: cloud-server
  become: yes
  tasks:
  - name: Install the tuned
    apt:
      name: tuned
      state: present
  - name: Start the tuned
    systemd:
      name: tuned
      state: started
      enabled: yes

- name: PLAY 3
  hosts: cloud-server
  become: yes
  vars:
    path: /etc/update-motd.d/
  tasks:
  - name: Сhange the greeting
    file:
      path: "{{path}}"
      mode: u=rw,g=rw,o=rw
      recurse: yes

```
![](./img/Ansible_1.1.png)


## Задание 2

**Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.** 

Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору. 

### Решение 2

```
---
- name: PLAY 1
  hosts: cloud-server
  become: yes
  tasks:
  - name: Download and Unarchive
    unarchive:
      src: https://downloads.apache.org/kafka/3.8.0/kafka-3.8.0-src.tgz
      dest: /usr/local
      remote_src: yes

- name: PLAY 2
  hosts: cloud-server
  become: yes
  tasks:
  - name: Install the tuned
    apt:
      name: tuned
      state: present
  - name: Start the tuned
    systemd:
      name: tuned
      state: started
      enabled: yes

- name: PLAY 3
  hosts: cloud-server
  become: yes
  vars:
    path: /etc/update-motd.d/
  tasks:
  - name: Сhange the greeting
    file:
      path: "{{path}}"
      mode: u=rw,g=rw,o=rw
      recurse: yes
  - name: Add the message
    template:
      src: motd.j2
      dest: /etc/motd
      mode: '644'
```
motd.j2

```
Hello, and welcome to "{{ ansible_facts['fqdn'] }}"

```
![](./img/Ansible_2.1.png)

![](./img/Ansible_2.2.png)

## Задание 3

**Выполните действия, приложите архив с ролью и вывод выполнения.**

Ознакомьтесь со статьёй [«Ansible - это вам не bash»](https://habr.com/ru/post/494738/), сделайте соответствующие выводы и не используйте модули **shell** или **command** при выполнении задания.

Создайте плейбук, который будет включать в себя одну, созданную вами роль. Роль должна:

1. Установить веб-сервер Apache на управляемые хосты.
2. Сконфигурировать файл index.html c выводом характеристик каждого компьютера как веб-страницу по умолчанию для Apache. Необходимо включить CPU, RAM, величину первого HDD, IP-адрес.
Используйте [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) и [jinja2-template](https://linuxways.net/centos/how-to-use-the-jinja2-template-in-ansible/). Необходимо реализовать handler: перезапуск Apache только в случае изменения файла конфигурации Apache.
4. Открыть порт 80, если необходимо, запустить сервер и добавить его в автозагрузку.
5. Сделать проверку доступности веб-сайта (ответ 200, модуль uri).

В качестве решения:
- предоставьте плейбук, использующий роль;
- разместите архив созданной роли у себя на Google диске и приложите ссылку на роль в своём решении;
- предоставьте скриншоты выполнения плейбука;
- предоставьте скриншот браузера, отображающего сконфигурированный index.html в качестве сайта.

### Решение 3
digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat main.yml

```
# tasks file for apache
  - import_tasks: install.yml
  - import_tasks: service.yml
  - import_tasks: port.yml
  - import_tasks: index.yml
  - import_tasks: connection.yml

```
digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat install.yml

```
- name: Run the equivalent of "apt-get update" as a separate step
  ansible.builtin.apt:
    update_cache: yes
- name: install apache web server
  apt:
    name: apache2
    state: present
- name: Start the apache2
  systemd:
    name: tuned
    state: started
    enabled: yes

```

digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat service.yml

```
 - name: start apache webserver
    service:
      name: apache2
      state: started
      enabled: yes

```

digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat connection.yml

```
- name: Check that you can connect (GET) to a page and it returns a status 200
    ansible.builtin.uri:
      url: "{{address}}"
    vars:
      address: "http://{{ ansible_facts.all_ipv4_addresses [0] }}"

```
digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat port.yml

```
- name: wait for port 80 to become open
    wait_for:
      port: 80
      delay: 10

```
digaliev@debian-lab:~/.ansible/roles/apache/tasks$ cat index.yml

```
- name: add page
  template:
    src: "index.html.j2"
    dest: "/var/www/html/index.html"
    owner: root
    group: root
    mode: 0755

```
digaliev@debian-lab:~/.ansible/roles/apache/templates$ cat index.html.j2

```
<p>IP: {{ ansible_facts.all_ipv4_addresses [0] }}
<p>CPU: {{ ansible_facts.processor }}
<p>RAM_mb: {{ ansible_facts.memtotal_mb }}
<p>vda1_size: {{ ansible_facts['devices']['vda']['partitions']['vda2']['size'] }}

```
![](./img/Ansible_3.1.png)

