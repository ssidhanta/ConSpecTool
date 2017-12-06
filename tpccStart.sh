#!/bin/bash
sudo mkdir /var/run/mysqld
sudo touch /var/run/mysqld/mysqld.sock
sudo chown -R mysql /var/run/mysqld
sudo chown -R mysql /var/lib/mysql
sudo usermod -d /var/lib/mysql/ mysql
sudo service mysql start
mysql -u root --default_character_set utf8 -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('101010');FLUSH PRIVILEGES;"
#mysql -u root --default_character_set utf8 -e "SET PASSWORD FOR 'root'@'192.168.0.1' = PASSWORD('101010');FLUSH PRIVILEGES;"
sh /var/lib/tpccServerStart.sh
