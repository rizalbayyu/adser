#!/bin/bash
cat << _EOF_
Rizal Bayu Aji Pradana
175150201111051
Tugas1: membuat direktori secara massive dengan value yang memanfaatkan passing variable
_EOF_

echo "======================================================================================="

if [ -z "$@" ]; then
   echo "Masukkan argument; ex: ./namafile 4"
   exit 1
else

value=1
while [ $value -le $@ ]
do
   echo "Membuat direktori: $value"
   mkdir folder$value
   ((value=value+1))
done
fi
echo "======================================================================================="