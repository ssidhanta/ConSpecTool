#!/bin/bash
#mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'sa'@'127.0.0.1' identified by '101010'"
#mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'sa'@'%' identified by '101010'"
#mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'sa'@'192.168.0.1' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'root'@'%' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'root'@'' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to 'root'@'192.168.0.1' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8 -e "grant all privileges on *.* to ''@'' identified by '101010'"
mysql -uroot --default_character_set utf8 -p101010 -e "grant all privileges on *.* to ''@'192.168.0.1' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8  -e "grant all privileges on *.* to ''@'' identified by '101010'"
mysql -uroot -p101010 --default_character_set utf8 -e "create database tpcc"
mysql -uroot -p101010 -e "SOURCE /var/lib/create_tables.sql"
mysql -uroot -p101010 -e "SOURCE /var/lib/add_fkey_idx.sql"
java -classpath /var/lib/tpcc-master/target/tpcc-1.0.0-SNAPSHOT-jar-with-dependencies.jar com.codefutures.tpcc.TpccLoad
java -classpath target/tpcc-1.0.0-SNAPSHOT-jar-with-dependencies.jar com.codefutures.tpcc.Tpcc
