#!/bin/bash
ls
echo "Operación: 5 + 3 = $((5+3))" > scripts-ejemplo/bashdir/mycalc1-medium-bash.out # (mycalc > mycalc1-medium-bash.out) Imita al comando mycalc que deberían implementar, pero con un echo para que se vea en la salida del script. El resultado de la operación es 8.
sleep 5 & 
ls /nonexistent_directory
ls /nonexistent_directory 2> scripts-ejemplo/bashdir/error1-medium-bash.err
sort < scripts-ejemplo/test_dir/shrek.txt > scripts-ejemplo/bashdir/sort-medium-bash.out
ls > scripts-ejemplo/bashdir/a.txt
wc -l < scripts-ejemplo/test_dir/shrek.txt
md5sum scripts-ejemplo/test_dir/gato.jpg > scripts-ejemplo/bashdir/md5sum-medium-bash.out 
ls -a < scripts-ejemplo/test_dir > scripts-ejemplo/bashdir/ls-medium-bash.out
cat scripts-ejemplo/test_dir/shrek.txt | grep "shrek" | wc -l
echo "Goodbye 3" # Imita al comando exit que deberían implementar, pero con un echo para que se vea en la salida del script. El número 3 es el código de salida que deberían implementar con exit.
