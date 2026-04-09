## Uc3mshell P2
ls
mycalc 5 + 3 > scripts-ejemplo/studentdir/mycalc1-medium-bash.out
sleep 5 & 
ls /nonexistent_directory
ls /nonexistent_directory !> scripts-ejemplo/studentdir/error1-medium-bash.err
sort < scripts-ejemplo/test_dir/shrek.txt > scripts-ejemplo/studentdir/sort-medium-bash.out
ls > scripts-ejemplo/studentdir/a.txt
wc -l < scripts-ejemplo/test_dir/shrek.txt
md5sum scripts-ejemplo/test_dir/gato.jpg > scripts-ejemplo/studentdir/md5sum-medium-bash.out 
ls -a < scripts-ejemplo/test_dir > scripts-ejemplo/studentdir/ls-medium-bash.out
cat scripts-ejemplo/test_dir/shrek.txt | grep "shrek" | wc -l
exit 3

