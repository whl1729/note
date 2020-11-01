# Linux 系统启动流程

## 引导过程

1. Linux 引导过程综述
    - UEFI
    - Boot loader
    - 内核初始化（体系结构相关部分）
    - 内核初始化（体系结构无关部分）
    - 用户态初始化

## BIOS

1. BIOS的主要功能
    - POST(Power-On Self Test)：加电自检，检测CPU各寄存器、计时芯片、中断芯片、DMA 控制器等。
    - Initial: 枚举设备，初始化寄存器，分配中断、IO 端口、DMA 资源等。
    - Setup: 进行系统设置，存于 CMOS 中。
    - 常驻程序：INT 10h、INT 13h、INT 15h 等，提供给操作系统或应用程序调用。
    - 启动自举程序：在POST过程结束后，将调用 INT 19h，启动自举程序，自举程序将读取引导记录，装载操作系统。

2. POST
    - 当 PC 加电后，CPU 的寄存器被设为某些特定值。其中，指令指针寄存器（program counter）被设为 0xfffffff0。（注：0xFFFFFFF0 这个地址被映射到了 ROM，因此 CPU 执行的第一条指令来自于 ROM，而不是 RAM。）
    - CR1，一个32位控制寄存器，在刚启动时值被设为0。CR1 的 PE (Protected Enabled，保护模式使能) 位指示处理器是处于保护模式还是实模式。由于启动时该位为0，处理器在实模式中引导。在实模式中，线性地址与物理地址是等同的。
    - 在实模式下，0xfffffff0 不是一个有效的内存地址，计算机硬件将这个地址指向 BIOS 存储块。这个位置包含一条跳转指令，指向 BIOS 的 POST 例程。
    - POST（Power On Self Test，加电自检）过程包括内存检查、系统总线检查等。如果发现问题，主板会蜂鸣报警。在 POST 过程中，允许用户选择引导设备。

3. 自举过程
    - 自举过程即为执行中断 INT 0x19 的中断服务例程 INT19_VECT 的过程 (Bootrom.asm)
    - 主要功能为读取引导设备第一个扇区的前 512 字节（MBR），将其读入到内存 0x0000:7C00，并跳转至此处执行。

4. 可引导设备列表存储在在 BIOS 配置中, BIOS 将根据其中配置的顺序，尝试从不同的设备上寻找引导程序。对于硬盘，BIOS 将尝试寻找引导扇区。

## UEFI

1. UEFI replaces the traditional BIOS on PCs. There’s no way to switch from BIOS to UEFI on an existing PC. You need to buy new hardware that supports and includes UEFI, as most new computers do. Most UEFI implementations provide BIOS emulation so you can choose to install and boot old operating systems that expect a BIOS instead of UEFI, so they’re backwards compatible.

2. UEFI is essentially a tiny operating system that runs on top of the PC’s firmware, and it can do a lot more than a BIOS. It may be stored in flash memory on the motherboard, or it may be loaded from a hard drive or network share at boot.

3. We have three important bits of groundwork the UEFI spec provides: thanks to these requirements, any other layer can confidently rely on the fact that the firmware:
    - Can read a partition table
    - Can access files in some specific filesystems
    - Can execute code in a particular format

### EFI executables

1. The UEFI spec defines an **executable format** and requires all UEFI firmwares be capable of executing code in this format. When you write a bootloader for native UEFI, you write in this format.

### GPT (GUID Partition Table)

1. GPT is just a standard for doing partition tables - the information at the start of a disk that defines what partitions that disk contains. It's a better standard for doing this than MBR/'MS-DOS' partition tables were in many ways, and the UEFI spec requires that UEFI-compliant firmwares be capable of interpreting GPT (it also requires them to be capable of interpreting MBR, for backwards compatibility).

### ESP (EFI system partitions)

1. The UEFI spec requires that compliant firmwares be capable of reading the FAT12, FAT16 and FAT32 variants of the FAT format, in essence.

2. An 'EFI system partition' is really just any partition formatted with one of the UEFI spec-defined variants of FAT and given a specific GPT partition type to help the firmware find it. And the purpose of this is just as described above: allow everyone to rely on the fact that **the firmware layer will definitely be able to read data from a pretty 'normal' disk partition**. Hopefully it's clear why this is a better design: instead of having to write bootloader code to the 'magic' space at the start of an MBR disk, **operating systems and so on can just create, format and mount partitions in a widely understood format and put bootloader code and anything else that they might want the firmware to read there**.

3. An ESP contains
    - the boot loaders or kernel images for all installed operating systems (which are contained in other partitions),
    - device driver files for hardware devices present in a computer and used by the firmware at boot time,
    - system utility programs that are intended to be run before an operating system is booted,
    - and data files such as error logs.

