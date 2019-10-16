# This script should be run on first login immediatley after initial vargant up is run.
# This script will insure mariaDB is secure and set to start on boot.

# Secure mariadb.
sudo mysql_secure_installation
# Enable MariaDB to start on boot.
sudo systemctl enable mariadb.service