## Uc3mshell P2
ls /directorio_que_no_existe !> /tmp/test6_error.txt
cat /tmp/test6_error.txt
ls /otro_dir_inexistente !> /tmp/test6_error2.txt
echo el_error_fue_redirigido
