echo generating scanner
flex -l -Pzubr_ validator.l
echo generating parser 
zubr -d validator.y
echo linking and compiling
tcc -o v.exe lex.zubr_.c z_tab.c
echo executing
v.exe scheme_empty.xml