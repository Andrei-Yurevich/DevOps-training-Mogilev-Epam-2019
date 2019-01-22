# Первый модель
&nbsp;
## Конфигурация VM1

После установки в машину пихаем 2 интерфейса: nat и vbox0

Утилитой nmtui настраиваем NAT интерфейс enp0s3 следующим образом:<br />
ip адрес -- 10.0.2.10<br />
маска -- 255.255.255.0<br />
DNS1 -- 8.8.8.8<br />
шлюз -- 10.0.2.2

Далее настраиваем vbox0 следующим образом:<br />
ip адрес -- 192.168.56.11<br />
маска -- 255.255.255.0

DNS не прописываем, потому что этот интерфейс не смотрит наружу.

В файле /etc/sysctl.conf разрешаем проброс ip добавив строку:<br />
`net.ipv4.ip_forward = 1`

говорим ядру применить изменения на лету:<br />
`sysctl -p`

Запускаем фаервол: <br />
`systemctl start firewalld`

Разрешаем VM2 ходить в интернет следующими правилами фаервола:<br />
        `firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o enp0s3 -j MASQUERADE`<br />
        `firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i enp0s8 -o enp0s3 -j ACCEPT`<br />
        `firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT`<br />
        `firewall-cmd --runtime-to-permanent`<br />


Далее перезагружаем network, поднимаем enp0s8 и enp0s3:<br />
	`systemctl network restart`<br />
	`ip link set enp0s3 up`<br />
	`ip link set enp0s8 up`<br />
Готово
&nbsp;
## Конфигурация VM2
Пихаем в машину vbox0 и NAT.<br />
enp0s8 настраиваем следующим образом:<br />
ip адрес -- 192.168.56.12<br />
маска -- 255.255.255.0<br />
шлюз -- 192.168.56.11<br />
DNS -- 8.8.8.8

Далее перезагружаем network и выключаем enp0s3:<br />
	`systemctl network restart`<br />
	`ip link set enp0s3 down`<br />
	`ip link set enp0s8 up`<br />
&nbsp;
## Конфигурация VM3
Настраиваем enp0s8:<br />
ip адрес -- 192.168.56.13<br />
маска -- 255.255.255.0<br />
что бы не ходить в интернет достаточно просто не прописывать DNS и шлюз.<br />
<br />
Далее перезагружаем network, поднимаем enp0s8 и вырубаем enp0s3:<br />
	`systemctl network restart`<br />
	`ip link set enp0s3 down`<br />
	`ip link set enp0s8 up`<br />
