!/bin/bash

# Check if mysql client is installed
if ! command -v mysql &> /dev/null; then
    # Install mysql client
    echo "Installing mysql client..."
    apt-get update
    apt-get install -y mariadb-client
fi

sleep infinity

