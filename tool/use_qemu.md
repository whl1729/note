# QEMU使用笔记

参考资料：

1. [QEMU manual](https://wiki.qemu.org/Qemu-doc.html)

2. [QEMU User Documents](https://qemu.weilnetz.de/doc/qemu-doc.html)

3. [Qemu安装使用手册](https://wenku.baidu.com/view/04c0116aa45177232f60a2eb.html)

## 选项

- `-hda file` Use file as hard disk 0 image

- `-parallel dev` Redirect the virtual parallel port to host device dev (same devices as the serial port). On Linux hosts, /dev/parportN can be used to use hardware devices connected on the corresponding host parallel port. This option can be used several times to simulate up to 3 parallel ports. Use `-parallel none` to disable all parallel ports.

- `-serial dev` Redirect the virtual serial port to host character device dev. The default device is vc in graphical mode and stdio in non graphical mode. This option can be used several times to simulate up to 4 serial ports. Use `-serial none` to disable all serial ports.

- `-s` 等待gdb连接到端口1234

- `-S` Do not start CPU at startup (you must type ’c’ in the monitor).
