#!/bin/bash
cat << _EOF_
Rizal Bayu Aji Pradana
175150201111051
Tugas 2: Installasi dan konfigurasi Apache2
dan menampilkan halaman Web
_EOF_

echo "========================================"
sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install apache2 -y
echo "Installing apache 2 and some tools is done"
echo "========================================"
echo "Konfigurasi"
sudo ufw allow "Apache"
sudo systemctl enable apache2
echo "========================================"
cat << _EOF_
Cloning Web
_EOF_
mkdir /opt/web
git clone https://github.com/jlord/hello.git /opt/web
#Pakai rsync untuk memindahkan file ke direktori html jika di dalam direktori html terdapat direktori atau file lain
rsync -a /opt/web/ /var/www/html
systemctl restart apache2
rm -rf /opt/web/
