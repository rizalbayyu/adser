#!/bin/bash
cat << _EOF_
Rizal Bayu Aji Pradana
175150201111051
Tugas Pra Kelas: Installasi dan konfigurasi Apache2
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