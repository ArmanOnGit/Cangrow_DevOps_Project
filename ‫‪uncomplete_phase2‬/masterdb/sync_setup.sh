#!/bin/bash

apt update && apt upgrade
apt-get install -y mariadb-client

mariadb -u root -p"SQL_Arman_Pass" <<EOF
CREATE USER 'SQL_USRtest'@'%' IDENTIFIED BY 'SQL_Passtest';
GRANT ALL PRIVILEGES ON Master_Database.* TO 'SQL_USRtest'@'%';
FLUSH PRIVILEGES;
EOF

sleep infinity
