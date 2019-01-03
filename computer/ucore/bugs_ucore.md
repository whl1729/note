# ucores 抓虫记

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

### Bug 1：bootblock链接失败

1. 从陈渝老师的github代码库clone了一份干净的代码到本地，进入labcodes_answer/lab1_result目录，执行`make qemu`时失败了，提示以下信息：
```
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
600 >> 510!!
'obj/bootblock.out' size: 600 bytes
make: *** [bin/bootblock] Error 255
```

2. 根据提示信息，可知是链接后的obj/bootblock.out文件大于512字节，导致检查不通过。这个检查是在哪里设置的呢？在代码库里搜索，发现是在tools/sign.c中设置的：
```
    printf("'%s' size: %lld bytes\n", argv[1], (long long)st.st_size);
    if (st.st_size > 510) {
        fprintf(stderr, "%lld >> 510!!\n", (long long)st.st_size);
        return -1;
    }
```

3. 怎么解决？先确认一下是不是每个lab都有这个问题。进入labcodes_answer/lab2_result目录，执行`make qemu`成功了，说明lab2是正常的。

4. 为什么lab1和lab2的现象不一样呢？有两种可能：一是链接脚本不同，lab2增加了某些链接选项，使得链接后的文件可以变小；二是代码文件不同，lab1的代码文件比lab2大。于是首先比较两个lab的链接脚本，发现基本相同。然后比较两个lab的diamante文件，发现boot/nootmain.c有以下两处差异：
```
// lab1
unsigned int    SECTSIZE  =      512 ;
struct elfhdr * ELFHDR    =      ((struct elfhdr *)0x10000) ;     // scratch space

// lab2
#define SECTSIZE        512
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space
```

5. 可以推测lab2的写法是比lab1省内存的，因为使用宏代替了全局变量。但这点差异足够大到lab1链接不通过吗？先将lab2的写法同步到lab1，再make一把，发现果然可以了，boot/bootblock.out的size由600字节减少到488字节，少了112字节。真神奇，两个全局变量竟会导致增加了112字节！

6. 总结：定位问题的一种思路：如果有两份代码，一份有问题，另一份正常，那么可以使用对比法。