4. UEFI firmware supports booting from removable storage devices such as USB flash drives. For that purpose, a removable device is formatted with a FAT12, FAT16 or FAT32 file system, while a boot loader needs to be stored according to the standard ESP file hierarchy, or by providing a complete path of a boot loader to the system's boot manager. On the other hand, FAT32 is always expected on fixed drives.

5. The mount point for the EFI system partition is usually /boot/efi, where its content is accessible after Linux is booted.

### The UEFI boot manager

1. The UEFI boot manager is a firmware policy engine that can be configured by modifying architecturally defined global NVRAM variables. The boot manager will attempt to load UEFI drivers and UEFI applications (including UEFI OS boot loaders) in an order defined by the global NVRAM variables.

2. One rather great thing UEFI provides is a mechanism for doing this from other layers: you can configure the system boot behaviour from a booted operating system. You can do all this by using the efibootmgr tool, once you have Linux booted via UEFI somehow. There are Windows tools for it too.

3. The UEFI boot manager can be configured - simply put, you can add and remove entries from the 'boot menu'.

4. This is the mechanism the UEFI spec provides for operating systems to make themselves available for booting: the operating system is intended to install a bootloader which loads the OS kernel and so on to an EFI system partition, and add an entry to the UEFI boot manager configuration with **a name** - obviously, this will usually be derived from the operating system's name - and the **location of the bootloader** (in EFI executable format) that is intended for loading that operating system.

## UEFI vs BIOS

1. Terminology
    - Both BIOS and UEFI are types of firmware for computers. BIOS-style firmware is (mostly) only ever found on IBM PC compatible computers. UEFI is meant to be more generic, and can be found on systems which are not in the 'IBM PC compatible' class.
    - You do not have a 'UEFI BIOS'. No-one has a 'UEFI BIOS'. Please don't ever say 'UEFI BIOS'. BIOS is not a generic term for all PC firmware, it is a particular type of PC firmware. Your computer has a firmware. If it's an IBM PC compatible computer, it's almost certainly either a BIOS or a UEFI firmware. If you're running Coreboot, congratulations, Mr./Ms. Exception. You may be proud of yourself.

1. Why UEFI?
    - This new standard **avoids the limitations** of the BIOS. The UEFI firmware can boot from drives of 2.2 TB or larger—in fact, the theoretical limit is 9.4 zettabytes.
    - It also boots in a more standardized way, **launching EFI executables** rather than running code from a drive’s master boot record.
    - UEFI can run in 32-bit or 64-bit mode and has **more addressable address space** than BIOS, which means your boot process is faster.
    - UEFI is packed with other features. It supports **Secure Boot**, which means the operating system can be checked for validity to ensure no malware has tampered with the boot process.
    - It can support **networking features** right in the UEFI firmware itself, which can aid in remote troubleshooting and configuration. With a traditional BIOS, you have to be sitting in front of a physical computer to configure it.

2. 如果我们透过SEC、PEI、DXE和BDS等等复杂的术语看幕后隐藏的本质，就会发现无论传统BIOS还是UEFI，阳光之下没有什么新鲜的东西，启动本身无外乎三个步骤：
    - Rom Stage：在这个阶段没有内存，需要在ROM上运行代码。这时因为没有内存，没有C语言运行需要的栈空间，开始往往是汇编语言，直接在ROM空间上运行。在找到个临时空间（Cache空间用作RAM，Cache As Ram, CAR）后，C语言终于可以登场了，后期用C语言初始化内存和为这个目的需要做的一切服务。
    - Ram Stage: 在经过 ROM阶段的困难情况后，我们终于有了可以大展拳脚的内存，很多额外需要大内存的东西可以开始运行了。在这时我们开始进行初始化芯片组、CPU、主板模块等等核心过程。
    - Find something to boot Stage: 终于要进入正题了，需要启动，我们找到启动设备。就要枚举设备，发现启动设备，并把启动设备之前需要依赖的节点统统打通。然后开始移交工作，Windows或者Linux的时代开始。

3. 这就引出了BIOS和UEFI的最主要的功能：初始化硬件和提供硬件的软件抽象。
    - ARM体系也要初始化具体主板相关硬件如GPIO和内存等，这些一般在BSP中完成。与X86体系不同之处在于这些硬件完全定制化，初始化的时候就预先知道有哪些设备，Solder Down了哪个品牌的哪种内存颗粒，到时候就照方抓药，初始化一大堆寄存器而已。X86系统配置情况在开机时候是不知道的，需要探测（Probe）、Training(内存和PCIe)和枚举（PCIe等等即插即用设备），相对较复杂。
    - BIOS和UEFI提供了整个主板、包括主板上外插的设备的软件抽象。通过探测、Training和枚举，BIOS就有了系统所有硬件的信息。它通过几组详细定义好的接口，把这些信息抽象后传递给操作系统，这些信息包括SMBIOS（专栏稍后介绍）、ACPI表（ACPI与UEFI），内存映射表（E820或者UEFI运行时）等等。通过这层映射，才能做到做到操作系统完全不改而能够适配到所有机型和硬件。

