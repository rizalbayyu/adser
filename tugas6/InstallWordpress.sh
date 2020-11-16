#!/bin/bash
cat << _EOF_


Tugas 6: Installasi Wordpress


_EOF_

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Please Login as root"
    exit 1
else

apt -y update
apt -y install expect vim nginx
# Allow access to port 80 & 443
sudo ufw allow 80
sudo ufw allow 443
systemctl start nginx
systemctl enable nginx

#Install dan Konfigurasi MySQL

sudo apt-get install mysql-server -y

# Install Secure MySQL
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

echo "=========================================================================="
echo "===========================Database=============================="
echo "=========================================================================="

#Create Database
mysql -u root -pakuganteng < ./setupdb.sql
echo "===============================Done!!!===================================="

#Install PHP
apt install -y php7.2-cli php7.2-fpm php7.2-mysql php7.2-json php7.2-opcache php7.2-mbstring php7.2-xml php7.2-gd php7.2-curl php-zip

echo "=========================================================================="
echo "===========================Install Wordpress=============================="
echo "=========================================================================="
# Preparing Installation WordPress
mkdir /var/www/html/wordpress
wget http://wordpress.org/latest.tar.gz -P /opt/
# extract Archieve from /opt/wordpress directory to this directory
tar -xvzf /opt/latest.tar.gz

# Move wordpress to /var/www/html/wordpress
mv wordpress/* /var/www/html/wordpress

# rsync beberapa file konfigurasi yang telah disesuaikan
rsync -a wp-config.php /var/www/html/wordpress
rsync -a wordpress.conf /etc/nginx/sites-available
rsync -a nginx.conf /etc/nginx/nginx.conf
rsync -a nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
rsync -a nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
cp dhparam.pem /etc/nginx/
cp self-signed.conf /etc/nginx/snippets/
cp ssl-params.conf /etc/nginx/snippets

sudo ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

# Membuat SSL certificate
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

#hapus file yang tidak dipakai
rm /etc/nginx/sites-enabled/default

#Change Owner
chown -R www-data:www-data /var/www/html
#change access permissions
chmod -R 755 /var/www/html

nginx -t
systemctl restart nginx
fi