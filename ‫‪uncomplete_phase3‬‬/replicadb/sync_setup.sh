#!/bin/bash

apt update && apt upgrade
apt-get install -y mariadb-client

mariadb -u root -p"SQL_Arman_Pass" <<EOF
CREATE USER 'SQL_USRtest'@'%' IDENTIFIED BY 'SQL_Passtest';
GRANT REPLICATION SLAVE ON *.* TO 'SQL_USRtest'@'%';
FLUSH PRIVILEGES;
EOF

sleep infinity

