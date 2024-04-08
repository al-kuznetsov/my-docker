#!/bin/bash

# Перейти в директорию, где будут храниться сертификаты
cd /path/to/ssl/directory

# Создать корневой ключ
openssl genrsa -des3 -out rootCA.key 4096

# Создать корневой сертификат
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt

# Создать закрытый ключ для сервера
openssl genrsa -out kafka.key 4096

# Создать запрос на сертификат для сервера
openssl req -new -key kafka.key -out kafka.csr

# Подписать запрос на сертификат с помощью корневого сертификата
openssl x509 -req -in kafka.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out kafka.crt -days 3650 -sha256

# Скопировать необходимые файлы для Kafka
cp rootCA.crt kafka.server.truststore.jks
openssl pkcs12 -export -in kafka.crt -inkey kafka.key -out kafka.p12 -name kafka-server -CAfile rootCA.crt -caname root -password pass:kafkapassword
keytool -noprompt -keystore kafka.server.keystore.jks -alias kafka-server -validity 3650 -genkey -keyalg RSA -storetype pkcs12 -dname "CN=localhost, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=Unknown" -storepass kafkapassword -keypass kafkapassword
keytool -noprompt -keystore kafka.server.keystore.jks -alias CARoot -import -file rootCA.crt -storepass kafkapassword -keypass kafkapassword
keytool -noprompt -keystore kafka.server.keystore.jks -alias kafka-server -import -file kafka.crt -storepass kafkapassword -keypass kafkapassword
openssl pkcs12 -export -in kafka.crt -inkey kafka.key -out kafka.p12 -name kafka-client -CAfile rootCA.crt -caname root -password pass:kafkapassword
keytool -noprompt -keystore kafka.client.truststore.jks -alias CARoot -import -file rootCA.crt -storepass kafkapassword -keypass kafkapassword
keytool -noprompt -keystore kafka.client.keystore.jks -alias kafka-client -validity 3650 -genkey -keyalg RSA -storetype pkcs12 -dname "CN=localhost, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=Unknown" -storepass kafkapassword -keypass kafkapassword
keytool -noprompt -keystore kafka.client.keystore.jks -alias CARoot -import -file rootCA.crt -storepass kafkapassword -keypass kafkapassword
keytool -noprompt -keystore kafka.client.keystore.jks -alias kafka-client -import -file kafka.crt -storepass kafkapassword -keypass kafkapassword

# Удалить временные файлы
rm kafka.csr
rm kafka.p12
rm *.srl

