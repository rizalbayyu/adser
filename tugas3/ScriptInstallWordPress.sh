#!/bin/bash
cat << _EOF_
Rizal Bayu Aji Pradana
175150201111051
Tugas 3: Installasi Wordpress


_EOF_

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Please Login as root"
    exit 1
else

echo "=========================================================================="
echo "===============================Preparing=================================="
echo "=========================================================================="

apt -y update
apt -y install expect unzip vim apache2
# Allow access to port 80
sudo ufw allow "Apache"
systemctl enable apache2

# Install mysql server
apt install -y mysql-server

echo "=========================================================================="
echo "===========================MySQL Secure Installation=============================="
echo "=========================================================================="

# Install Secure MariaDB
# Menggunakan spawn, send, expect agar program berjalan secara otomatis
# Spawn=Memanggil atau memulai Script atau Program
# expect=Menunggu output dari program
# send=Memberi balasan untuk program
SECURE_MYSQL=$(expect -c "
spawn mysql_secure_installation
expect \"Press y|Y for Yes, any other key for No:\"
send \"n\r\"
expect \"New password:\"
send \"akuganteng\r\"
expect \"Re-enter new password:\"
send \"akuganteng\r\"
expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"
expect eof");
echo "$SECURE_MYSQL"
systemctl enable mysql

# Install PHP
apt -y install php php-mysql php-gd php-mbstring

echo "=========================================================================="
echo "===========================Database=============================="
echo "=========================================================================="
sleep 2s

#Create Database
mysql -u root -pakuganteng < ./setupdb.sql
echo "===============================Done!!!===================================="

echo "=========================================================================="
echo "===========================Install Wordpress=============================="
echo "=========================================================================="
# Preparing Installation WordPress
mkdir /opt/wordpress
cd /opt/wordpress/ && wget http://wordpress.org/latest.tar.gz
# extract Archieve to web directory
tar -xvzf latest.tar.gz
# Copy wordpress
rsync -a wordpress/* /var/www/html/
#move config from tmp config
mv /tmp/config/wp-config.php /var/www/html/
# Give permission user to apache
chown -R apache:apache /var/www/html/
#change access permissions
chmod -R 755 /var/www/html/


systemctl restart apache2