4. UEFI扫除了传统BIOS割裂的生态，打通了PC固件之间的鸿沟，并提供统一的接口给操作系统，而不关心操作系统是什么；它能够更好的完成PC固件的终极目的：**初始化硬件和提供硬件的软件抽象，和启动操作系统**。如果说有什么东西帮助UEFI打败了传统BIOS，那这些东西就是：**标准接口、开放统一和开源**了。

### References for UEFI

1. [UEFI boot: how does that actually work, then?](https://www.happyassassin.net/posts/2014/01/25/uefi-boot-how-does-that-actually-work-then/)
2. [UEFI 引导与 传统BIOS 引导在原理上有什么区别？芯片公司在其中扮演什么角色？](https://zhuanlan.zhihu.com/p/81960137)
3. [UEFI架构](https://zhuanlan.zhihu.com/p/25941528)
4. [UEFI与硬件初始化](https://zhuanlan.zhihu.com/p/25941340)
5. [Coping with the UEFI Boot Process](https://www.linux-magazine.com/Online/Features/Coping-with-the-UEFI-Boot-Process)


### Questions for UEFI

1. UEFI 运行过程中的内存管理？
2. ESP是何时挂载的？

## Boot loader

1. 硬盘第一个扇区的前 512 个字节是主引导扇区，由 446 字节的 MBR、64 字节的分区表和 2 字节的结束标志组成。
    - MBR（Master Boot Record）是 446 字节的引导代码，被 BIOS 加载到 0x00007C00 并执行。
    - 硬盘分区表占据主引导扇区的 64 个字节（0x01BE -- 0x01FD)，可以对四个分区的信息进行描述，其中每个分区的信息占据 16 个字节。
    - 结束标志字 55，AA（0x1FEH -- 0x1FFH）是主引导扇区的最后两个字节，是检验主引导记录是否有效的标志。

2. 一个分区记录有如下域：
    - 1字节 文件系统类型
    - 1字节 可引导标志
    - 6字节 CHS格式描述符
    - 8字节 LBA格式描述符

3. LBA和CHS两种描述符指示相同的信息，但是指示方式有所不同：
    - LBA (逻辑块寻址，Logical Block Addressing)指示分区的起始扇区和分区长度
    - CHS(柱面 磁头 扇区)指示首扇区和末扇区。

### GRUB

1. GRUB 的引导过程分为 stage1、stage 1.5 和 stage 2。其中 stage1 和可能存在的 stage1.5 是为 stage2 做准备，stage2 像一个微型操作系统。

2. Stage 1
    - BIOS 加载 GRUB stage1（如果安装到 MBR）到 0x00007C00.
    - stage1 位于 stage1/stage1.S，汇编后形成 512 字节的二进制文件，写入硬盘的0面0道第1扇区。
    - stage1 将0面0道第2扇区上的 512 字节读到内存中的0x00007000处，然后调用 COPY_BUFFER 将其拷贝到 0x00008000 的位置上，然后跳至 0x00008000 执行。这 512 字节代码来自 stage2/start.S，作用是 stage1_5 或者 stage2（编译时决定加载哪个）的加载器。

3. Stage 1.5
    - Stage 1.5 能够读取文件系统（Stage 1.5包含有文件系统驱动），负责从文件系统中载入并执行 stage 2，即 GRUB 的核心映像。由于系统引导过程中不需要修改文件系统，因此只实现了文件系统的读取。
    - 可以说，stage 1.5 是 stage 1 与 stage 2 之间的桥梁，解决了文件系统这个“先有鸡还是先有蛋”的问题。

4. Stage 2
    - 读取一个启动配置文件（GRUB中的grub.conf，Windows中的boot.ini），并在启动选择多于一个时呈现出一个启动选择界面。
    - stage2 将系统切换到保护模式，设置 C 运行环境，寻找 config 文件，执行 shell 接受用户命令，载入选定的操作系统内核。

5. The legacy MBR partition table supports a maximum of four partitions and occupies 64 bytes, combined. Together with the optional disk signature (four bytes) and disk timestamp (six bytes), this leaves between 434 and 446 bytes available for the machine code of a boot loader. Although such a small space can be sufficient for very simple boot loaders, it is not big enough to contain a boot loader supporting complex and multiple file systems, menu-driven selection of boot choices, etc. Boot loaders with bigger footprints are thus split into pieces, where the smallest piece fits into and resides within the MBR, while larger piece(s) are stored in other locations (for example, into empty sectors between the MBR and the first partition) and invoked by the boot loader's MBR code.

6. Boot settings are stored in NVRAM, which on classic PCs was also known as CMOS memory but on modern systems may actually use some technology other than CMOS.

### grub.efi

1. Typically, `EFI/ubuntu/grubx64.efi` on the EFI System Partition (ESP) is the GRUB binary, and `EFI/ubuntu/shimx64.efi` is the binary for shim. The latter is a relatively simple program that provides a way to boot on a computer with Secure Boot active. On such a computer, an unsigned version of GRUB won't launch, and signing GRUB with Microsoft's keys is impossible, so shim bridges the gap and adds its own security tools that parallel those of Secure Boot. In practice, shim registers itself with the firmware and then launches a program called grubx64.efi in the directory from which it was launched, so on a computer without Secure Boot (such as a Mac), launching shimx64.efi is just like launching grubx64.efi. On a computer with Secure Boot active, launching shimx64.efi should result in GRUB starting up, whereas launching grubx64.efi directly probably won't work.

2. Differences between efi files
    - `EFI/boot/bootx64.efi`: Fallback bootloader path. This is the only bootloader pathname that the UEFI firmware on 64-bit X86 systems will look for without any pre-existing NVRAM boot settings, so this is what you want to use on removable media.
    - `EFI/Ubuntu/grubx64.efi`: Bootloader path for a permanently installed OS.
    - `/boot/grub/x86_64-efi/grub.efi`: A temporary file for `grub-install`. The copy in `/boot/grub/x86_64-efi/*.efi` will not be used at all in the boot process, but it might be useful if the ESP gets damaged for any reason.
    - `EFI/Ubuntu/shimx64.efi`: Secure Boot .

3. When installing the bootloader, four things are written to the NVRAM memory that holds the firmware settings:
    - Bootloader pathname on the EFI System Partition (ESP) that holds the bootloader(s)
    - The GUID of the ESP partition
    - A descriptive (human-friendly) name for this particular bootloader instance
    - Optionally, some data for the bootloader

4. The UEFI-based platform reads the partition table on the system storage and **mounts** the EFI System Partition (ESP), a VFAT partition labeled with a particular globally unique identifier (GUID). The ESP contains EFI applications such as bootloaders and utility software, stored in directories specific to software vendors.

#### References for grub.efi

1. [What is the difference between grubx64 and shimx64?](https://askubuntu.com/questions/342365/what-is-the-difference-between-grubx64-and-shimx64)
2. [EFI\boot\bootx64.efi vs EFI\ubuntu\grubx64.efi vs /boot/grub/x86_64-efi/grub.efi vs C:\Windows\Boot\EFI](https://unix.stackexchange.com/questions/565615/efi-boot-bootx64-efi-vs-efi-ubuntu-grubx64-efi-vs-boot-grub-x86-64-efi-grub-efi)
3. [Managing EFI Boot Loaders for Linux](http://www.rodsbooks.com/efi-bootloaders/)

### 内核引导过程

#### 1 内核设置

源码位于`arch/x86/boot/header.S`的`start_of_setup`

1. 设置段寄存器
2. 设置堆栈
3. 设置BSS段（静态变量区）
4. 跳转到main函数

#### 2 内核启动在实模式下的工作

- 控制台初始化
- 堆初始化
- 内存分布侦测
- 键盘初始化
- 系统参数查询
- 设置显示模式

#### 3 内核启动从实模式切换到保护模式

- 禁止NMI中断
- 使能A20地址线
- 设置中断描述符表
- 设置全局描述符表
- 切换进入保护模式

#### 4 切换到64位模式

- 必要时重新加载内存段寄存器
- 栈的建立和CPU的确认
- 计算重定位地址
- 进入长模式前的准备工作
- 初期页表初始化
- 切换到长模式

#### 5 内核解压

### 内核初始化流程

`start_kernel`函数的主要目的是完成内核初始化并启动祖先进程(1号进程)。在祖先进程启动之前`start_kernel`函数做了很多事情，如锁验证器,根据处理器标识ID初始化处理器，开启cgroups子系统，设置每CPU区域环境，初始化VFS Cache机制，初始化内存管理，rcu,vmalloc,scheduler(调度器),IRQs(中断向量表),ACPI(中断可编程控制器)以及其它很多子系统。

- 初期中断和异常处理
- 初始化内存页


## 参考资料

1. [Linux源代码阅读——内核引导](http://home.ustc.edu.cn/~boj/courses/linux_kernel/1_boot.html)
2. [【译】计算机启动过程 – How Computers Boot Up](http://blog.kongfy.com/2014/03/%E8%AF%91%E8%AE%A1%E7%AE%97%E6%9C%BA%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B-how-computers-boot-up/)
3. [《Linux内核修炼之道》第4章“系统初始化”](http://reader.epubee.com/books/mobile/bf/bf988d31c8fcba1f1ecdc622808256f4/text00013.html)
