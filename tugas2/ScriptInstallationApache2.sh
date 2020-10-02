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
Apakah ingin menjalankan web pada /var atau pada /opt?
1. Normal (/var)
2. Custom (/opt)
_EOF_
echo -n "Masukkan input: "
read input;

if [ $input == "1"  ]; then
echo "========================================"
echo "Cloning dari Github"
mkdir /opt/web
git clone https://github.com/jlord/hello.git /opt/web
#Pakai rsync untuk memindahkan file ke direktori html jika di dalam direktori html terdapat direktori atau file lain
rsync -a /opt/web/ /var/www/html
systemctl restart apache2
rm -rf /opt/web/

else
rsync -a 000-default.conf /etc/apache2/sites-enabled/
echo "Cloning dari Github"
mkdir /opt/web
git clone https://github.com/jlord/hello.git /opt/web
systemctl restart apache2
fi
