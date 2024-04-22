#!/bin/bash

# Check if mysql client is installed
if ! command -v mysql &> /dev/null; then
    # Install mysql client
    echo "Installing mysql client..."
    apt-get update
    apt-get install -y mariadb-client
    apt-get install -y mysql-client
fi

# Wait for MySQL service to start
until mysqladmin ping -h"db_master" --silent; do
    echo 'Waiting for MySQL to start...'
    sleep 5
done

# Dump master database
mysqldump -h db_master -u $MYSQL_USER -p$MYSQL_PASSWORD --opt $MYSQL_DATABASE > /tmp/master_dump.sql

# Import dump into replica database
mysql -h db_replica -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < /tmp/master_dump.sql

# Configure replication on replica database
mysql -h db_replica -u $MYSQL_USER -p$MYSQL_PASSWORD <<EOF
CHANGE MASTER TO MASTER_HOST='db_master', MASTER_USER='$MYSQL_REPLICA_USER', MASTER_PASSWORD='$MYSQL_REPLICA_PASSWORD', MASTER_LOG_FILE='master-bin.000001', MASTER_LOG_POS=107;
START SLAVE;
EOF

echo 'Replication setup completed. Container will keep running.'

mysql -h db_master -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW MASTER STATUS;"

# Keep the container running
sleep infinity

