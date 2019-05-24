# 《xv6》第0章“Operating system interfaces”读书笔记

## 前言

1. 操作系统管理和抽象硬件：“The operating system manages and abstracts the low-level hardware, so that, for example, a word processor need not concern itself with which type of disk hardware is being used. ”

2. 如何将接口设计得既简洁又强大：“The trick in resolving this tension is to design interfaces that rely on a few mechanisms that can be combined to provide much generality.”

3. Each running program, called a process, has memory containing instructions, data, and a stack.

4. 硬件保护机制：
    * The kernel uses the CPU’s hardware protection mechanisms to ensure that each process executing in user space can access only its own memory. The kernel executes with the hardware privileges required to implement these protections; user programs execute without those privileges.
    * the memory protection unit: a hardware component that assigns privilege levels to blocks of memory and ensures that only programs with the appropriate privilege level can access each block.

5. 内核提供给用户程序的接口就是系统调用
    * “The collection of system calls that a kernel provides is the interface that user programs see.”
    * The fact that the shell is a user program, not part of the kernel, illustrates the power of the system call interface: there is nothing special about the shell. 

System call  | Description
------------ | -----------
fork()  |  Create a process
exit()  |  Terminate the current process
wait()  |  Wait for a child process to exit
kill(pid)  |  Terminate process pid
getpid()  |  Return the current process’s pid
sleep(n)  |  Sleep for n clock ticks
exec(filename, \*argv)  |  Load a file and execute it
sbrk(n)  |  Grow process’s memory by n bytes
open(filename, flags)  |  Open a file; the flags indicate read/write
read(fd, buf, n)  |  Read n bytes from an open file into buf
write(fd, buf, n)  |  Write n bytes to an open file
close(fd)  |  Release open file fd
dup(fd)  |  Duplicate fd
pipe(p)  |  Create a pipe and return fd’s in p
chdir(dirname)  |  Change the current directory
mkdir(dirname)  |  Create a new directory
mknod(name, major, minor)  |  Create a device file
fstat(fd)  |  Return info about an open file
link(f1, f2)  |  Create another name (f2)  |  for the file f1
unlink(filename)  |  Remove a file

## Process and memory

1. fork vs exec
    * Fork creates a new process, called the child process, with exactly the same memory contents as the calling process, called the parent process. Fork returns in both the parent and the child. In the parent, fork returns the child’s pid; in the child, it returns zero. 
    * The exec system call replaces the calling process’s memory with a new memory image loaded from a file stored in the file system.
    * fork starts a new process which is a copy of the one that calls it, while exec replaces the current process image with another (different) one.
    * Both parent and child processes are executed simultaneously in case of fork() while Control never returns to the original program unless there is an exec() error.

2. The exit system call causes the calling process to stop executing and to release resources such as memory and open files.

3. The wait system call returns the pid of an exited child of the current process; if none of the caller’s children has exited, wait waits for one to do so.

4. Most programs ignore the first argument of exec, which is conventionally the name of the program. 

## I/O and File descriptors

1. A file descriptor is a small integer representing a kernel-managed object that a process may read from or write to. 

2. 文件描述符使得读写各种设备变得简单
    * the file descriptor interface abstracts away the differences between files, pipes, and devices, making them all look like streams of bytes.
    * File descriptors are a powerful abstraction, because they hide the details of what they are connected to.
    * An example: The cat command doesn’t know whether it is reading from a file, console, or a pipe. Similarly cat doesn’t know whether it is printing to a console, a file, or whatever. The use of file descriptors and the convention that file descriptor 0 is input and file descriptor 1 is output allows a simple implementation of cat.

3. the xv6 kernel uses the file descriptor as an index into a per-process table, so that every process has a private space of file descriptors starting at zero. 

4. 每个文件描述符都会有个内部变量offset，记录文件读写的具体位置：“Each file descriptor that refers to a file has an offset associated with it.”

5. The close system call releases a file descriptor, making it free for reuse by a future open, pipe, or dup system call (see below). A newly allocated file descriptor is always the lowest-numbered unused descriptor of the current process.

6. 调试发现，使用exec时传入的第一个参数要使用绝对路径，否则会识别不了。
```
    execv("/bin/cat", argv);  // ok
    execv("cat", argv);       // not work
```

7. why it is a good idea that fork and exec are separate calls. 
    * Because if they are separate, the shell can fork a child, use open, close, dup in the child to change the standard input and output file descriptors, and then exec. No changes to the program being exec-ed (cat in our example) are required. 
    * If fork and exec were combined into a single system call, some other (probably more complex) scheme would be required for the shell to redirect standard input and output, or the program itself would have to understand how to redirect I/O.

8. Although fork copies the file descriptor table, each underlying file offset is shared between parent and child. 

9. Two file descriptors share an offset if they were derived from the same original file descriptor by a sequence of fork and dup calls. Otherwise file descriptors do not share offsets, even if they resulted from open calls for the same file. 

10. The `2>&1` tells the shell to give the command a file descriptor 2 that is a duplicate of descriptor 1. 

## Pipes

1. A pipe is a small kernel buffer exposed to processes as a pair of file descriptors, one for reading and one for writing. Writing data to one end of the pipe makes that data available for reading from the other end of the pipe. 

2. Pipes have at least four advantages over temporary files in this situation. 
    * First, pipes automatically clean themselves up; with the file redirection, a shell would have to be careful to remove /tmp/xyz when done. 
    * Second, pipes can pass arbitrarily long streams of data, while file redirection requires enough free space on disk to store all the data. 
    * Third, pipes allow for parallel execution of pipeline stages, while the file approach requires the first program to finish before the second starts. 
    * Fourth, if you are implementing inter-process communication, pipes’ blocking reads and writes are more efficient than the non-blocking semantics of files.
