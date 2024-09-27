## **Отчет по LinuxPractice**

В качестве имен машин - А, В, С указаных в задании будут использоваться - 1, 2 , 3

1. Установка 3х виртуальных машин Ubuntu-server 23.04

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/518c6db7-3f73-4ec4-9c45-20cb1b67523e)

2. Переименование hostname на "**user-server**" через команду
```
$ sudo vim /etc/hostname 
```
3. Создание пользователя "**user_1**" через команду
```
$ sudo adduser user-1
```
*******************
4. Добавляем пользователей и меняем hostname на других серверах. В итоге получим:

| 1| 2| 3|
|:-:|:-:|:-:|
user_1|user-2|user_3
user-server|server_gateway|server_client

**1:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/a16b754a-cb43-4813-96a3-23b24112d5cb)

**2:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/52f65019-a8e5-4841-9039-7da93d55bf48)

**3:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/b0646789-7f8f-460a-94d0-6fcefb8967d5)

*******************
5. Настройка SSH соединений с машинами
Устанавливаем SSH с помощью команды:
```
$ sudo apt-get install ssh
```

Устанавливаем OpenSSH
```
$ sudo apt install openssh-server
```

Добавим пакет SSH-сервера в автозагрузку
```
$ sudo apt install openssh-server -y
$ systemctl enable ssh
$ systemctl start ssh
$ systemctl status ssh
```
Получаем:

**user-1:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/41cada73-55c6-4c9b-8673-6a2550185aa0)

**user-2:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/dd80ae93-e4ea-4dac-9dc7-5387363ca459)

**user-3**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/411f6b1e-1e9f-4a1e-b2c2-9eda2f66e378)

*******************
#### Конфигурация маршрутов

6. Необходимо настроить сеть на машинах - с помощью утилиты **netplan**

Настроим конфигурационный файл с помощью команды 
```
sudo nano /etc/netplan/00-installer-config.yaml
```

* **user-server:**
```
network:
  ethernets:
    enp0s3: # этот интерфейс используем для доступа с ноутбука
      dhcp4: true 
    enp0s8: # этот интерфейс настравиваем на передачу запросов
      dhcp4: no
      addresses: [192.168.22.10/24]
      gateway4: 192.168.22.1
  version: 2
```
Применяем конфигурацию к **user-server:**
```
$ sudo netplan apply
```

* **server_gateway:**
```
network:
  ethernets:
    enp0s3: # этот интерфейс используем для доступа с ноутбука
      dhcp4: true 
    enp0s8: # этот интерфейс настравиваем на передачу запросов сервера (Помните про виртуальную сеть в VirtualBox)
      dhcp4: no
      addresses: [192.168.22.1/24]
    enp0s9: # этот интерфейс настравиваем на передачу запросов клиента
      dhcp4: no
      addresses: [192.168.9.1/24]
  version: 2
```
Применяем конфигурацию к **server_gateway:**
```
$ sudo netplan apply
```

* **server-client:**
```
network:
  ethernets:
    enp0s3: # этот интерфейс используем для доступа с ноутбука
      dhcp4: true 
    enp0s8: # этот интерфейс настравиваем на передачу запросов
      dhcp4: no
      addresses: [192.168.9.10/24]
      gateway4: 192.168.9.1
  version: 2
```
Применяем конфигурацию к **server-client:**
```
$ sudo netplan apply
```
*******************
Выведем содержимое получившихся конфиг-файлов в консоль
```
$ cat /etc/netplan/00-installer-config.yaml
```
* **user-server:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/9d262954-cbd5-47f2-995f-a2b14ae3e65d)

Проверка кода через команду: ```$ sudo netplan --debug generate ```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/27637f1a-2634-4baf-8f32-63820ae5fbce)
*******************

* **server_gateway:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/2a0b1e95-5716-4a92-a4db-4af13c38a88d)

Проверка кода через команду: ```$ sudo netplan --debug generate ```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/2d03f60d-d681-4740-9010-4a98352de425)
*******************

* **server-client:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/95745ec6-2e06-4d77-ae2e-49d894964401)

Проверка кода через команду: ```$ sudo netplan --debug generate ```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/750c48c9-1eb6-46a6-acc8-826ee14c6e76)

*******************
7. С помощью команды проверим список подлюченных сетевых интерфейсов и их характеристики
```
$ ifconfig
```
**user-server:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/c093ace1-8f96-425c-b551-52c7eb5c5545)

**server_gateway:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/83d95c9b-1f0c-419d-902c-b583ad1bc50a)

**server-client:**
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/7b161a8f-a80a-4828-875a-beb51f045b90)

*******************
8. Разрешить переброс пакетов ip в нашем **server_gateway**
```
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward 1
```

Раскомментриуем данную строку чтобы при запуске машин шлюз сохранял видимость:

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/27cb6c60-a8e0-4554-b4ee-3b471cf277f2)

**Таким образом виртуальные машины 1 и 3 будут видеть друг друга в сети 2**
*******************
9. Проверим работу шлюза с помощью команды: ```$ sudo tcpdump -i enp0s8 icmp```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/e69db078-1f76-47c1-93e4-753b8cc2752f)

Чтобы разрешить передачу только конкретных пакетов по конкретному порту, следует настроить маршрут c помощью ```iptables```:
```
$ sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -p tcp --syn --dport 5000 -m conntrack --ctstate NEW -j ACCEPT

$ sudo iptables -A FORWARD -i enp0s8 -o enp0s9 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$ sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$ sudo iptables -P FORWARD DROP
```
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/4a2b232d-07c0-40e4-aba0-813315f85c2a)

Просмотреть все правила можно с помощью команды: ```sudo iptables -L```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/1c5e9beb-53f5-403b-9ddb-f58d05c41aef)
*******************
10. Сохраним правила с помощью команды (с root правами):
```
$ sudo su
root# $ sudo iptables-save > /etc/iptables/rules.v4
root#  $ sudo ip6tables-save > /etc/iptables/rules.v6
root#  $ exit
```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/a76ccb54-7b07-4956-a703-96320c9b8186)

*******************
11. Создание HTTP-сервера

Для установки веб-сервера на машине 1 рекомендуется использовать **python flask**
Python установлен по-умолчанию. Для установки ```flask``` необходимо ввести:
```
$ sudo apt install python3-flask
```

Создаем файл ```app.py``` и поместим следующее содержимое:
```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

app.run(host='0.0.0.0', port=5000)
```

![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/0cbd5778-e169-41fe-8588-49e32dddc264)


Проверяем созданный файл через команду ```cat```
![image](https://github.com/MrGRollins/LinuxPractice/assets/43073872/43f7602f-8953-4af5-9f07-0257e90fd809)

*******************
С помощью systemd необходимо создать сервис, который запускает скрипт через автозагрузку
```
$ sudo nano /lib/systemd/system/web-server.service
```

Вставить следующее содержимое в файл:
```
[Unit]
Description=Web-Server
[Service]
Type=idle
WorkingDirectory=/home/user/server/
ExecStart=python3 app.py
[Install]
WantedBy=multi-user.target
```
Перезапустить службы и активировать автозагрузку
```
systemctl daemon-reload
systemctl enable web-server
```
*Таким образом сервер настроен и готов к использованию*
*********************
Веб-клиент (Машина 3)

Чтобы послать запрос на машину А, необходимо ввести следующую команду:
```
curl 'http://192.168.22.10:5000/
```
Если поменять на сервере порт отличный от 5000 и попробовать отправить запрос, шлюз не должен пропустить пакеты
