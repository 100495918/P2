#!/bin/bash
echo "ssoo,os"
cat scripts-ejemplo/test_dir/proceso.txt
md5sum scripts-ejemplo/test_dir/gato.jpg
ls scripts-ejemplo/test_dir
cp scripts-ejemplo/test_dir/perro.webp scripts-ejemplo/studentdir/perronuevo.webp # Deben de implementarlo con mycp
wc scripts-ejemplo/test_dir/shrek.txt
wc -l scripts-ejemplo/test_dir/shrek.txt
ls -l scripts-ejemplo/test_dir
cat noexiste.txt
ls scripts-ejemplo/test_dir
echo "Operación: 1 + 1 = $((1+1))" # Deben de implementarlo con mycalc
echo "Goodbye 3" # Imita al comando exit que deberían implementar, pero con un echo para que se vea en la salida del script. El número 3 es el código de salida que deberían implementar con exit.