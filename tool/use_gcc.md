# gcc 使用笔记

1. You could compile with `gcc -v -H` to understand more precisely which actual programs are run (since gcc is a driver, running the cc1 compiler, the ld & collect2 linkers, the as assembler, etc...) and which headers are included, which libraries and object files are linked (even implicitly, including the C standard library and the crt0).
