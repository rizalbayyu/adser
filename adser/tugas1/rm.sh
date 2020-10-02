#!/bin/bash

cat << _EOF_
Menghapus percobaan pada tugas 1
_EOF_

value=1
while [ $value -le $@ ]
do
    rm -rf folder$value
    echo "Menghapus folder$value"
    ((value=value+1))
done