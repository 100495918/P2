## Uc3mshell P2
cat scripts-ejemplo/test_dir/shrek.txt | grep shrek > /tmp/test11_out.txt !> /tmp/test11_err.txt &
echo lanzado_en_background
cat /tmp/test11_out.txt | wc -l > /tmp/test11_wc.txt
cat /tmp/test11_wc.txt
ls -l | sort < scripts-ejemplo/test_dir/shrek.txt > /tmp/test11_ls_sort.txt
cat /tmp/test11_ls_sort.txt | head -3
